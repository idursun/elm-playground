module Components.Hero exposing (hero, Msg)

import Html exposing(Html,div, text, node)
import Html.Attributes exposing (..)

type Msg = NoOp

hero : String -> Html a
hero name = 
    div [style [("border", "1px solid red"), ("height","70px"), ("width", "70px"), ("margin", "5px")]] [text name]