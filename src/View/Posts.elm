module View.Posts exposing (..)

import Html exposing (Html, div, input, option, p, select, text)
import Html.Attributes exposing (checked, href, id, selected, type_, value)
import Html.Events exposing (onCheck, onInput)
import Model exposing (Msg(..))
import Model.Post exposing (Post)
import Model.PostsConfig exposing (Change(..), PostsConfig, SortBy(..), filterPosts, sortFromString, sortToCompareFn, sortToString)
import Time
import Util.Time exposing (durationBetween)


postTable : PostsConfig -> Time.Posix -> List Post -> Html Msg
postTable config currentTime posts =
    let
        sortedPosts =
            List.sortWith (sortToCompareFn config.sortBy) posts

        filteredPosts =
            filterPosts config sortedPosts
    in
    Html.table []
        (headerRow :: List.map (postRow currentTime) filteredPosts)


headerRow : Html Msg
headerRow =
    Html.tr []
        [ Html.th [] [ Html.text "Score" ]
        , Html.th [] [ Html.text "Title" ]
        , Html.th [] [ Html.text "Type" ]
        , Html.th [] [ Html.text "Posted Date" ]
        , Html.th [] [ Html.text "Link" ]
        ]


postRow : Time.Posix -> Post -> Html Msg
postRow currentTime post =
    let
        durationResult =
            case durationBetween post.time currentTime of
                Just duration ->
                    Util.Time.formatDuration duration

                Nothing ->
                    "just now"

        formattedDate =
            Util.Time.formatTime Time.utc post.time
    in
    Html.tr []
        [ Html.td [ Html.Attributes.class "post-score" ] [ Html.text (String.fromInt post.score) ]
        , Html.td [ Html.Attributes.class "post-title" ] [ Html.text post.title ]
        , Html.td [ Html.Attributes.class "post-type" ] [ Html.text post.type_ ]
        , Html.td [ Html.Attributes.class "post-time" ] [ Html.text (formattedDate ++ " (" ++ durationResult ++ ")") ]
        , Html.td [ Html.Attributes.class "post-url" ]
            [ case post.url of
                Just url ->
                    Html.a [ href url ] [ Html.text "Visit" ]

                Nothing ->
                    Html.text ""
            ]
        ]


postsConfigView : PostsConfig -> Html Msg
postsConfigView config =
    let
        postsToShowOptions =
            [ 10, 25, 50 ]

        sortByOptions =
            [ "Score", "Title", "Posted", "None" ]

        postsToShowOptionView number =
            let
                isSelected =
                    number == config.postsToShow
            in
            option [ value <| String.fromInt number, selected isSelected ] [ text <| String.fromInt number ]

        sortByOptionView sortByString =
            let
                isSelected =
                    sortToString config.sortBy == sortByString
            in
            option [ value sortByString, selected isSelected ] [ text sortByString ]
    in
    div []
        [ div []
            [ p [] [ text "Posts to show" ]
            , select
                [ id "select-posts-per-page"
                , onInput (String.toInt >> Maybe.withDefault 0 >> ChangePostsToShow >> ConfigChanged)
                ]
                (List.map postsToShowOptionView postsToShowOptions)
            ]
        , div []
            [ p [] [ text "Choose sorting method" ]
            , select
                [ id "select-sort-by"
                , onInput (sortFromString >> Maybe.withDefault None >> ChangeSortBy >> ConfigChanged)
                ]
                (List.map sortByOptionView sortByOptions)
            ]
        , div []
            [ p [] [ text "Show job posts" ]
            , input
                [ type_ "checkbox"
                , id "checkbox-show-job-posts"
                , checked config.showJobs
                , onCheck (ChangeShowJobs >> ConfigChanged)
                ]
                []
            ]
        , div []
            [ p [] [ text "Show text only posts" ]
            , input
                [ type_ "checkbox"
                , checked config.showTextOnly
                , onCheck (ChangeShowTextOnly >> ConfigChanged)
                , id "checkbox-show-text-only-posts"
                ]
                []
            ]
        ]
