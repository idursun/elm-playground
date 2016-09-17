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
import Consts exposing (heroNames)


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
    ( initialModel, Cmd.none )


type alias Model =
    { name : String
    , heroes : List String
    , selecteds : List String
    }


initialModel : Model
initialModel =
    Model "" heroNames []


type Msg
    = Clear
    | Enter
    | KeyMsg Keyboard.KeyCode


pickFirstHero : List String -> List String
pickFirstHero heroes =
    case List.head heroes of
        Just a ->
            [ a ]

        Nothing ->
            []


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        KeyMsg code ->
            case code of
                8 ->
                    update Clear model

                13 ->
                    update Enter model

                _ ->
                    ( { model
                        | name = (String.toList model.name) ++ [ Char.fromCode code ] |> String.fromList
                        , heroes =
                            case String.isEmpty model.name of
                                False ->
                                    heroNames |> List.filter (\x -> String.contains model.name (String.toUpper x))

                                True ->
                                    heroNames
                      }
                    , Cmd.none
                    )

        Clear ->
            ( { initialModel | selecteds = model.selecteds }, Cmd.none )

        Enter ->
            ( { initialModel | selecteds = model.selecteds ++ model.heroes }, Cmd.none )

onKeyDown : (Int -> a) -> Attribute a
onKeyDown tagger =
    onWithOptions "keydown" { preventDefault = True, stopPropagation = True } (Json.map tagger keyCode)


styles =
    { wrapper = [ ( "display", "flex" ), ( "flex-wrap", "wrap" ) ]
    }


view : Model -> Html Msg
view model =
    let
        visibleHeroes =
            List.map hero model.heroes
    in
        div [ onKeyDown KeyMsg ]
            [ button [] [ text "click on me" ]
            , span [] [ text (toString model.name) ]
            , div [ style styles.wrapper ] visibleHeroes
            , h1 [] [text "selecteds"]
            , div [] (model.selecteds |> List.map hero)
            ]
