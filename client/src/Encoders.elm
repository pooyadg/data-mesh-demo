module Encoders exposing (encodePublishForm)

import Json.Encode as Encode exposing (..)
import RemoteData exposing (RemoteData(..))
import Types exposing (..)
import Url as Url exposing (Url)


encodePublishForm : PublishForm -> Value
encodePublishForm publishForm =
    object
        [ ( "@type", string "TOPIC" )
        , ( "qualifiedName", qualifiedName publishForm.topic.qualifiedName )
        , ( "dataProductTag"
          , object
                [ ( "owner", string publishForm.owner )
                , ( "domain", string publishForm.domain )
                , ( "description", string publishForm.description )
                , ( "quality", productQuality publishForm.quality )
                , ( "sla", productSla publishForm.sla )
                ]
          )
        ]


qualifiedName : QualifiedName -> Value
qualifiedName =
    unQualifiedName >> string


productQuality : ProductQuality -> Value
productQuality quality =
    string <|
        case quality of
            Authoritative ->
                "authoritative"

            Curated ->
                "curated"

            Raw ->
                "raw"

            OtherQuality s ->
                s


productSla : ProductSla -> Value
productSla sla =
    string <|
        case sla of
            Tier1 ->
                "tier-1"

            Tier2 ->
                "tier-2"

            Tier3 ->
                "tier-3"

            OtherSla s ->
                s
