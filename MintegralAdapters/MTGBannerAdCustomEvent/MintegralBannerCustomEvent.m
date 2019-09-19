//
//  MintegralBannerCustomEvent.m
//  MoPubSampleApp
//
//  Created by Lucas on 2019/4/25.
//  Copyright © 2019 MoPub. All rights reserved.
//

#import "MintegralBannerCustomEvent.h"

#import <MTGSDK/MTGSDK.h>

#import "MintegralAdapterHelper.h"
#import <MTGSDKBanner/MTGBannerAdView.h>
#import <MTGSDKBanner/MTGBannerAdViewDelegate.h>


typedef enum {
    MintegralErrorBannerParaUnresolveable = 19,
    MintegralErrorBannerCamPaignListEmpty,
}MintegralBannerErrorCode;


@interface MintegralBannerCustomEvent() <MTGBannerAdViewDelegate>

@property(nonatomic,strong) MTGBannerAdView *bannerAdView;
@property (nonatomic, strong) NSString * currentUnitID;
@property (nonatomic, assign) CGSize currentSize;

@end

@implementation MintegralBannerCustomEvent

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info{
    NSString *appId = [info objectForKey:@"appId"];
    NSString *appKey = [info objectForKey:@"appKey"];
    NSString *unitId = [info objectForKey:@"unitId"];
    
    NSString *errorMsg = nil;
    if (!appId) errorMsg = @"Invalid Mintegral appId";
    if (!appKey) errorMsg = @"Invalid Mintegral appKey";
    if (!unitId) errorMsg = @"Invalid Mintegral unitId";
    
    if (errorMsg) {
        NSError *error = [NSError errorWithDomain:kMintegralErrorDomain code:MintegralErrorBannerParaUnresolveable userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        if ([self.description respondsToSelector:@selector(bannerCustomEvent: didFailToLoadAdWithError:)]) {
            [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        }
        return;
    }
    

    if (![MintegralAdapterHelper isSDKInitialized]) {
        
        [MintegralAdapterHelper setGDPRInfo:info];
        [[MTGSDK sharedInstance] setAppID:appId ApiKey:appKey];
        [MintegralAdapterHelper sdkInitialized];
    }
    
    
    _currentUnitID = unitId;
    _currentSize = size;
    
    UIViewController * vc =  [UIApplication sharedApplication].keyWindow.rootViewController;
    _bannerAdView = [[MTGBannerAdView alloc] initBannerAdViewWithAdSize:size unitId:unitId rootViewController:vc];
    _bannerAdView.delegate = self;
    [_bannerAdView loadBannerAd];
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup{
    [self requestAdWithSize:size customEventInfo:info];
}

#pragma mark --
#pragma mark -- MTGBannerAdViewDelegate
- (void)adViewLoadSuccess:(MTGBannerAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent: didLoadAd:)]) {
        [self.delegate bannerCustomEvent:self didLoadAd:adView];
    }
}

- (void)adViewLoadFailedWithError:(NSError *)error adView:(MTGBannerAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEvent: didFailToLoadAdWithError:)]) {
        [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
    }
    
}

- (void)adViewWillLogImpression:(MTGBannerAdView *)adView{
    if ([self.delegate respondsToSelector:@selector(trackImpression)]) {
        [self.delegate trackImpression];
    }
}


- (void)adViewDidClicked:(MTGBannerAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(trackClick)]) {
        [self.delegate trackClick];
    }
}

- (void)adViewWillLeaveApplication:(MTGBannerAdView *)adView {
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerCustomEventWillLeaveApplication:self];
    }
}

- (void)adViewWillOpenFullScreen:(MTGBannerAdView *)adView {
    
}

- (void)adViewCloseFullScreen:(MTGBannerAdView *)adView {
}


#pragma mark - Turn off auto impression and click
- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Subclasses may override this method to return NO to perform impression and click tracking
    // manually.
    return NO;
}


@end


