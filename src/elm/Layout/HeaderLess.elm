module Layout.HeaderLess exposing (set)

import Html exposing (..)
import Html.Attributes exposing (id, class, href, placeholder, attribute, type_, classList)
import Component.Header as Header
import Component.Footer as Footer
import Model.Page exposing (PageType(..))


{-| Take a page's Html and layout it with a header and footer.
isLoading can be used to slow loading during slow transitions
-}
set : Bool -> PageType -> Html msg -> Html msg
set isLoading page content =
    div []
        [ Header.view page
        , div [ class "container-fluid" ]
            [ content ]
        , Footer.view
        ]


viewFooter : Html msg
viewFooter =
    footer []
        [ div [] []
        ]
