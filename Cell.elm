module Cell exposing (Model, emptyModel, Msg, update, view)

import Html exposing (..)
import Mouse
import Time exposing (Time)
import AnimationFrame
import Collage exposing (..)
import Color exposing (..)
import Models exposing (Cell, Point, GameSettings)


-- MODEL


type alias Model =
    { -- TopLeft point position of square celln
      coords : ( Int, Int )
    , position : ( Float, Float )
    , cell : Cell
    , cellSize : Int
    }


emptyModel =
    { coords = ( 0, 0 )
    , position = ( 0, 0 )
    , cell =
        { id = ""
        , side = 0
        }
    , cellSize = 100
    }



-- UPDATE


type Msg
    = TimeUpdate Time
    | MouseClick Mouse.Position


update : Msg -> Model -> Model
update msg model =
    case msg of
        TimeUpdate time ->
            model

        MouseClick pos ->
            model



-- VIEW


view : Model -> Form
view model =
    group
        [ square (toFloat (model.cellSize))
            |> filled red
            |> move ( fst (model.position) - toFloat (model.cellSize) / 2, snd (model.position) - toFloat (model.cellSize) / 2 )
        , square (toFloat (model.cellSize))
            |> outlined (solid black)
            |> move ( fst (model.position) - toFloat (model.cellSize) / 2, snd (model.position) - toFloat (model.cellSize) / 2 )
        ]



-- 0,0 now it in left bottom point
-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Mouse.clicks MouseClick
        ]
