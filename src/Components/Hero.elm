module Components.Hero exposing (hero, Msg)

import Html exposing(Html,div, text, node, img)
import Html.Attributes exposing (..)

type Msg = NoOp

hero : String -> Html a
hero name = 
    div [style [("color", "white"), ("border", "1px solid red"), ("height","72px"), ("width", "128px"), ("margin", "5px"), ("background", "url(../../assets/abaddon.png) no-repeat center")]] [
         text name
    ]