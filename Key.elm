module Key exposing (..)


type Key
    = Space
    | ArrowLeft
    | ArrowRight
    | ArrowDown
    | ArrowUp
    | Unknown


fromCode : Int -> Key
fromCode keyCode =
    case keyCode of
        32 ->
            Space

        37 ->
            ArrowLeft

        39 ->
            ArrowRight

        40 ->
            ArrowDown

        38 ->
            ArrowUp

        _ ->
            Unknown