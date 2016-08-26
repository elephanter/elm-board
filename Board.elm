module Board exposing (Model, Msg, update, view, model)

import Html exposing (..)
import Mouse
import AnimationFrame
import Time exposing (Time)
import Collage exposing (..)
import Color exposing (..)
import Cell
import Models exposing (Dimensions, Point, GameSettings)


-- MODEL


type alias Model =
    { cells : List Cell.Model
    , -- List of displayed cells
      gameSettings : GameSettings
    , viewSize : Dimensions
    , -- visible view dimensions of the board
      centerPoint :
        Point
        -- current center point of the view
    }


model : Model
model =
    { cells = []
    , gameSettings = { boardSize = { width = 100, height = 100 } }
    , viewSize = { width = 100, height = 100 }
    , centerPoint = { x = 50, y = 50 }
    }



-- UPDATE


type Msg
    = TimeUpdate Time


update : Msg -> Model -> Model
update msg model =
    case msg of
        TimeUpdate time ->
            model



-- VIEW


view : Model -> Shape
view model =
    square 100



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        ]
