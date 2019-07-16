Pod::Spec.new do |spec|


  spec.name         = 'MintegralAdSDKAdapterForMopu'
  spec.version      = '1.7.0'
  spec.summary      = 'Mintegral Network CustomEvent for Mopub Ad Mediation'
  spec.homepage     = 'http://cdn-adn.rayjump.com/cdn-adn/v2/markdown_v2/index.html?file=sdk-m_sdk-ios&lang=en'
  spec.description  = <<-DESC   
    Mintegral's  AdSDK allows you to monetize your iOS and Android apps with Mintegral ads. And this CustomEvent  for use Mintegral via Mopub sdk 
                       DESC

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = 'Mintegral'
  spec.social_media_url   = 'https://www.facebook.com/mintegral.official'
  spec.platform     = :ios, '7.0'
  spec.source       = { :git => 'https://github.com/Mintegral-official/mintegral_mopub_adapter_ios.git', :tag => spec.version}
  spec.requires_arc = true




# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.default_subspecs =  'NativeAd'

  spec.subspec 'NativeAdAdapter' do |ss|
    ss.dependencies = 'mopub-ios-sdk/MoPubSDK'
    ss.dependencies = 'MintegralAdSDK/NativeAd'

    ss.source_files = 'MintegralAdapters/MTGCommon/*.{h,m}','MintegralAdapters/MTGNativeAdCustomEvent/*.{h,m}'

  end

  spec.subspec 'InterstitialVideoAdAdapter' do |ss|
    ss.dependencies = 'mopub-ios-sdk/MoPubSDK'
    ss.dependencies = 'MintegralAdSDK/InterstitialVideoAd'
    ss.source_files = 'MintegralAdapters/MTGCommon/*.{h,m}','MintegralAdapters/MTGInterstitialVideoAdCustomEvent/*.{h,m}'
  end


  spec.subspec 'RewardVideoAdAdapter' do |ss|
    ss.dependencies = 'mopub-ios-sdk/MoPubSDK'
    ss.dependencies = 'MintegralAdSDK/RewardVideoAd'
    ss.source_files = 'MintegralAdapters/MTGCommon/*.{h,m}','MintegralAdapters/MTGRewardVideoAdCustomEvent/*.{h,m}'

  end


  spec.subspec 'InterstitialAdAdapter' do |ss|
    ss.dependencies = 'mopub-ios-sdk/MoPubSDK'
    ss.dependencies = 'MintegralAdSDK/InterstitialAd'
    ss.source_files = 'MintegralAdapters/MTGCommon/*.{h,m}','MintegralAdapters/MTGInterstitialAdCustomEvent/*.{h,m}'
  end


  spec.subspec 'BannerAdAdapter' do |ss|
    ss.dependencies = 'mopub-ios-sdk/MoPubSDK'
    ss.dependencies = 'MintegralAdSDK/NativeAd'
    ss.source_files = 'MintegralAdapters/MTGCommon/*.{h,m}','MintegralAdapters/MTGBannerAdCustomEvent/*.{h,m}'
  end
  



 
end
