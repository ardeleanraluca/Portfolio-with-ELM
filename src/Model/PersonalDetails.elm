module Model.PersonalDetails exposing (..)

import Html exposing (..)
import Html.Attributes exposing (align, attribute, class, classList, href, id, style)


type alias DetailWithName =
    { name : String
    , detail : String
    }


type alias PersonalDetails =
    { name : String
    , contacts : List DetailWithName
    , intro : String
    , socials : List DetailWithName
    }


view : PersonalDetails -> Html msg
view details =
    div []
        [ h1 [ style "background-color" "LightSkyBlue", id "name" ] [ text details.name ]
        , em [ id "intro" ] [ text details.intro ]
        , ul []
            (List.map (\i -> li [ class "contact-detail" ] [ text (i.name ++ " : " ++ i.detail) ]) details.contacts)
        , ul [] (List.map (\i -> li [ class "social-link" ] [ a [ href i.detail ] [ text i.name ] ]) details.socials)
        ]
