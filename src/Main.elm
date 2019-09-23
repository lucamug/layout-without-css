port module Main exposing (main)

import Browser
import Browser.Events
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html
import Html.Attributes
import Html.Events
import Json.Decode



--  ██████  ██████  ███    ██ ███████ ████████  █████  ███    ██ ████████ ███████
-- ██      ██    ██ ████   ██ ██         ██    ██   ██ ████   ██    ██    ██
-- ██      ██    ██ ██ ██  ██ ███████    ██    ███████ ██ ██  ██    ██    ███████
-- ██      ██    ██ ██  ██ ██      ██    ██    ██   ██ ██  ██ ██    ██         ██
--  ██████  ██████  ██   ████ ███████    ██    ██   ██ ██   ████    ██    ███████


smallDeviceMaxSize : Int
smallDeviceMaxSize =
    -- iPhone plus width = 414
    500


maxContentWidth : Model -> Int
maxContentWidth model =
    smallDeviceMaxSize


idCover : String
idCover =
    "cover"


type alias Conf =
    { border_rounded : Int
    , layer_base_background_color : Color
    , layer_base_border_color : Color
    , layer_base_border_size : Int
    , layer_modal_rounded_background_color : Color
    , layer_modal_rounded_border_color : Color
    , layer_modal_rounded_border_size : Int
    , layer_modal_content_background_color : Color
    , layer_modal_content_border_color : Color
    , layer_modal_content_border_size : Int
    }


confTesting : Conf
confTesting =
    { layer_base_border_color = rgb 0 0.7 0 -- green
    , layer_base_background_color = rgba 0 0.7 0 0.3 -- green
    , layer_base_border_size = 10
    , layer_modal_rounded_border_color = rgba 0.9 0 0 0.5 -- red
    , layer_modal_rounded_background_color = rgba 0.9 0 0.5 0.3 -- red
    , layer_modal_rounded_border_size = 10
    , layer_modal_content_border_color = rgb 0.8 0.8 0.0 -- yellow
    , layer_modal_content_background_color = rgba 1 1 0.5 0.8 -- yellow
    , layer_modal_content_border_size = 10
    , border_rounded = 60
    }


confRegular : Conf
confRegular =
    { layer_base_border_color = rgb 1 1 1
    , layer_base_background_color = rgba 0 0 0 0.1
    , layer_base_border_size = 0
    , layer_modal_rounded_border_color = rgb 0.7 0.7 0.7
    , layer_modal_rounded_background_color = rgba 1 1 1 1
    , layer_modal_rounded_border_size = 1
    , layer_modal_content_border_color = rgb 1 1 1
    , layer_modal_content_background_color = rgba 1 1 1 1
    , layer_modal_content_border_size = 0
    , border_rounded = 20
    }



-- ███    ███  ██████  ██████  ███████ ██
-- ████  ████ ██    ██ ██   ██ ██      ██
-- ██ ████ ██ ██    ██ ██   ██ █████   ██
-- ██  ██  ██ ██    ██ ██   ██ ██      ██
-- ██      ██  ██████  ██████  ███████ ███████


type alias Model =
    { x : Int
    , y : Int
    , isEmptyPage : Bool
    , enabled : Bool
    , extraContent : Bool
    , testColors : Bool
    , text : String
    , ua : String
    , marginAroundModal : Int
    }



-- ██ ███    ██ ██ ████████
-- ██ ████   ██ ██    ██
-- ██ ██ ██  ██ ██    ██
-- ██ ██  ██ ██ ██    ██
-- ██ ██   ████ ██    ██


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { x = flags.x
      , y = flags.y
      , isEmptyPage = flags.isEmptyPage
      , enabled = True
      , extraContent = True
      , testColors = False
      , text = ""
      , ua = flags.ua
      , marginAroundModal = 40
      }
    , Cmd.none
    )



-- ███    ███ ███████ ███████ ███████  █████   ██████  ███████ ███████
-- ████  ████ ██      ██      ██      ██   ██ ██       ██      ██
-- ██ ████ ██ █████   ███████ ███████ ███████ ██   ███ █████   ███████
-- ██  ██  ██ ██           ██      ██ ██   ██ ██    ██ ██           ██
-- ██      ██ ███████ ███████ ███████ ██   ██  ██████  ███████ ███████


type Msg
    = DoNothing
    | OnResize Int Int
    | ChangeHeight String
    | ChangeWidth String
    | ChangeMarginAroundModal String
    | ChangeText String
    | ToggleExtraContent
    | ToggleEmptyPage
    | ToggleEnabled
    | ToggleTestColors
    | ClickOnCover MouseClickData



