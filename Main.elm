module Game exposing (..)

import Html exposing (Html, text)
import Html.App as Html
import Html exposing (..)
import Keyboard exposing (KeyCode)
import AnimationFrame
import Time exposing (Time)
import Key exposing (..)
import Window exposing (Size)
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
    , board = Board.model
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
    = TimeUpdate Time
    | KeyDown KeyCode
    | Resize Size
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Resize size ->
            ( { model | windowSize = size }, Cmd.none )

        TimeUpdate dt ->
            ( model, Cmd.none )

        KeyDown keyCode ->
            ( { model | centerPosition = keyDown keyCode model.centerPosition }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


keyDown : KeyCode -> Point -> Point
keyDown keyCode position =
    case Key.fromCode keyCode of
        ArrowLeft ->
            { position | x = position.x - 1 }

        ArrowRight ->
            { position | x = position.x + 1 }

        ArrowUp ->
            { position | y = position.y - 1 }

        ArrowDown ->
            { position | y = position.y + 1 }

        _ ->
            position



-- VIEW


view : Model -> Html msg
view model =
    text (toString model)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ AnimationFrame.diffs TimeUpdate
        , Keyboard.downs KeyDown
        , Window.resizes Resize
        ]
