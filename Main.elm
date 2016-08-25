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


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }

-- MODEL
type alias Position = {x: Float, y: Float }
type alias Model =
    { 
     windowSize : Size,
     playerPosition : Position 
    }

model : Model
model =
    { 
     windowSize = Size 0 0
     , playerPosition = {x= 0, y= 0}
    }

init : ( Model, Cmd Msg )
init =
    ( model, Task.perform (\_ -> NoOp) Resize (Window.size) )

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
            ({ model | windowSize = size }, Cmd.none)
        
        TimeUpdate dt ->
            ( model, Cmd.none )

        KeyDown keyCode ->
            ( {model | playerPosition = keyDown keyCode model.playerPosition}, Cmd.none )
        
        NoOp -> 
            (model, Cmd.none )

keyDown : KeyCode -> Position -> Position
keyDown keyCode position =
    case Key.fromCode keyCode of

        ArrowLeft ->
            { position |  x = position.x - 1 }

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