//
//  MintegralAdapterHelper.m
//  MoPubSampleApp
//
//  Copyright © 2017年 MoPub. All rights reserved.
//

#import "MintegralAdapterHelper.h"
#import <MTGSDK/MTGSDK.h>

static BOOL mintegralSDKInitialized = NO;

NSString *const kMintegralErrorDomain = @"com.mintegral.iossdk.mopub";


@implementation MintegralAdapterHelper

+(BOOL)isSDKInitialized{

    return mintegralSDKInitialized;
}

+(void)sdkInitialized{

#ifdef DEBUG

    if (DEBUG) {
        NSLog(@"The version of current Mintegral Adapter is: %@",MintegralAdapterVersion);
    }
#endif
    Class class = NSClassFromString(@"MTGSDK");
    SEL selector = NSSelectorFromString(@"setChannelFlag:");
    
    NSString *pluginNumber = @"Y+H6DFttYrPQYcIA+F2F+F5/Hv==";
    
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([class respondsToSelector:selector]) {
        [class performSelector:selector withObject:pluginNumber];
    }
    #pragma clang diagnostic pop
    
    mintegralSDKInitialized = YES;
}

+(void)setGDPRInfo:(NSDictionary *)info{
    
    SEL selector = NSSelectorFromString(@"canCollectPersonalInfo");
    if ([[MoPub sharedInstance] respondsToSelector:selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Wdeprecated-declarations"
        BOOL consentOrNot = [[MoPub sharedInstance] performSelector:selector withObject:nil];
        [[MTGSDK sharedInstance] setConsentStatus:consentOrNot];
        #pragma clang diagnostic pop
    }
}

@end
