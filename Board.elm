module Board exposing (Model, Msg, update, view, emptyBoard)

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


emptyBoard : Model
emptyBoard =
    { cells = []
    , gameSettings = { boardSize = { width = 0, height = 0 } }
    , viewSize = { width = 0, height = 0 }
    , centerPoint = { x = 0, y = 0 }
    }



-- UPDATE


type Msg
    = TimeUpdate Time
    | Resize Dimensions


update : Msg -> Model -> Model
update msg model =
    case msg of
        TimeUpdate time ->
            model

        Resize dimensions ->
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
