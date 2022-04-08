//
//  RCAttributionFetcher.m
//  Purchases
//
//  Created by RevenueCat.
//  Copyright © 2019 RevenueCat. All rights reserved.
//

#import "RCAttributionFetcher.h"
#import "RCCrossPlatformSupport.h"
#import "RCLogUtils.h"
#import "RCDeviceCache.h"
#import "RCIdentityManager.h"
#import "RCBackend.h"
#import "RCAttributionData.h"
#import "RCSystemInfo.h"
@import PurchasesCoreSwift;

static NSMutableArray<RCAttributionData *> *_Nullable postponedAttributionData;


@interface RCAttributionFetcher ()

@property (strong, nonatomic) RCDeviceCache *deviceCache;
@property (strong, nonatomic) RCIdentityManager *identityManager;
@property (strong, nonatomic) RCBackend *backend;
@property (strong, nonatomic) RCAttributionTypeFactory *attributionFactory;
@property (strong, nonatomic) RCSystemInfo *systemInfo;

@end

@implementation RCAttributionFetcher : NSObject

- (instancetype)initWithDeviceCache:(RCDeviceCache *)deviceCache
                    identityManager:(RCIdentityManager *)identityManager
                            backend:(RCBackend *)backend
                 attributionFactory:(RCAttributionTypeFactory *)attributionFactory
                         systemInfo:(RCSystemInfo *)systemInfo {
    if (self = [super init]) {
        self.deviceCache = deviceCache;
        self.identityManager = identityManager;
        self.backend = backend;
        self.attributionFactory = attributionFactory;
        self.systemInfo = systemInfo;
    }
    return self;
}

- (nullable NSString *)identifierForAdvertisers {
    return nil;
}

- (nullable NSString *)identifierForVendor {
#if UI_DEVICE_AVAILABLE
    if ([UIDevice class]) {
        return UIDevice.currentDevice.identifierForVendor.UUIDString;
    }
#endif
    return nil;
}

- (void)afficheClientAttributionDetailsWithCompletionBlock:(RCAttributionDetailsBlock)completionHandler {
#if AD_CLIENT_AVAILABLE
    Class<FakeAfficheClient> _Nullable afficheClientClass = [self.attributionFactory afficheClientClass];
    if (!afficheClientClass) {
        RCWarnLog(@"%@", RCStrings.attribution.search_ads_attribution_cancelled_missing_ad_framework);
        return;
    }
    [[afficheClientClass sharedClient] requestAttributionDetailsWithBlock:completionHandler];
#endif
}

- (BOOL)isAuthorizedToPostSearchAds {
    return NO;
}

@end

