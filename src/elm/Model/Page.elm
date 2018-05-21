module Model.Page exposing (..)


type PageType
    = BlankPage
    | NotFoundPage
    | LoginPage LoginModel


type PageState
    = Loaded PageType
    | TransitioningFrom PageType


type ActivePage
    = Other
    | Login
    | About


type alias LoginModel =
    { username : String
    , password : String
    }


type alias ErrorModel =
    { errorCode : Int
    , errorMessage : String
    }

