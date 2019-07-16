//
//  MintegralInterstitialCustomEvent.m
//  MoPubSampleApp
//
//  Copyright © 2017年 MoPub. All rights reserved.
//

#import "MintegralInterstitialCustomEvent.h"
#import "MintegralAdapterHelper.h"

#import <MTGSDK/MTGSDK.h>
#import <MTGSDKInterstitial/MTGInterstitialAdManager.h>

@interface MintegralInterstitialCustomEvent()<MTGInterstitialAdLoadDelegate,MTGInterstitialAdShowDelegate>

@property (nonatomic, copy) NSString *adUnit;

@property (nonatomic, readwrite, strong) MTGInterstitialAdManager *mtgInterstitialAdManager;

@end

@implementation MintegralInterstitialCustomEvent


- (void)requestInterstitialWithCustomEventInfo:(NSDictionary *)info
{
    // The default implementation of this method does nothing. Subclasses must override this method
    // and implement code to load an interstitial here.
 
    NSString *appId = [info objectForKey:@"appId"];
    NSString *appKey = [info objectForKey:@"appKey"];
    NSString *unitId = [info objectForKey:@"unitId"];
    
    NSString *errorMsg = nil;
    if (!appId) errorMsg = @"Invalid Mintegral appId";
    if (!appKey) errorMsg = @"Invalid Mintegral appKey";
    if (!unitId) errorMsg = @"Invalid Mintegral unitId";
    
    if (errorMsg) {
        NSError *error = [NSError errorWithDomain:kMintegralErrorDomain code:-1500 userInfo:@{NSLocalizedDescriptionKey : errorMsg}];
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
        return;
    }
    

    if (![MintegralAdapterHelper isSDKInitialized]) {
        
        [MintegralAdapterHelper setGDPRInfo:info];
        [[MTGSDK sharedInstance] setAppID:appId ApiKey:appKey];
        [MintegralAdapterHelper sdkInitialized];
    }
    
    self.adUnit = unitId;


    MTGInterstitialAdCategory adCategory = MTGInterstitial_AD_CATEGORY_ALL;
    if ([info objectForKey:@"adCategory"]) {
        NSString *category = [NSString stringWithFormat:@"%@",[info objectForKey:@"adCategory"]];
        adCategory = (MTGInterstitialAdCategory)[category integerValue];
    }
    
    if (!_mtgInterstitialAdManager) {
        _mtgInterstitialAdManager = [[MTGInterstitialAdManager alloc] initWithUnitID:self.adUnit adCategory:adCategory];
    }
    
    [_mtgInterstitialAdManager loadWithDelegate:self];

}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Subclasses may override this method to return NO to perform impression and click tracking
    // manually.
    return NO;
}

- (void)showInterstitialFromRootViewController:(UIViewController *)rootViewController
{
    // The default implementation of this method does nothing. Subclasses must override this method
    // and implement code to display an interstitial here.
    [_mtgInterstitialAdManager showWithDelegate:self presentingViewController:rootViewController];
}




#pragma mark - MVInterstitialAdManagerDelegate

/**
 *  This protocol defines a listener for ad Interstitial load events.
 */
//@protocol MVInterstitialAdLoadDelegate <NSObject>

- (void) onInterstitialLoadSuccess{
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEvent: didLoadAd:)]) {
        [self.delegate interstitialCustomEvent:self didLoadAd:nil];
    }
}

- (void) onInterstitialLoadFail:(nonnull NSError *)error{

    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEvent: didFailToLoadAdWithError:)]) {
        [self.delegate interstitialCustomEvent:self didFailToLoadAdWithError:error];
    }
}


/**
 *  This protocol defines a listener for ad Interstitial show events.
 */
//@protocol MVInterstitialAdShowDelegate <NSObject>

- (void) onInterstitialShowSuccess{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEventWillAppear:)]) {
        [self.delegate interstitialCustomEventWillAppear:self ];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEventDidAppear:)]) {
        [self.delegate interstitialCustomEventDidAppear:self ];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(trackImpression)]) {
        [self.delegate trackImpression];
    }
}

- (void) onInterstitialShowFail:(nonnull NSError *)error{
    
}


- (void) onInterstitialClosed{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEventWillDisappear:)]) {
        [self.delegate interstitialCustomEventWillDisappear:self ];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEventDidDisappear:)]) {
        [self.delegate interstitialCustomEventDidDisappear:self ];
    }
}


- (void) onInterstitialAdClick{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(interstitialCustomEventDidReceiveTapEvent:)]) {
        [self.delegate interstitialCustomEventDidReceiveTapEvent:self ];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(trackClick)]) {
        [self.delegate trackClick];
    }
}


@end
