Pod::Spec.new do |spec|
  
  spec.name         = 'MintegralAdSDKAdapterForMopub'
  spec.version      = '6.5.0.2'
  spec.summary      = 'Mintegral Adapters for mediating through MoPub.'
  spec.homepage     = 'http://cdn-adn.rayjump.com/cdn-adn/v2/markdown_v2/index.html?file=sdk-m_sdk-ios&lang=en'
  spec.description  = <<-DESC
      Supported ad formats: Banner, Interstitial, Rewarded Video, Native.\n\nTo download and integrate the Mintegral SDK, please check this tutorial: http://cdn-adn.rayjump.com/cdn-adn/v2/markdown_v2/index.html?file=sdk-m_sdk-ios&lang=en. \n\n\nFor inquiries and support, please email developer@mintegral.com.
                        DESC

  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author             = 'Mintegral'
  spec.social_media_url   = 'https://www.facebook.com/mintegral.official'
  spec.platform     = :ios, '10.0'
  spec.source       = { :git => 'https://github.com/MTGSDK/mintegral_mopub_adapter_ios.git', :tag => spec.version}
  spec.requires_arc = true
  spec.static_framework = true



# ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
spec.default_subspecs =  'MintegralAdapter'

spec.subspec 'MintegralAdapter' do |ss|

  ss.dependency 'mopub-ios-sdk', '~> 5.13'

  ss.dependency  'MintegralAdSDK', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/NativeAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/RewardVideoAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/BidNativeAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/BidRewardVideoAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/InterstitialVideoAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/BidInterstitialVideoAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/BannerAd', '~> 6.5.0'
  ss.dependency  'MintegralAdSDK/BidBannerAd', '~> 6.5.0'

  ss.source_files = 'MintegralAdapters/*.{h,m}'


end


 
end
