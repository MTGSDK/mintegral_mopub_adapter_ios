{

  "name": "MintegralAdSDKAdapterForMopub",

  "version": "6.5.0.0",

  "summary": "Mintegral Adapters for mediating through MoPub.",

  "description": "Supported ad formats: Banner, Interstitial, Rewarded Video, Native.\n\nTo download and integrate the Mintegral SDK, please check this tutorial: http://cdn-adn.rayjump.com/cdn-adn/v2/markdown_v2/index.html?file=sdk-m_sdk-ios&lang=en. \n\n\nFor inquiries and support, please email developer@mintegral.com.",

  "homepage": "https://github.com/MTGSDK/mintegral_mopub_adapter_ios",

  "license": {

    "type": "New BSD",

    "file": "LICENSE"

  },

  "authors": {

    "Mintegral": "sdk-support@mobvista.com"

  },

  "source": {

    "git": "https://github.com/MTGSDK/mintegral_mopub_adapter_ios.git",

    "tag": "6.5.0.0"

  },

  "platforms": {

    "ios": "10.0"

  },

  "static_framework": true,

  "subspecs": [

    {

      "name": "MoPub",

      "dependencies": {

        "mopub-ios-sdk/Core": [

          "~> 5.13"

        ],

        "mopub-ios-sdk/NativeAds": [

          "~> 5.13"

        ]

      }

    },

    {

      "name": "Mintegral",

      "source_files": "Mintegral/*.{h,m}",

      "dependencies": {

        "MintegralAdSDK": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/RewardVideoAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/BidNativeAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/BidRewardVideoAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/InterstitialVideoAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/BidInterstitialVideoAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/BannerAd": [

          "~> 6.5.0"

        ],

        "MintegralAdSDK/BidBannerAd": [

          "~> 6.5.0"

        ],

        "mopub-ios-sdk/Core": [

          "~> 5.13"

        ],

        "mopub-ios-sdk/NativeAds": [

          "~> 5.13"

        ]

      }

    }

  ]

}
