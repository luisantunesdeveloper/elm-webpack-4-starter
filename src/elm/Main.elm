module Main exposing (..)

import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Navigation exposing (Location)
import Route exposing (..)
import Task
import Util exposing ((=>))
import Model.Page exposing(ActivePage(..), PageState(..), PageType(..), LoginModel, ErrorModel)
import Layout.HeaderLess as Layout
import Page.Login as Login
import Page.NotFound as NotFound
import Page.Blank as Blank


-- MODEL --


{-
This model only contains the PageState
-}
type alias Model =
    { pageState : PageState
    }


-- VIEW --


{-
Called everytime the Router is called
on a page change
-}
view : Model -> Html Msg
view model =
    case model.pageState of
        Loaded page ->
            viewPage False page

        TransitioningFrom page ->
            viewPage True page
            

{-
TODO: The Main should not be coupled here. Only the page knows which layout it wants.
Render the page asked by the Router
-}
viewPage : Bool -> PageType -> Html Msg
viewPage isLoading page =
    case page of
        NotFoundPage ->
            NotFound.view

        BlankPage ->
            -- This is for the very intial page load, while we are loading
            -- data via HTTP. We could also render a spinner here.
            Blank.view

        -- ErrorPage ->
        --     Error.view
        --         |> layout ErrorPage

        LoginPage subModel ->
            Login.view isLoading subModel
                |> Html.map LoginMsg


-- UPDATE --


{-
The Actions that are fired upon a Command
-}
type Msg
    = SetRoute (Maybe Route)
    | LoginMsg Login.Msg


{-
Updates the page state accordingly
-}
setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute route model =
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model.pageState) }
                => Task.attempt toMsg task

        -- errored =
        --     pageError model
    in
        case route of
            Nothing ->
                ( { model | pageState = Loaded NotFoundPage }, Cmd.none )

            Just Route.Login ->
                ( { model | pageState = Loaded (LoginPage Login.init) }, Cmd.none )


-- pageError : Model -> ActivePage -> String -> ( Model, Cmd msg )
-- pageError model activePage errorMessage =
--     let
--         error =
--             ErrorPage.pageLoadError activePage errorMessage
--     in
--         { model | pageState = Loaded (Error error) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    updatePage (getPage model.pageState) msg model


getPage : PageState -> PageType
getPage pageState =
    case pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


updatePage : PageType -> Msg -> Model -> ( Model, Cmd Msg )
updatePage page msg model =
    let
        toPage toModel toMsg subUpdate subMsg subModel =
            let
                ( newModel, newCmd ) =
                    subUpdate subMsg subModel
            in
                ( { model | pageState = Loaded (toModel newModel) }, Cmd.map toMsg newCmd )

        -- errored =
        --     pageError model
    in
        case ( msg, page ) of
            -- Update for page transitions
            ( SetRoute route, _ ) ->
                setRoute route model

            -- Update for page specfic msgs
            ( LoginMsg subMsg, LoginPage subModel ) ->
                toPage LoginPage LoginMsg (Login.update) subMsg subModel

            ( _, NotFoundPage ) ->
                -- Disregard incoming messages when we're on the
                -- NotFound page.
                model => Cmd.none

            ( _, _ ) ->
                -- Disregard incoming messages that arrived for the wrong page
                model => Cmd.none



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- PROGRAM --


initialPage : PageType
initialPage =
    BlankPage


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded initialPage
        }


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
