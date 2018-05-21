module Component.Header exposing (view)

import Html exposing (..)
import Html.Attributes exposing (id, class, href, placeholder, attribute, type_, classList)
import Route exposing (Route)
import Model.Page as ActivePage exposing (PageType(..))

view : ActivePage.PageType -> Html msg
view page =
    let
        linkTo =
            navbarLink page
    in
        nav [ class "navbar navbar-expand-lg navbar-light bg-light" ]
            [ a [ class "navbar-brand", Route.href Route.Login ]
                [ text "Elm" ]
            , button [ attribute "aria-controls" "navbarSupportedContent", attribute "aria-expanded" "false", attribute "aria-label" "Toggle navigation", class "navbar-toggler", attribute "data-target" "#navbarSupportedContent", attribute "data-toggle" "collapse", type_ "button" ]
                [ span [ class "navbar-toggler-icon" ]
                    []
                ]
            , div [ class "collapse navbar-collapse", id "navbarSupportedContent" ]
                [ ul [ class "navbar-nav ml-auto" ]
                    [ linkTo Route.Login [ text "Home" ]
                    ]
                ]
            ]


navbarLink : ActivePage.PageType -> Route -> List (Html msg) -> Html msg
navbarLink page route linkContent =
    li [ class "nav-item", classList [ ( "active", isActive route ) ] ]
        [ a [ class "nav-link", Route.href route ] linkContent ]


isActive : Route -> Bool
isActive route =
    case route of
        Route.Login ->
            True