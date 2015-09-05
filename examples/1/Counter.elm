module Counter where

import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


-- MODEL

type alias Model = Int


-- UPDATE

type Action = Increment | IncrementFive | Decrement | DecrementFive

update : Action -> Model -> Model
update action model =
  case action of
    Increment     -> model + 1
    Decrement     -> model - 1
    IncrementFive -> model + 5
    DecrementFive -> model - 5


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [ onClick address DecrementFive ] [ text "-5" ]
    , button [ onClick address Decrement     ] [ text "-"  ]
    , div [ countStyle ] [ text (toString model) ]
    , button [ onClick address Increment     ] [ text "+"  ]
    , button [ onClick address IncrementFive ] [ text "+5" ]
    ]


countStyle : Attribute
countStyle =
  style
    [ ("font-size", "50px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "100px")
    , ("text-align", "center")
    ]
