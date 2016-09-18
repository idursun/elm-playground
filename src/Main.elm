module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Events exposing (onWithOptions, keyCode, onInput, onSubmit)
import Html.Attributes exposing (..)
import Components.Hero as Hero exposing (hero, Msg)
import String exposing (..)
import Consts exposing (heroNames)


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
    { filter : String
    , heroes : List String
    , selecteds : List String
    }


initialModel : Model
initialModel =
    Model "" heroNames []


type Msg
    = Clear
    | Submit
    | UpdateFilter String


pickFirstHero : List String -> List String
pickFirstHero heroes =
    case List.head heroes of
        Just a ->
            [ a ]

        Nothing ->
            []


containsHeroName filter name =
    let
        upperFilter =
            String.toUpper filter

        upperName =
            String.toUpper name
    in
        (String.contains upperFilter upperName || String.isEmpty filter)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateFilter filter ->
            ( { model
                | filter = filter
                , heroes = heroNames |> List.filter (containsHeroName filter)
              }
            , Cmd.none
            )

        Clear ->
            ( { initialModel | selecteds = model.selecteds }, Cmd.none )

        Submit ->
            ( { initialModel | selecteds = model.selecteds ++ model.heroes }, Cmd.none )


styles =
    { wrapper = [ ( "display", "flex" ), ( "flex-wrap", "wrap" ) ]
    }


view : Model -> Html Msg
view model =
    let
        visibleHeroes =
            List.map hero model.heroes
    in
        div []
            [ Html.form [ onSubmit Submit ]
                [ input [ onInput UpdateFilter, value model.filter ] []
                ]
            , div [ style styles.wrapper ] visibleHeroes
            , h1 [] [ text "selecteds" ]
            , div [] (model.selecteds |> List.map hero)
            ]