-- ██████   ██████  ██████  ████████ ███████
-- ██   ██ ██    ██ ██   ██    ██    ██
-- ██████  ██    ██ ██████     ██    ███████
-- ██      ██    ██ ██   ██    ██         ██
-- ██       ██████  ██   ██    ██    ███████


port toggleEmptyPage : () -> Cmd msg



-- ██    ██ ██████  ██████   █████  ████████ ███████
-- ██    ██ ██   ██ ██   ██ ██   ██    ██    ██
-- ██    ██ ██████  ██   ██ ███████    ██    █████
-- ██    ██ ██      ██   ██ ██   ██    ██    ██
--  ██████  ██      ██████  ██   ██    ██    ███████


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DoNothing ->
            ( model, Cmd.none )

        OnResize x y ->
            ( { model | x = x, y = y }, Cmd.none )

        ChangeHeight y ->
            ( { model | y = Maybe.withDefault 0 (String.toInt y) }, Cmd.none )

        ChangeWidth x ->
            ( { model | x = Maybe.withDefault 0 (String.toInt x) }, Cmd.none )

        ChangeText text ->
            ( { model | text = text }, Cmd.none )

        ChangeMarginAroundModal marginAroundModal ->
            ( { model | marginAroundModal = Maybe.withDefault 0 (String.toInt marginAroundModal) }, Cmd.none )

        ToggleExtraContent ->
            ( { model | extraContent = not model.extraContent }, Cmd.none )

        ToggleEmptyPage ->
            ( { model | isEmptyPage = not model.isEmptyPage }, toggleEmptyPage () )

        ToggleEnabled ->
            ( { model | enabled = not model.enabled }, Cmd.none )

        ToggleTestColors ->
            ( { model | testColors = not model.testColors }, Cmd.none )

        ClickOnCover mouseClickData ->
            if not model.isEmptyPage && mouseClickData.id1 == idCover then
                ( { model | enabled = not model.enabled }, Cmd.none )

            else
                ( model, Cmd.none )



-- ██   ██ ███████ ██      ██████  ███████ ██████  ███████
-- ██   ██ ██      ██      ██   ██ ██      ██   ██ ██
-- ███████ █████   ██      ██████  █████   ██████  ███████
-- ██   ██ ██      ██      ██      ██      ██   ██      ██
-- ██   ██ ███████ ███████ ██      ███████ ██   ██ ███████


layoutTestingConf : { a | testColors : Bool } -> Conf
layoutTestingConf model =
    if model.testColors then
        confTesting

    else
        confRegular


type alias MouseClickData =
    { id1 : String
    , id2 : String
    , id3 : String
    }


clickDecoder : Json.Decode.Decoder MouseClickData
clickDecoder =
    Json.Decode.map3 MouseClickData
        (Json.Decode.at [ "target", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "id" ] Json.Decode.string)
        (Json.Decode.at [ "target", "parentElement", "parentElement", "id" ] Json.Decode.string)


isSmallViewport : Model -> Bool
isSmallViewport model =
    model.x < smallDeviceMaxSize || model.y < smallDeviceMaxSize


isTheInnerPartUnscrollable : Model -> Bool
isTheInnerPartUnscrollable model =
    isSmallViewport model && model.isEmptyPage


isBackgroundImageUnnecessary : Model -> Bool
isBackgroundImageUnnecessary model =
    isSmallViewport model || not model.isEmptyPage



-- ██    ██ ██ ███████ ██     ██     ██   ██ ███████ ██      ██████  ███████ ██████  ███████
-- ██    ██ ██ ██      ██     ██     ██   ██ ██      ██      ██   ██ ██      ██   ██ ██
-- ██    ██ ██ █████   ██  █  ██     ███████ █████   ██      ██████  █████   ██████  ███████
--  ██  ██  ██ ██      ██ ███ ██     ██   ██ ██      ██      ██      ██      ██   ██      ██
--   ████   ██ ███████  ███ ███      ██   ██ ███████ ███████ ██      ███████ ██   ██ ███████


viewBool : Bool -> Element msg
viewBool bool =
    if bool then
        el [ Font.color <| rgb 0 0.5 0 ] <| text "YES"

    else
        el [ Font.color <| rgb 0.8 0 0 ] <| text "NO"


