module Page.Login exposing (view, update, init, Msg)

import Html exposing (..)
import Model.Page exposing (..)


-- MODEL --


type Msg =
    LogingIn


init : LoginModel
init =
    { password = ""
    , username = ""
    }


-- UPDATE --


update : Msg -> LoginModel -> ( LoginModel, Cmd Msg )
update msg model =
    case msg of
        LogingIn ->
            (model, Cmd.none) 



-- VIEW --


view : Bool -> LoginModel -> Html Msg
view isLoading model =
    div [
    ]
    [ text "Hello login"
    ]