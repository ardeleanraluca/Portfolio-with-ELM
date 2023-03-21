-- module Model.Event.Category exposing (EventCategory(..), SelectedEventCategories, allSelected, eventCategories, isEventCategorySelected, set, view)


module Model.Event.Category exposing (..)

import Html exposing (Html, div, input, li, text, ul)
import Html.Attributes exposing (align, checked, class, style, type_)
import Html.Events exposing (onCheck)


type EventCategory
    = Academic
    | Work
    | Project
    | Award


eventCategories =
    [ Academic, Work, Project, Award ]


{-| Type used to represent the state of the selected event categories
-}
type SelectedEventCategories
    = SelectedEventCategories (List EventCategory)


{-| Returns an instance of `SelectedEventCategories` with all categories selected

    isEventCategorySelected Academic allSelected --> True

-}
allSelected : SelectedEventCategories
allSelected =
    SelectedEventCategories eventCategories


{-| Returns an instance of `SelectedEventCategories` with no categories selected

-- isEventCategorySelected Academic noneSelected --> False

-}
noneSelected : SelectedEventCategories
noneSelected =
    SelectedEventCategories []


{-| Given a the current state and a `category` it returns whether the `category` is selected.

    isEventCategorySelected Academic allSelected --> True

-}
isEventCategorySelected : EventCategory -> SelectedEventCategories -> Bool
isEventCategorySelected category current =
    let
        (SelectedEventCategories selectedEventsList) =
            current
    in
    selectedEventsList |> List.member category


{-| Given an `category`, a boolean `value` and the current state, it sets the given `category` in `current` to `value`.

    allSelected |> set Academic False |> isEventCategorySelected Academic --> False

    allSelected |> set Academic False |> isEventCategorySelected Work --> True

-}
set : EventCategory -> Bool -> SelectedEventCategories -> SelectedEventCategories
set category value current =
    let
        (SelectedEventCategories selectedEventsList) =
            current
    in
    if value == False then
        selectedEventsList
            |> List.filter (\x -> x /= category)
            |> SelectedEventCategories

    else if List.member category selectedEventsList == True then
        current

    else
        SelectedEventCategories (selectedEventsList ++ (category :: []))


checkbox : String -> Bool -> EventCategory -> Html ( EventCategory, Bool )
checkbox name state category =
    div [ style "display" "inline", class "category-checkbox" ]
        [ input [ type_ "checkbox", onCheck (\c -> ( category, c )), checked state ] []
        , text name
        ]


view : SelectedEventCategories -> Html ( EventCategory, Bool )
view model =
    div []
        [ ul [] <|
            (eventCategories
                |> List.map
                    (\event ->
                        checkbox (eventCategoryToString event) (isEventCategorySelected event model) event
                    )
            )
        ]


{-| Given an EventCategory `event`, it converts the given 'event' to a String
-}
eventCategoryToString : EventCategory -> String
eventCategoryToString event =
    case event of
        Academic ->
            "Academic"

        Work ->
            "Work"

        Project ->
            "Project"

        Award ->
            "Award"
