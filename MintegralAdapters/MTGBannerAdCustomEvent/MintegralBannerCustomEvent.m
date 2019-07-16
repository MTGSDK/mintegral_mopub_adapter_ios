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


typedef enum {
    MintegralErrorBannerParaUnresolveable = 19,
    MintegralErrorBannerCamPaignListEmpty,
}MintegralBannerErrorCode;


@interface MintegralBannerCustomEvent() <MTGNativeAdManagerDelegate>

@property (nonatomic, strong) NSMutableDictionary *nativeManagerDict;
@property (nonatomic, strong) MTGNativeAdManager *mtgNativeAdManager;
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
    
    if (!_nativeManagerDict) {
        _nativeManagerDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    _mtgNativeAdManager = [_nativeManagerDict objectForKey:unitId];
    
    if (!_mtgNativeAdManager) {
        MTGNativeAdManager * mvManager = [[MTGNativeAdManager alloc] initWithUnitID:unitId fbPlacementId:@"" videoSupport:NO forNumAdsRequested:1 presentingViewController:nil];
        mvManager.delegate = self;
        [_nativeManagerDict setObject:mvManager forKey:unitId];
        _mtgNativeAdManager = mvManager;
    }
    
    _currentUnitID = unitId;
    _currentSize = size;
    [_mtgNativeAdManager loadAds];
}

- (void)requestAdWithSize:(CGSize)size customEventInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup{
    [self requestAdWithSize:size customEventInfo:info];
}


#pragma mark - nativeAdManager init and delegate

- (void)nativeAdsLoaded:(nullable NSArray *)nativeAds nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    //Callback successful, return ad information
    if ([_currentUnitID isEqualToString:nativeManager.currentUnitId]) {
        MTGCampaign *campaign = nativeAds.firstObject;
        if (campaign) {
            UIView * mtgBanner = [self mtgBannerWithCampaign:campaign];
            if ([self.delegate respondsToSelector:@selector(bannerCustomEvent: didLoadAd:)]) {
                [self.delegate bannerCustomEvent:self didLoadAd:mtgBanner];
            }
        }else{
            NSError *error = [NSError errorWithDomain:kMintegralErrorDomain code:MintegralErrorBannerCamPaignListEmpty userInfo:@{NSLocalizedDescriptionKey : @"Empty Campaign list"}];
            if ([self.delegate respondsToSelector:@selector(bannerCustomEvent: didFailToLoadAdWithError:)]) {
                [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
            }
        }
    }
}

- (void)nativeAdsFailedToLoadWithError:(nonnull NSError *)error nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    //Callback unsuccessful, make necessary changes
    if ([_currentUnitID isEqualToString:nativeManager.currentUnitId]) {
        if ([self.delegate respondsToSelector:@selector(bannerCustomEvent: didFailToLoadAdWithError:)]) {
            [self.delegate bannerCustomEvent:self didFailToLoadAdWithError:error];
        }
    }
}

- (void)nativeAdImpressionWithType:(MTGAdSourceType)type nativeManager:(nonnull MTGNativeAdManager *)nativeManager{
    if ([nativeManager.currentUnitId isEqualToString:_currentUnitID]) {
        if ([self.delegate respondsToSelector:@selector(trackImpression)]) {
            [self.delegate trackImpression];
        }
    }
}

- (void)nativeAdDidClick:(MTGCampaign *)nativeAd nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    if ([nativeManager.currentUnitId isEqualToString:_currentUnitID]) {
        if ([self.delegate respondsToSelector:@selector(trackClick)]) {
            [self.delegate trackClick];
        }
    }
}


- (void)nativeAdClickUrlWillStartToJump:(nonnull NSURL *)clickUrl nativeManager:(nonnull MTGNativeAdManager *)nativeManager
{
    if ([self.delegate respondsToSelector:@selector(bannerCustomEventWillLeaveApplication:)]) {
        [self.delegate bannerCustomEventWillLeaveApplication:self];
    }
}

#pragma mark - Turn off auto impression and click
- (BOOL)enableAutomaticImpressionAndClickTracking
{
    // Subclasses may override this method to return NO to perform impression and click tracking
    // manually.
    return NO;
}

#pragma mark - getBanner

