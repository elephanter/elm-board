module Game exposing (..)

import Html exposing (Html, text)
import Html.App as Html
import Html exposing (..)
import AnimationFrame
import Collage exposing (collage)
import Element exposing (toHtml)
import Time exposing (Time)
import Window exposing (Size)
import Debug exposing (log)
import Task
import Process
import Models exposing (Point)
import Board


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { -- Window dimensions
      windowSize :
        Size
        -- Center point position of the screen
    , centerPosition :
        Point
    , board :
        Board.Model
    }


model : Model
model =
    { windowSize = Size 0 0
    , board = Board.emptyBoard
    , centerPosition = Point 0 0
    }


init : ( Model, Cmd Msg )
init =
    ( model
    , Task.perform
        identity
        Resize
        (Process.sleep 100 `Task.andThen` \_ -> Window.size)
    )



-- UPDATE


type Msg
    = Resize Size
    | BoardMsg Board.Msg
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            { model | windowSize = log "BoardSize " size }
                ! [ updateBoard (Board.Resize size) ]

        BoardMsg boardMessage ->
            ( { model | board = fst <| Board.update boardMessage model.board }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- Send messages to our board


updateBoard cmd =
    Task.perform BoardMsg BoardMsg (Task.succeed cmd)



-- VIEW


view : Model -> Html Msg
view model =
    toHtml <|
        collage model.windowSize.width model.windowSize.height [ Board.view model.board ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes Resize
        , Sub.map BoardMsg (Board.subscriptions model.board)
        ]
