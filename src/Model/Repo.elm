module Model.Repo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, required, style)
import Json.Decode as De
import String exposing (String)


type alias Repo =
    { name : String
    , description : Maybe String
    , url : String
    , pushedAt : String
    , stars : Int
    }


view : Repo -> Html msg
view repo =
    div [ class "repo" ]
        [ h2 [ style "background-color" "LightCyan", class "repo-name" ] [ text repo.name ]
        , p [ class "repo-description" ] [ text (Maybe.withDefault "" repo.description) ]
        , p [ class "repo-url" ]
            [ a [ href repo.url ] [ text "link" ]
            ]
        , p [ class "repo-stars" ] [ text ("stars: " ++ String.fromInt repo.stars) ]
        ]


sortByStars : List Repo -> List Repo
sortByStars repos =
    List.sortWith (\repo1 repo2 -> Basics.compare repo1.stars repo2.stars) repos


{-| Deserializes a JSON object to a `Repo`.
Field mapping (JSON -> Elm):

  - name -> name
  - description -> description
  - html\_url -> url
  - pushed\_at -> pushedAt
  - stargazers\_count -> stars

-}
decodeRepo : De.Decoder Repo
decodeRepo =
    De.map5 Repo
        (De.field "name" De.string)
        (De.field "description" (De.maybe De.string))
        (De.field "html_url" De.string)
        (De.field "pushed_at" De.string)
        (De.field "stargazers_count" De.int)
