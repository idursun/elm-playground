module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onWithOptions, keyCode)
import Components.Hero as Hero exposing (hero, Msg)
import Keyboard
import Char
import Json.Decode as Json
import Html.Attributes exposing (..)
import String exposing (..)


--import Html.Events exposing ( onClick, on, keyCode )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch []


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


type alias Model =
    { name : String
    , heroes : List String
    , selecteds: List String
    }


heroNames : List String
heroNames =
    [ "abaddon"
    , "alchemist"
    , "arc-warden"
    , "ancient-apparition"
    , "anti-mage"
    , "axe"
    , "bane"
    , "batrider"
    , "beastmaster"
    , "bloodseeker"
    , "bounty-hunter"
    , "brewmaster"
    , "bristleback"
    , "broodmother"
    , "centaur-warrunner"
    , "chaos-knight"
    , "chen"
    , "clinkz"
    , "clockwerk"
    , "crystal-maiden"
    , "dark-seer"
    , "dazzle"
    , "death-prophet"
    , "disruptor"
    , "doom"
    , "dragon-knight"
    , "drow-ranger"
    , "earth-spirit"
    , "earthshaker"
    , "elder-titan"
    , "ember-spirit"
    , "enchantress"
    , "enigma"
    , "faceless-void"
    , "gyrocopter"
    , "huskar"
    , "invoker"
    , "io"
    , "jakiro"
    , "juggernaut"
    , "keeper-of-the-light"
    , "kunkka"
    , "legion-commander"
    , "leshrac"
    , "lich"
    , "lifestealer"
    , "lina"
    , "lion"
    , "lone-druid"
    , "luna"
    , "lycan"
    , "magnus"
    , "medusa"
    , "meepo"
    , "mirana"
    , "morphling"
    , "naga-siren"
    , "natures-prophet"
    , "necrophos"
    , "night-stalker"
    , "nyx-assassin"
    , "ogre-magi"
    , "omniknight"
    , "oracle"
    , "outworld-devourer"
    , "phantom-assassin"
    , "phantom-lancer"
    , "phoenix"
    , "puck"
    , "pudge"
    , "pugna"
    , "queen-of-pain"
    , "razor"
    , "riki"
    , "rubick"
    , "sand-king"
    , "shadow-demon"
    , "shadow-fiend"
    , "shadow-shaman"
    , "silencer"
    , "skywrath-mage"
    , "slardar"
    , "slark"
    , "sniper"
    , "spectre"
    , "spirit-breaker"
    , "storm-spirit"
    , "sven"
    , "techies"
    , "templar-assassin"
    , "terrorblade"
    , "tidehunter"
    , "timbersaw"
    , "tinker"
    , "tiny"
    , "treant-protector"
    , "troll-warlord"
    , "tusk"
    , "undying"
    , "ursa"
    , "vengeful-spirit"
    , "venomancer"
    , "viper"
    , "visage"
    , "warlock"
    , "weaver"
    , "windranger"
    , "winter-wyvern"
    , "witch-doctor"
    , "wraith-king"
    , "zeus"
    ]


model : Model
model =
    Model "" heroNames []

type Msg
    = Clear
    | Enter
    | KeyMsg Keyboard.KeyCode

pickFirstHero : List String -> List String
pickFirstHero heroes = case List.head heroes of
  Just a -> [a]
  Nothing -> []

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyMsg code ->
            if code == 8 then
                update Clear model
            else if code == 13 then
                update Enter model
            else
                ( { model
                    | name = (String.toList model.name) ++ [ Char.fromCode code ] |> String.fromList
                    , heroes =
                        case String.isEmpty model.name of
                            False ->
                                heroNames |> List.filter (\x -> String.toUpper x |> String.startsWith model.name)

                            True ->
                                heroNames
                  }
                , Cmd.none)

        Clear ->
            ( { model | heroes = heroNames, name = "", selecteds= model.selecteds}, Cmd.none )

        Enter -> 
            ( { model | heroes = heroNames, name = "", selecteds =  model.selecteds ++ model.heroes  }, Cmd.none )


onKeyDown tagger =
    onWithOptions "keydown" { preventDefault = True, stopPropagation = True } (Json.map tagger keyCode)


view : Model -> Html Msg
view model =
    let
        visibleHeroes =
            List.map hero model.heroes
    in
        div [ autofocus True, onKeyDown KeyMsg ]
            [ button [ autofocus True ] [ text "click on me" ]
            , span [] [ text (toString model.name) ]
            , div [ style [ ( "display", "flex" ), ( "flex-wrap", "wrap" ) ] ] visibleHeroes
            , div [] (model.selecteds |> List.map (\x -> li [] [text x])) 
            ]
