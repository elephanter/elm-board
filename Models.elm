module Models exposing (Cell, Point, Dimensions, GameSettings)


type alias Point =
    { x : Int
    , y : Int
    }


type alias Dimensions =
    { width : Int
    , height : Int
    }


type alias Cell =
    { id : String
    , side : Int
    }


type alias GameSettings =
    { boardSize : Dimensions
    , cellSize : Int
    }
