module Models exposing (Cell, Point, Dimensions, GameSettings)


type alias Point =
    { x : Float
    , y : Float
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
    }
