module Model.Interval exposing (Interval, compare, full, length, oneYear, open, stringFromYearMonth, view, withDurationMonths, withDurationYears)

import Html exposing (Html, div, p, span, text)
import Html.Attributes exposing (align, class, hidden, style)
import Model.Date as Date exposing (Date, Month, compare)
import Model.Util exposing (chainCompare)


type Interval
    = Interval { start : Date, end : Maybe Date }


{-| Create an `Interval` from 2 `Date`s. If the second date is before the first the date, the function will return
`Nothing`. When possible, use the `withDurationMonths` or `withDurationYears` functions.
-}
full : Date -> Date -> Maybe Interval
full start end =
    if Date.compare start end == GT then
        Nothing

    else
        Just <| Interval { start = start, end = Just end }


{-| Create an `Interval` from a start year, start month, and a duration in months.
The start year and month are explicitly required because the duration in months is only specified if the start date
also includes a month.
This function, (assuming positive inputs) by definition, can always return a valid `Interval`.
-}
withDurationMonths : Int -> Month -> Int -> Interval
withDurationMonths startYear startMonth duration =
    let
        start =
            Date.full startYear startMonth

        end =
            Date.offsetMonths duration start
    in
    Interval { start = start, end = Just end }


{-| Create an `Interval` from a start `Date`, and a duration in years. This function, (assuming positive inputs)
by definition, can always return a valid `Interval`.
-}
withDurationYears : Date -> Int -> Interval
withDurationYears start duration =
    let
        end =
            Date.offsetMonths (duration * 12) start
    in
    Interval { start = start, end = Just end }


{-| Create an open `Interval` from a start `Date`. Usually used for creating ongoing events.
-}
open : Date -> Interval
open start =
    Interval { start = start, end = Nothing }


{-| Convenience function to create an `Interval` that represents one year.
-}
oneYear : Int -> Interval
oneYear year =
    withDurationYears (Date.onlyYear year) 1


{-| The length of an Interval, in (years, months)
-}
length : Interval -> Maybe ( Int, Int )
length (Interval interval) =
    interval.end
        |> Maybe.andThen (Date.monthsBetween interval.start)
        |> Maybe.map (\totalMonths -> ( totalMonths // 12, modBy 12 totalMonths ))


{-| Compares two intervals.

Intervals are first compared compare by the `start` field.
If the `start` field is equal, the they are compare by the `end` fields:

  - If both are missing (`Nothing`), the intervals are considered equal
  - If both are present (`Just`), the longer interval is considered greater
  - If only one interval is open (its `end` field is `Nothing`) then it will be considered greater

```
    import Model.Date as Date

    Model.Interval.compare (oneYear 2019) (oneYear 2020) --> LT
    Model.Interval.compare (oneYear 2019) (withDurationYears (Date.onlyYear 2020) 2) --> LT
    Model.Interval.compare (withDurationMonths 2019 Date.Jan 2) (withDurationMonths 2019 Date.Jan 2) --> EQ
    Model.Interval.compare (withDurationMonths 2019 Date.Feb 2) (withDurationMonths 2019 Date.Jan 2) --> GT
    Model.Interval.compare (withDurationMonths 2019 Date.Jan 2) (open (Date.onlyYear 2019)) --> LT
```

-}
compare : Interval -> Interval -> Order
compare (Interval intA) (Interval intB) =
    let
        startEquals =
            case ( intA.end, intB.end ) of
                ( Nothing, Nothing ) ->
                    EQ

                ( Just endA, Just endB ) ->
                    Date.compare endA endB

                ( Just _, Nothing ) ->
                    GT

                ( Nothing, Just _ ) ->
                    LT

        startNotEquals =
            Date.compare intA.start intB.start
    in
    Model.Util.chainCompare startEquals startNotEquals


{-| Given an Interval `interval`, it returns the start date field from 'interval'
-}
getStartDate : Interval -> Date
getStartDate (Interval interval) =
    interval.start


{-| Given an Interval `interval`, it returns the end date field from 'interval'
-}
getEndDate : Interval -> Maybe Date
getEndDate (Interval interval) =
    interval.end


{-| Given a tuple containing (year, month), returns a string of these values with corresponding label, excluding 0 values

  - If both values from tuple are 0, then it will returns an empty string
  - If one of the values from tuple is 0, then it will returns a string with corresponding label and value for that value which is not 0
  - If both are different from 0, then it will returns a string with corresponding label and value for both values

```Model.Interval.stringFromYearMonth
   Model.Interval.stringFromYearMonth (3,0) --> "3 years"
   Model.Interval.stringFromYearMonth (0,5) --> "5 months"
   Model.Interval.stringFromYearMonth (7,8) --> "7 years, 8 months"
```

-}
stringFromYearMonth : ( Int, Int ) -> String
stringFromYearMonth ( a, b ) =
    case ( a, b ) of
        ( 0, 0 ) ->
            " "

        ( year, 0 ) ->
            String.fromInt year ++ " years"

        ( 0, month ) ->
            String.fromInt month ++ " months"

        ( year, month ) ->
            String.fromInt year ++ " years, " ++ String.fromInt month ++ " months"


view : Interval -> Html msg
view interval =
    div [ class "interval" ]
        [ span [ class "interval-start" ] [ (getStartDate >> Date.view) interval ]
        , span [] [ text " - " ]
        , span [ class "interval-end" ] [ getEndDate interval |> Maybe.map Date.view |> Maybe.withDefault (text "Present") ]
        , p [ hidden (length interval == Nothing), class "interval-length" ] [ text (length interval |> Maybe.map stringFromYearMonth |> Maybe.withDefault "") ]
        ]
