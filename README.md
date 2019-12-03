# Mintegral adapter for Mopub

Much more information can be found at [Developer site](http://cdn-adn.rayjump.com/cdn-adn/v2/markdown_v2/index.html?file=sdk-m_sdk_mopub-ios&lang=en.)

## Install a Mintegral Adapter & SDK using CocoaPods

Mintegral distributes several iOS specific SDKs via CocoaPods.
You can install the CocoaPods tool on OS X by running the following command from
the terminal. Detailed information is available in the [Getting Started
guide](https://guides.cocoapods.org/using/getting-started.html#getting-started).

```
$ sudo gem install cocoapods
```

### Add  Mintegral Adapter to your iOS app

**Latest Release Version**
* 5.8.4.2

CocoaPods is used to install and manage dependencies in existing Xcode projects.

1. Create an Xcode project, and save it to your local machine.
2. Open a terminal and `cd` to the directory of your project. Then run the `pod init` command. Podfile would be created.
3. Open `Podfile`, and add your dependencies. A simple Podspec is shown here:

    ```
    platform :ios, '9.0'
    
    #for rewardVideo ad
    pod 'MintegralAdSDKAdapterForMopub/RewardVideoAdAdapter'
    
    #for native ad
    pod 'MintegralAdSDKAdapterForMopub/NativeAdAdapter' 
    
    #for interstitialVideo ad
    pod 'MintegralAdSDKAdapterForMopub/InterstitialVideoAdAdapter'
    
    #for banner ad
    pod 'MintegralAdSDKAdapterForMopub/BannerAdAdapter'
    
    ```
    
4. Save the file.
5. Open a terminal and `cd` to the directory containing the Podfile.

    ```
    $ cd <path-to-project>/project/
    ```

6. Run the `pod install` command. This will install the SDKs specified in the
   Podspec, along with any dependencies they may have. 

    ```
    $ pod install
    ```

    > Note: Mintegral SDKs would be automatically installed in the meantime of installing Mopub Adapters.So there is no need to add "Pod MintegralAdSDK" in Podfile.


7. Open your app's `.xcworkspace` file to launch Xcode.
   Use this file for all development on your app.
