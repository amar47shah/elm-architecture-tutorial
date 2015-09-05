module CounterPairTriple where

import CounterPair
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
    { leftCounterPair   : CounterPair.Model
    , middleCounterPair : CounterPair.Model
    , rightCounterPair  : CounterPair.Model
    }


init : (Int, Int) -> (Int, Int) -> (Int, Int) -> Model
init left middle right =
    { leftCounterPair   = uncurry CounterPair.init left
    , middleCounterPair = uncurry CounterPair.init middle
    , rightCounterPair  = uncurry CounterPair.init right
    }


-- UPDATE

type Action
    = Left   CounterPair.Action
    | Middle CounterPair.Action
    | Right  CounterPair.Action


update : Action -> Model -> Model
update action model =
  case action of
    Left   act ->
      { model |
          leftCounterPair   = CounterPair.update act model.leftCounterPair
      }
    Middle act ->
      { model |
          middleCounterPair = CounterPair.update act model.middleCounterPair
      }
    Right act ->
      { model |
          rightCounterPair  = CounterPair.update act model.rightCounterPair
      }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ pairView address Left   model.leftCounterPair
    , pairView address Middle model.middleCounterPair
    , pairView address Right  model.rightCounterPair
    ]

pairView : Signal.Address Action ->
           (CounterPair.Action -> Action) ->
           CounterPair.Model ->
           Html
pairView dest route pair =
  div [ horizontal ] [ CounterPair.view (Signal.forwardTo dest route) pair ]

horizontal : Attribute
horizontal = style [ ("display", "inline-block") ]