buttonAttrs : List (Attribute msg)
buttonAttrs =
    [ paddingXY 10 6
    , Border.width 1
    , Border.color <| rgba 0 0 0 0.2
    , Border.rounded 20
    , Background.color <| rgba 0 0 0 0.1
    , mouseOver
        [ Background.color <| rgba 0 0 0 0.05
        , Border.shadow { offset = ( 0, 3 ), size = 0, blur = 3, color = rgba 0 0 0 0.2 }
        ]
    , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 0, color = rgba 0 0 0 0 }
    , htmlAttribute <| Html.Attributes.style "transition" "all 0.2s"
    ]


layer_modal_attrs : Model -> List (Attribute msg)
layer_modal_attrs model =
    let
        borderRounded_attr =
            if isSmallViewport model then
                []

            else
                [ Border.rounded <|
                    .border_rounded (layoutTestingConf model)
                ]

        scrollbarY_attr =
            if isTheInnerPartUnscrollable model then
                []

            else
                [ scrollbarY ]
    in
    [ paddingXY 30 30
    , spacing 20
    , width (fill |> maximum (maxContentWidth model))
    , height fill
    , centerX
    , Border.color <| .layer_modal_content_border_color (layoutTestingConf model) -- yellow
    , Background.color <| .layer_modal_content_background_color (layoutTestingConf model) -- yellow
    , Border.width <| .layer_modal_content_border_size (layoutTestingConf model)
    , Border.shadow { offset = ( 0, 0 ), size = 0, blur = 10, color = rgba 0 0 0 0.6 }
    ]
        ++ borderRounded_attr
        ++ scrollbarY_attr


addStyle : String -> Element msg
addStyle style =
    html <| Html.node "style" [] [ Html.text <| style ]


layer_modal_content : Model -> Element Msg
layer_modal_content model =
    let
        buttonToggleExtraContent =
            if model.extraContent then
                "Less content"

            else
                "More content"

        buttonToggleColors =
            if model.testColors then
                "Normal colors"

            else
                "Test colors"

        buttonToggleEmptyPage =
            if model.isEmptyPage then
                "NON empty Page"

            else
                "Empty Page"

        extraContent =
            if model.extraContent then
                [ paragraph [] [ text <| "smallDeviceMaxSize = ", text <| String.fromInt smallDeviceMaxSize ]
                , paragraph [] [ text <| "isEmptyPage = ", viewBool model.isEmptyPage ]
                , paragraph [] [ text <| "isSmallViewport = ", viewBool (isSmallViewport model) ]
                , paragraph [] [ text <| "isTheInnerPartUnscrollable = ", viewBool <| isTheInnerPartUnscrollable model ]
                , paragraph [] [ text <| "isBackgroundImageUnnecessary = ", viewBool <| isBackgroundImageUnnecessary model ]
                , paragraph [] [ text <| "ua = " ++ model.ua ]
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field A", onChange = ChangeText, placeholder = Nothing, text = model.text }
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field B", onChange = ChangeText, placeholder = Nothing, text = model.text }
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field C", onChange = ChangeText, placeholder = Nothing, text = model.text }
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field D", onChange = ChangeText, placeholder = Nothing, text = model.text }
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field E", onChange = ChangeText, placeholder = Nothing, text = model.text }
                , paragraph [] [ text " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla vehicula leo imperdiet, efficitur velit at, congue dui. Curabitur dictum et orci eu mattis. Sed eu velit sem. Proin ac fringilla metus, eget feugiat est. Nulla facilisi. Proin ipsum ex, vestibulum eget tempor tempus, vehicula ut mauris. Integer sit amet eros velit. Donec non congue ante. Nunc a nibh eget quam sagittis interdum. Curabitur non finibus tellus, vitae accumsan diam." ]
                , Input.text [] { label = Input.labelAbove [] <| text "Field F", onChange = ChangeText, placeholder = Nothing, text = model.text }
                ]

            else
                []

        extraCss1 =
            if not model.isEmptyPage then
                -- From https://css-tricks.com/prevent-page-scrolling-when-a-modal-is-open/
                [ addStyle "body {height: 100vh; overflow-y: hidden;}" ]

            else
                []

        extraCss2 =
            -- From https://css-tricks.com/snippets/css/momentum-scrolling-on-ios-overflow-elements/
            [ addStyle ".s.sby {overflow-y: scroll; -webkit-overflow-scrolling: touch;}" ]
    in
    column
        (layer_modal_attrs model)
        ([ wrappedRow [ spacing 6 ]
            [ Input.button buttonAttrs { onPress = Just ToggleEnabled, label = text "Disable" }
            , Input.button buttonAttrs { onPress = Just ToggleExtraContent, label = text buttonToggleExtraContent }
            , Input.button buttonAttrs { onPress = Just ToggleTestColors, label = text buttonToggleColors }
            , Input.button buttonAttrs { onPress = Just ToggleEmptyPage, label = text buttonToggleEmptyPage }
            ]
         , paragraph [] [ text <| "x = " ++ String.fromInt model.x ++ ", y = " ++ String.fromInt model.y ]
         , row [ spacing 20, width fill ]
            [ Input.text [] { label = Input.labelAbove [] <| text "Width", onChange = ChangeWidth, placeholder = Nothing, text = String.fromInt model.x }
            , Input.text [] { label = Input.labelAbove [] <| text "Height", onChange = ChangeHeight, placeholder = Nothing, text = String.fromInt model.y }
            , Input.text [] { label = Input.labelAbove [] <| text "Margin", onChange = ChangeMarginAroundModal, placeholder = Nothing, text = String.fromInt model.marginAroundModal }
            ]
         ]
            ++ extraContent
            ++ extraCss1
            ++ extraCss2
        )



