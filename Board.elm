module Board exposing (Model, Msg(..), update, view, emptyBoard, subscriptions)

import Html exposing (..)
import Mouse
import AnimationFrame
import List exposing (map, concat)
import Time exposing (Time)
import Collage exposing (groupTransform, Form)
import Transform exposing (translation)
import List.Extra exposing (find)
import Debug exposing (log)
import Keyboard exposing (KeyCode)
import Color exposing (..)
import Task
import Cell
import Models exposing (Dimensions, Point, GameSettings)
import Key exposing (..)


-- MODEL


type alias Model =
    { -- List of displayed cells
      cells : List Cell.Model
    , gameSettings :
        GameSettings
        -- visible view dimensions of the board
    , viewSize :
        Dimensions
        -- current left bottom point of the view
    , lb : ( Float, Float )
    }


emptyBoard : Model
emptyBoard =
    { cells = []
    , gameSettings = { boardSize = { width = 0, height = 0 }, cellSize = 100 }
    , viewSize = { width = 0, height = 0 }
    , lb = ( 300.0, 300.0 )
    }



-- UPDATE


type Msg
    = Resize Dimensions
    | ChangePos ( Float, Float )
    | KeyDown KeyCode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize dimensions ->
            { model
                | cells = board dimensions model.gameSettings.cellSize model.cells
                , viewSize = dimensions
                , lb = ( toFloat (dimensions.width) / 2, toFloat (dimensions.height) / 2 )
            }
                ! []

        ChangePos point ->
            { model | lb = point } ! []

        KeyDown keyCode ->
            model ! [ msgSend ChangePos (keyDown keyCode model.lb) ]


msgSend msg data =
    Task.perform msg msg (Task.succeed data)



--Takes dimestion of the board
-- one cell size (it is square)
-- currently existed cells list
--Returns - new cell list


board : Dimensions -> Int -> List Cell.Model -> List Cell.Model
board dimensions cellSize cells =
    boardGen [0..ceiling (toFloat (dimensions.width) / toFloat (cellSize))] [0..ceiling (toFloat (dimensions.height) / toFloat (cellSize))]
        |> map
            (\( x, y ) ->
                let
                    foundedCell =
                        findCell cells ( x, y )
                in
                    { foundedCell | position = ( toFloat <| x * cellSize, toFloat <| y * cellSize ) }
            )



--Find cell by coords in list of cells


findCell : List Cell.Model -> ( Int, Int ) -> Cell.Model
findCell cells pos =
    case find (\x -> x.coords == pos) cells of
        Just model ->
            model

        Nothing ->
            { emptyCellModel | coords = pos }


emptyCellModel =
    Cell.emptyModel



--Generate board with coords:]
--[(0,0),(1,0),(2,0),(3,0)
--,(0,1),(1,1),(2,1),(3,1)
--,(0,2),(1,2),(2,2),(3,2)
--,(0,3),(1,3),(2,3),(3,3)]


boardGen : List Int -> List Int -> List ( Int, Int )
boardGen widthCells heightCells =
    concat <|
        map
            (\h ->
                map (\w -> ( w, h )) widthCells
            )
            heightCells


keyDown : KeyCode -> ( Float, Float ) -> ( Float, Float )
keyDown keyCode position =
    case Key.fromCode keyCode of
        ArrowLeft ->
            ( fst (position) - 1, snd position )

        ArrowRight ->
            ( fst (position) + 1, snd position )

        ArrowUp ->
            ( fst position, (snd position) - 1 )

        ArrowDown ->
            ( fst position, (snd position) + 1 )

        _ ->
            position



-- VIEW


view : Model -> Form
view model =
    List.map Cell.view model.cells
        |> groupTransform (translation (negate <| fst model.lb) (negate <| snd model.lb))



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown ]
