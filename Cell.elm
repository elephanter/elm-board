module Cell exposing (Model, Msg, update, view)

import Html exposing (..)
import Mouse
import Time exposing (Time)
import AnimationFrame
import Collage exposing (..)
import Color exposing (..)
import Models exposing (Cell, Point)


-- MODEL


type alias Model =
    { -- TopLeft point position of square celln
      position : Point
    , cell : Cell
    }


emptyModel =
    { position = Point 0 0
    , cell =
        { id = ""
        , side = 0
        }
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
    square 50
        |> filled red
        |> scale 1
        |> move ( model.position.x, model.position.y )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Mouse.clicks MouseClick
        ]
