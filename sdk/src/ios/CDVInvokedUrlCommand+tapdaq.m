#import "CDVInvokedUrlCommand+tapdaq.h"

static NSString *const kCDVTDKeyIOS = @"ios";
static NSString *const kCDVTDKeyAppId = @"appId";
static NSString *const kCDVTDKeyClientKey = @"clientKey";
static NSString *const kCDVTDPropertiesKeyPluginVersion = @"pluginVersion";

static NSString *const kCDVTDKeyTestDevices = @"testDevices";
static NSString *const kCDVTDTestDevicesKeyNetwork = @"network";
static NSString *const kCDVTDTestDevicesKeyDevices = @"devices";
static NSString *const kCDVTDPropertiesKeyUserId = @"userId";
static NSString *const kCDVTDPropertiesKeyForwardUserId = @"forwardUserId";
static NSString *const kCDVTDPropertiesKeyLogLevel = @"logLevel";

static NSString *const kCDVTDOptsAdUnit = @"adUnit";
static NSString *const kCDVTDOptsPlacementTag = @"placementTag";

static NSString *const kCDVTDPropertiesKeyUserSubjectToGDPR = @"userSubjectToGDPR";
static NSString *const kCDVTDPropertiesKeyConsentGiven = @"isConsentGiven";
static NSString *const kCDVTDPropertiesKeyAgeRestrictedUser = @"isAgeRestrictedUser";
static NSString *const kCDVTDPropertiesKeyAdMobContentRating = @"adMobContentRating";

static NSString *const kCDVTDOptsBannerSize = @"bannerSize";
static NSString *const kCDVTDOptsBannerWidth = @"bannerWidth";
static NSString *const kCDVTDOptsBannerHeight = @"bannerHeight";


static NSString *const kCDVTDOptsBannerPosition = @"bannerPosition";
static NSString *const kCDVTDOptsBannerX = @"bannerX";
static NSString *const kCDVTDOptsBannerY = @"bannerY";

static NSString *const kCDVTDBannerPositionTypeTop = @"top";
static NSString *const kCDVTDBannerPositionTypeBottom = @"bottom";
static NSString *const kCDVTDBannerPositionTypeCustom = @"custom";

static NSString *const kCDVTDMBannerStandard = @"standard";
static NSString *const kCDVTDMBannerLarge = @"large";
static NSString *const kCDVTDMBannerMedium = @"medium";
static NSString *const kCDVTDMBannerFull = @"full";
static NSString *const kCDVTDMBannerLeaderboard = @"leaderboard";
static NSString *const kCDVTDMBannerSmart = @"smart";
static NSString *const kCDVTDMBannerCustom = @"custom";

// Unimplemented
static NSString *const kCDVTDPropertiesKeyAutoReloadAds = @"autoReloadAds";

@implementation CDVInvokedUrlCommand (tapdaq)
- (id)td_getArgumentWithKey:(NSString *)key ofClass:(Class)class {
    NSDictionary *options = (NSDictionary *) self.arguments.firstObject;
    if ([options isKindOfClass:NSDictionary.class]) {
        id object = options[key];
        if (class == nil) { return object; }
        if ([object isKindOfClass:class]) { return object;}
    }
    return nil;
}

- (id)td_getArgumentWithKey:(NSString *)key {
    return [self td_getArgumentWithKey:key ofClass:nil];
}


- (NSDictionary *)td_getArgumentIOSConfigDictionary {
    return [self td_getArgumentWithKey:kCDVTDKeyIOS ofClass:NSDictionary.class];
}


- (NSString *)td_getArgumentAppId {
    NSDictionary *config = [self td_getArgumentIOSConfigDictionary];
    id appId = config[kCDVTDKeyAppId];
    if ([appId isKindOfClass:NSString.class]) {
        return appId;
    }
    return nil;
}

- (NSString *)td_getArgumentClientKey {
    NSDictionary *config = [self td_getArgumentIOSConfigDictionary];
    id clientKey = config[kCDVTDKeyClientKey];
    if ([clientKey isKindOfClass:NSString.class]) {
        return clientKey;
    }
    return nil;
}

- (NSString *)td_getArgumentPluginVersion {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyPluginVersion ofClass:NSString.class];
}

- (NSString *)td_getArgumentUserId {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyUserId ofClass:NSString.class];
}

- (BOOL)td_getArgumentForwardUserId {
    return [[self td_getArgumentWithKey:kCDVTDPropertiesKeyForwardUserId ofClass:NSNumber.class] boolValue];
}

- (NSNumber *)td_getArgumentConsentGiven {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyConsentGiven ofClass:NSNumber.class];
}

- (NSNumber *)td_getArgumentSubjectToGdpr {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyUserSubjectToGDPR ofClass:NSNumber.class];
}

