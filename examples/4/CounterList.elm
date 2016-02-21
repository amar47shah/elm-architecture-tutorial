module CounterList where

import Counter
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
    { counters : List ( ID, Counter.Model )
    , nextID : ID
    }

type alias ID = Int


init : Model
init =
    { counters = []
    , nextID = 0
    }


-- UPDATE

type Action
    = Insert
    | Remove ID
    | Modify ID Counter.Action
    | ModifyAll Counter.Action


update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model |
          counters = ( model.nextID, Counter.init 0 ) :: model.counters,
          nextID = model.nextID + 1
      }

    Remove id ->
      { model |
          counters = List.filter (\(counterID, _) -> counterID /= id) model.counters
      }

    Modify id counterAction ->
      let updateCounter (counterID, counterModel) =
              if counterID == id then
                  (counterID, Counter.update counterAction counterModel)
              else
                (counterID, counterModel)
      in
          { model | counters = List.map updateCounter model.counters }

    ModifyAll counterAction ->
      let updateCounter (counterID, counterModel) =
          (counterID, Counter.update counterAction counterModel)
      in
         { model | counters = List.map updateCounter model.counters }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let counters = List.map (viewCounter address) model.counters
      insert = div [ insertStyle ] [ button [ onClick address Insert ] [ text "New" ] ]
      incrementAll =
        button [ onClick address (ModifyAll Counter.Increment) ] [ text "+" ]
      decrementAll =
        button [ onClick address (ModifyAll Counter.Decrement) ] [ text "-" ]
  in
      div [] ([decrementAll, insert, incrementAll] ++ counters)


viewCounter : Signal.Address Action -> (ID, Counter.Model) -> Html
viewCounter address (id, model) =
  let context =
        Counter.Context
          (Signal.forwardTo address (Modify id))
          (Signal.forwardTo address (always (Remove id)))
  in
      Counter.viewWithRemoveButton context model

insertStyle : Attribute
insertStyle =
  style
    [ ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]
