module Model.Event exposing (..)

import Html exposing (..)
import Html.Attributes exposing (align, class, classList, hidden, href, style)
import Model.Event.Category exposing (EventCategory(..))
import Model.Interval as Interval exposing (Interval)


type alias Event =
    { title : String
    , interval : Interval
    , description : Html Never
    , category : EventCategory
    , url : Maybe String
    , tags : List String
    , important : Bool
    }


categoryView : EventCategory -> Html Never
categoryView category =
    case category of
        Academic ->
            text "Academic"

        Work ->
            text "Work"

        Project ->
            text "Project"

        Award ->
            text "Award"


sortByInterval : List Event -> List Event
sortByInterval events =
    List.sortWith (\event1 event2 -> Interval.compare event1.interval event2.interval) events


view : Event -> Html Never
view event =
    div
        [ classList
            [ ( "event", True )
            , ( "event-important", event.important == True )
            ]
        ]
        [ div [] []
        , h2 [ style "background-color" "LightCyan", class "event-title" ] [ text event.title ]
        , p [ class "event-interval" ] [ Interval.view event.interval ]
        , p [ class "event-description" ] [ event.description ]
        , p [ class "event-category" ] [ categoryView event.category ]
        , a [ hidden (event.url == Nothing), class "event-url", href (Maybe.withDefault " " event.url) ] [ text (Maybe.withDefault " " event.url) ]
        ]
