module Util.Time exposing (..)

import Basics exposing (modBy)
import Time


type Date
    = Date { year : Int, month : Time.Month, day : Int }


monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan ->
            "Jan"

        Time.Feb ->
            "Feb"

        Time.Mar ->
            "Mar"

        Time.Apr ->
            "Apr"

        Time.May ->
            "May"

        Time.Jun ->
            "Jun"

        Time.Jul ->
            "Jul"

        Time.Aug ->
            "Aug"

        Time.Sep ->
            "Sep"

        Time.Oct ->
            "Oct"

        Time.Nov ->
            "Nov"

        Time.Dec ->
            "Dec"


posixToDate : Time.Zone -> Time.Posix -> Date
posixToDate tz time =
    let
        year =
            Time.toYear tz time

        month =
            Time.toMonth tz time

        day =
            Time.toDay tz time
    in
    Date { year = year, month = month, day = day }


formatTime : Time.Zone -> Time.Posix -> String
formatTime tz time =
    let
        date =
            posixToDate tz time
    in
    formatDate date
        ++ " "
        ++ (Time.toHour tz time |> String.fromInt |> String.padLeft 2 '0')
        ++ ":"
        ++ (Time.toMinute tz time |> String.fromInt |> String.padLeft 2 '0')


formatDate : Date -> String
formatDate (Date date) =
    String.fromInt date.year
        ++ " "
        ++ monthToString date.month
        ++ " "
        ++ (String.fromInt date.day |> String.padLeft 2 '0')


type alias Duration =
    { seconds : Int
    , minutes : Int
    , hours : Int
    , days : Int
    }


{-| Calculates the amount of time that passed between two dates.

The first date (t1) must be **before** the second date (t2), if this not the case, the function should return `Nothing`.

Relevant library functions:

  - Use Time.posixToMillis

```
import Time

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (1000)) --> Just (Duration 1 0 0 0)

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (60 * 1000)) --> Just (Duration 0 1 0 0)

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (60 * 60 * 1000)) --> Just (Duration 0 0 1 0)

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (24 * 60 * 60 * 1000)) --> Just (Duration 0 0 0 1)

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (24 * 60 * 60 * 1000 + 1000)) --> Just (Duration 1 0 0 1)

durationBetween (Time.millisToPosix 0) (Time.millisToPosix (4 * 24 * 60 * 60 * 1000 + 3 * 60 * 60 * 1000 + 2 * 60 * 1000 + 1000)) --> Just (Duration 1 2 3 4)

durationBetween (Time.millisToPosix 1000) (Time.millisToPosix 0) --> Nothing

durationBetween (Time.millisToPosix 1000) (Time.millisToPosix 1000) --> Nothing
```

-}
durationBetween : Time.Posix -> Time.Posix -> Maybe Duration
durationBetween t1 t2 =
    if Time.posixToMillis t1 >= Time.posixToMillis t2 then
        Nothing

    else
        let
            totalSeconds =
                (Time.posixToMillis t2 - Time.posixToMillis t1) // 1000

            days =
                totalSeconds // (24 * 60 * 60)

            remainingSecondsAfterDays =
                modBy (24 * 60 * 60) totalSeconds

            hours =
                remainingSecondsAfterDays // (60 * 60)

            remainingSecondsAfterHours =
                modBy (60 * 60) remainingSecondsAfterDays

            minutes =
                remainingSecondsAfterHours // 60

            seconds =
                modBy 60 remainingSecondsAfterHours
        in
        Just { days = days, hours = hours, minutes = minutes, seconds = seconds }


{-| Format a `Duration` as a human readable string

    formatDuration (Duration 1 0 0 0) --> "1 second ago"

    formatDuration (Duration 2 0 0 0) --> "2 seconds ago"

    formatDuration (Duration 0 1 0 0) --> "1 minute ago"

    formatDuration (Duration 0 0 2 0) --> "2 hours ago"

    formatDuration (Duration 0 0 0 3) --> "3 days ago"

    formatDuration (Duration 0 1 1 1) --> "1 day 1 hour 1 minute ago"

    formatDuration (Duration 0 47 6 2) --> "2 days 6 hours 47 minutes ago"

    formatDuration (Duration 0 30 0 1) --> "1 day 30 minutes ago"

-}
formatDuration : Duration -> String
formatDuration duration =
    let
        -- formatare
        formatPart value singular plural =
            case value of
                0 ->
                    Nothing

                1 ->
                    Just ("1 " ++ singular)

                _ ->
                    Just (String.fromInt value ++ " " ++ plural)

        daysPart =
            formatPart duration.days "day" "days"

        hoursPart =
            formatPart duration.hours "hour" "hours"

        minutesPart =
            formatPart duration.minutes "minute" "minutes"

        secondsPart =
            formatPart duration.seconds "second" "seconds"

        parts =
            List.filterMap identity [ daysPart, hoursPart, minutesPart, secondsPart ]
    in
    case parts of
        -- nu exista
        [] ->
            "just now"

        -- un element
        [ single ] ->
            single ++ " ago"

        --mai multe
        _ ->
            String.join " " parts ++ " ago"