-- ██    ██ ██ ███████ ██     ██
-- ██    ██ ██ ██      ██     ██
-- ██    ██ ██ █████   ██  █  ██
--  ██  ██  ██ ██      ██ ███ ██
--   ████   ██ ███████  ███ ███


view : Model -> Html.Html Msg
view model =
    if model.enabled then
        let
            layer_modal_rounded =
                if isSmallViewport model then
                    layer_modal_content model

                else
                    el
                        [ width
                            (px (maxContentWidth model)
                                |> maximum (model.x - model.marginAroundModal)
                            )
                        , height
                            (shrink
                                |> maximum (model.y - model.marginAroundModal)
                            )
                        , centerX
                        , centerY
                        , Border.rounded <| .border_rounded (layoutTestingConf model)
                        , Border.color <| .layer_modal_rounded_border_color (layoutTestingConf model) -- red
                        , Background.color <| .layer_modal_rounded_background_color (layoutTestingConf model) -- red
                        , Border.width <| .layer_modal_rounded_border_size (layoutTestingConf model)
                        ]
                    <|
                        layer_modal_content model

            layoutAttrs =
                [ Font.size 16
                , Font.family []
                , Border.color <| .layer_base_border_color (layoutTestingConf model) -- green
                , Background.color <| .layer_base_background_color (layoutTestingConf model) -- green
                , Border.width <| .layer_base_border_size (layoutTestingConf model)
                , htmlAttribute <| Html.Attributes.id idCover
                , htmlAttribute <| Html.Events.on "click" (Json.Decode.map ClickOnCover clickDecoder)
                ]
                    ++ (if isBackgroundImageUnnecessary model then
                            []

                        else
                            [ Background.image "//layout-without-css.surge.sh/tokyo.jpg" ]
                       )
                    ++ (if model.isEmptyPage then
                            []

                        else
                            [ -- Here we want to make the first layer positioned
                              -- absolute at the top. This is not possible in elm-ui
                              -- so we add some CSS.
                              -- We could use "inFront" but this would add an extra
                              -- unecessary layer
                              htmlAttribute <| Html.Attributes.style "position" "fixed"
                            , htmlAttribute <| Html.Attributes.style "top" "0"
                            ]
                       )
        in
        if model.isEmptyPage then
            layout layoutAttrs layer_modal_rounded

        else
            layout (layoutAttrs ++ [ inFront layer_modal_rounded ]) <| none

    else
        Html.button
            [ Html.Events.onClick ToggleEnabled
            , Html.Attributes.style "margin" "40px"
            , Html.Attributes.style "padding" "20px"
            , Html.Attributes.style "font-size" "20px"
            ]
            [ Html.text "Enable Modal" ]



-- ███████ ██       █████   ██████  ███████
-- ██      ██      ██   ██ ██       ██
-- █████   ██      ███████ ██   ███ ███████
-- ██      ██      ██   ██ ██    ██      ██
-- ██      ███████ ██   ██  ██████  ███████


type alias Flags =
    { x : Int
    , y : Int
    , isEmptyPage : Bool
    , ua : String
    }



-- ███    ███  █████  ██ ███    ██
-- ████  ████ ██   ██ ██ ████   ██
-- ██ ████ ██ ███████ ██ ██ ██  ██
-- ██  ██  ██ ██   ██ ██ ██  ██ ██
-- ██      ██ ██   ██ ██ ██   ████


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Browser.Events.onResize OnResize
        }
