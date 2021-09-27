module EncodersTests exposing (suite)

import Encoders exposing (encodePublishForm)
import Expect exposing (Expectation, fail, pass)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Encode exposing (Value, encode)
import RemoteData exposing (RemoteData(..))
import Test exposing (..)
import TestUtils exposing (encodesTo)
import Types exposing (..)
import Url exposing (Protocol(..))


suite : Test
suite =
    describe "JSON"
        [ describe "encodes publish request"
            [ test "publish request 1 - matches golden encoding." <|
                \_ ->
                    encodesTo encodePublishForm
                        publishDataProductRequest1
                        { owner = "ybyzek"
                        , description = "pageviews users 2"
                        , topic =
                            { qualifiedName = QualifiedName "lsrc-7xxv2:.:pksqlc-09g26PAGEVIEWS_USER2-value:2"
                            , name = "pageviews"
                            }
                        , quality = Authoritative
                        , domain = "Product Team"
                        , sla = Tier2
                        }
            ]
        ]


publishDataProductRequest1 : String
publishDataProductRequest1 =
    """
{
  "@type": "TOPIC",
  "qualifiedName": "lsrc-7xxv2:.:pksqlc-09g26PAGEVIEWS_USER2-value:2",
  "dataProductTag": {
    "owner": "ybyzek",
    "domain": "Product Team",
    "description": "pageviews users 2",
    "quality": "authoritative",
    "sla": "tier-2"
  }
}
"""