-(UIView *)mtgBannerWithCampaign:(MTGCampaign *)cam{
    UIView * bannerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _currentSize.width, _currentSize.height)];
    bannerContainer.backgroundColor = [UIColor clearColor];
    
    UIView * mtgBanner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _currentSize.width, _currentSize.height)];
    mtgBanner.backgroundColor = [UIColor whiteColor];
    
    [bannerContainer addSubview:mtgBanner];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.text = cam.appName;
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:14];
    titleLabel.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1/1.0];
    titleLabel.clipsToBounds = YES;
    [mtgBanner addSubview:titleLabel];
    
    UILabel * desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    desLabel.text = cam.appDesc;
    desLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    desLabel.textColor = [UIColor colorWithRed:72/255.0 green:72/255.0 blue:72/255.0 alpha:1/1.0];
    desLabel.clipsToBounds = YES;
    [mtgBanner addSubview:desLabel];
    
    UIImageView * iconIV = [[UIImageView alloc] initWithFrame:CGRectZero];
    iconIV.layer.cornerRadius = 10;
    iconIV.layer.borderWidth = 1;
    iconIV.layer.borderColor = [self.class colorWithHex:@"#979797"].CGColor;
    iconIV.clipsToBounds = YES;
    [cam loadIconUrlAsyncWithBlock:^(UIImage *image) {
        if (image) {
            [iconIV setImage:image];
        }
    }];
    [mtgBanner addSubview:iconIV];
    
    UIView * CTABackground = [[UIView alloc] initWithFrame:CGRectZero];
    CAGradientLayer * gradientLayer = [self.class setGradualChangingColor:CGRectMake(0, 0, 89, 30) fromColor:@"80C426" toColor:@"19C84F"];
    gradientLayer.cornerRadius = 15;
    [CTABackground.layer addSublayer:gradientLayer];
    [mtgBanner addSubview:CTABackground];
    
    UILabel * CTALabel = [[UILabel alloc] initWithFrame:CGRectZero];
    CTALabel.lineBreakMode = NSLineBreakByCharWrapping;
    CTALabel.clipsToBounds = YES;
    CTALabel.text = cam.adCall;
    CTALabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
    [mtgBanner addSubview:CTALabel];
    CTALabel.textColor = [UIColor whiteColor];
    CTALabel.backgroundColor = [UIColor clearColor];
    CTALabel.textAlignment = NSTextAlignmentCenter;
    
    
    
    mtgBanner.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    desLabel.translatesAutoresizingMaskIntoConstraints = NO;
    iconIV.translatesAutoresizingMaskIntoConstraints = NO;
    CTALabel.translatesAutoresizingMaskIntoConstraints = NO;
    CTABackground.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(mtgBanner,titleLabel,desLabel,iconIV,CTALabel);
    [bannerContainer addConstraint:[NSLayoutConstraint constraintWithItem:mtgBanner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:bannerContainer attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [bannerContainer addConstraint:[NSLayoutConstraint constraintWithItem:mtgBanner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:bannerContainer attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:mtgBanner attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_currentSize.width]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:mtgBanner attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_currentSize.height]];
    [mtgBanner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(8)-[iconIV(48)]-(4)-[desLabel(>=100@250)]-(6)-[CTALabel(79)]-(8)-|" options:0 metrics:nil views:viewDict]];
    [iconIV addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconIV(48)]" options:0 metrics:nil views:viewDict]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:iconIV attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:mtgBanner attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [mtgBanner addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(20)]-(3)-[desLabel(17)]" options:0 metrics:nil views:viewDict]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:desLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:mtgBanner attribute:NSLayoutAttributeCenterY multiplier:1 constant:1.5]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:desLabel attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:desLabel attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [CTALabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[CTALabel(30)]" options:0 metrics:nil views:viewDict]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:CTALabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:mtgBanner attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:CTALabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:CTABackground attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:CTALabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:CTABackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:CTALabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:CTABackground attribute:NSLayoutAttributeWidth multiplier:1 constant:-10]];
    [mtgBanner addConstraint:[NSLayoutConstraint constraintWithItem:CTALabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:CTABackground attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
    
    MTGNativeAdManager * manager = [_nativeManagerDict objectForKey:_currentUnitID];
    [manager registerViewForInteraction:bannerContainer withCampaign:cam];
    return bannerContainer;
    
}

+ (CAGradientLayer *)setGradualChangingColor:(CGRect )frame fromColor:(NSString *)fromHexColorStr toColor:(NSString *)toHexColorStr{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = frame;
    
    gradientLayer.colors = @[(__bridge id)[self.class colorWithHex:fromHexColorStr].CGColor,(__bridge id)[self.class colorWithHex:toHexColorStr].CGColor];
    
    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    
    gradientLayer.locations = @[@0,@1];
    
    return gradientLayer;
}

+ (UIColor *)colorWithHex:(NSString *)hexColor {
    hexColor = [hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([hexColor length] < 6) {
        return nil;
    }
    if ([hexColor hasPrefix:@"#"]) {
        hexColor = [hexColor substringFromIndex:1];
    }
    NSRange range;
    range.length = 2;
    range.location = 0;
    NSString *rs = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gs = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bs = [hexColor substringWithRange:range];
    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:rs] scanHexInt:&r];
    [[NSScanner scannerWithString:gs] scanHexInt:&g];
    [[NSScanner scannerWithString:bs] scanHexInt:&b];
    if ([hexColor length] == 8) {
        range.location = 4;
        NSString *as = [hexColor substringWithRange:range];
        [[NSScanner scannerWithString:as] scanHexInt:&a];
    } else {
        a = 255;
    }
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:((float)a / 255.0f)];
}
@end