- (NSNumber *)td_getArgumentAgeRestrictedUser {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyAgeRestrictedUser ofClass:NSNumber.class];
}

- (NSString *)td_getArgumentAdMobContentRating {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyAdMobContentRating ofClass:NSString.class];
}

- (NSArray <TDTestDevices *>*)td_getArgumentTestDevices {
    NSMutableArray<TDTestDevices *> *tapdaqTestDevices = [NSMutableArray new];

    // iOS-specific properties
     NSDictionary *config = [self td_getArgumentIOSConfigDictionary];

    // Test devices
    NSArray *testDevices = config[kCDVTDKeyTestDevices];

    if (![testDevices isKindOfClass:NSArray.class]) {
        return @[];
    }

    for (id deviceObj in testDevices) {
        if (![deviceObj isKindOfClass:NSDictionary.class]) {
            continue;
        }

        NSDictionary *deviceDict = (NSDictionary *) deviceObj;

        NSString *network = deviceDict[kCDVTDTestDevicesKeyNetwork];
        NSArray *testDeviceIds = deviceDict[kCDVTDTestDevicesKeyDevices];

        if (![network isKindOfClass:NSString.class] || ![testDeviceIds isKindOfClass:NSArray.class]) {
            continue;
        }

        TDTestDevices *testDevices = [[TDTestDevices alloc] initWithNetwork:network testDevices:testDeviceIds];
        [tapdaqTestDevices addObject:testDevices];
    }
    return tapdaqTestDevices;
}

- (NSString *)td_getArgumentPlacementTag {
    return [self td_getArgumentWithKey:kCDVTDOptsPlacementTag ofClass:NSString.class];
}
- (TDAdUnit)td_getArgumentAdUnit {
    NSString *adUnitString = [self td_getArgumentWithKey:kCDVTDOptsAdUnit ofClass:NSString.class];
    return TDAdUnitFromString(adUnitString);
}

- (NSString *)td_getArgumentLogLevel {
    return [self td_getArgumentWithKey:kCDVTDPropertiesKeyLogLevel ofClass:NSString.class];
}

- (CGFloat)td_getArgumentBannerWidth {
    return [[self td_getArgumentWithKey:kCDVTDOptsBannerWidth ofClass:NSNumber.class] floatValue];
}

- (CGFloat)td_getArgumentBannerHeight {
    return [[self td_getArgumentWithKey:kCDVTDOptsBannerHeight ofClass:NSNumber.class] floatValue];
}

- (TDMBannerSize)td_getArgumentBannerSize {
    NSString *bannerSizeString = [self td_getArgumentWithKey:kCDVTDOptsBannerSize ofClass:NSString.class];
    return [self bannerSizeFromString:bannerSizeString];
}

- (TDBannerPositionType)td_getArgumentBannerPosition {
    NSString *bannerPositionTypeString = [self td_getArgumentWithKey:kCDVTDOptsBannerPosition ofClass:NSString.class];
    return [self bannerPositionTypeFromString:bannerPositionTypeString];
}

- (CGFloat)td_getArgumentBannerX {
    return [[self td_getArgumentWithKey:kCDVTDOptsBannerX ofClass:NSNumber.class] floatValue];
}

- (CGFloat)td_getArgumentBannerY {
    return [[self td_getArgumentWithKey:kCDVTDOptsBannerY ofClass:NSNumber.class] floatValue];
}
#pragma mark - Private
- (TDMBannerSize)bannerSizeFromString:(NSString *)string {
    TDMBannerSize bannerSize = TDMBannerStandard;
    if ([string isEqualToString:kCDVTDMBannerLarge]) {
        bannerSize = TDMBannerLarge;
    } else if ([string isEqualToString:kCDVTDMBannerMedium]) {
        bannerSize = TDMBannerMedium;
    } else if ([string isEqualToString:kCDVTDMBannerFull]) {
        bannerSize = TDMBannerFull;
    } else if ([string isEqualToString:kCDVTDMBannerLeaderboard]) {
        bannerSize = TDMBannerLeaderboard;
    } else if ([string isEqualToString:kCDVTDMBannerCustom]) {
        bannerSize = TDMBannerCustom;
    } else if ([string isEqualToString:kCDVTDMBannerSmart]) {
        bannerSize = TDMBannerSmart;
    }
    return bannerSize;
}


- (TDBannerPositionType)bannerPositionTypeFromString:(NSString *)string {
    TDBannerPositionType bannerPositionType = TDBannerPositionTypeBottom;
    if ([string isEqualToString:kCDVTDBannerPositionTypeTop]) {
        bannerPositionType = TDBannerPositionTypeTop;
    } else if ([string isEqualToString:kCDVTDBannerPositionTypeCustom]) {
        bannerPositionType = TDBannerPositionTypeCustom;
    }
    return bannerPositionType;
}
@end