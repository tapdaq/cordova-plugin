/********* CDVTapdaq.m Cordova Plugin Implementation *******/

#import "CDVTapdaq.h"
#import "TapdaqMoreApps.h"
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

static NSString *const kCDVTDNativeAdType1x1Large = @"NativeAdType1x1Large";
static NSString *const kCDVTDNativeAdType1x1Medium = @"NativeAdType1x1Medium";
static NSString *const kCDVTDNativeAdType1x1Small = @"NativeAdType1x1Small";

static NSString *const kCDVTDNativeAdType1x2Large = @"NativeAdType1x2Large";
static NSString *const kCDVTDNativeAdType1x2Medium = @"NativeAdType1x2Medium";
static NSString *const kCDVTDNativeAdType1x2Small = @"NativeAdType1x2Small";
static NSString *const kCDVTDNativeAdType2x1Large = @"NativeAdType2x1Large";
static NSString *const kCDVTDNativeAdType2x1Medium = @"NativeAdType2x1Medium";
static NSString *const kCDVTDNativeAdType2x1Small = @"NativeAdType2x1Small";

static NSString *const kCDVTDNativeAdType2x3Large = @"NativeAdType2x3Large";
static NSString *const kCDVTDNativeAdType2x3Medium = @"NativeAdType2x3Medium";
static NSString *const kCDVTDNativeAdType2x3Small = @"NativeAdType2x3Small";
static NSString *const kCDVTDNativeAdType3x2Large = @"NativeAdType3x2Large";
static NSString *const kCDVTDNativeAdType3x2Medium = @"NativeAdType3x2Medium";
static NSString *const kCDVTDNativeAdType3x2Small = @"NativeAdType3x2Small";

static NSString *const kCDVTDNativeAdType1x5Large = @"NativeAdType1x5Large";
static NSString *const kCDVTDNativeAdType1x5Medium = @"NativeAdType1x5Medium";
static NSString *const kCDVTDNativeAdType1x5Small = @"NativeAdType1x5Small";
static NSString *const kCDVTDNativeAdType5x1Large = @"NativeAdType5x1Large";
static NSString *const kCDVTDNativeAdType5x1Medium = @"NativeAdType5x1Medium";
static NSString *const kCDVTDNativeAdType5x1Small = @"NativeAdType5x1Small";

static NSString *const kCDVTDAdTypeNone = @"AdTypeNone";
static NSString *const kCDVTDAdTypeInterstitial = @"AdTypeInterstitial";
static NSString *const kCDVTDAdTypeVideo = @"AdTypeVideo";
static NSString *const kCDVTDAdTypeRewardedVideo = @"AdTypeRewardedVideo";
static NSString *const kCDVTDAdTypeBanner = @"AdTypeBanner";
static NSString *const kCDVTDAdTypeOfferwall = @"AdTypeOfferwall";
static NSString *const kCDVTDAdTypeMoreApps = @"AdTypeMoreApps";

static NSString *const kCDVTDCallbackDidInitialise = @"didInitialise";
static NSString *const kCDVTDCallbackDidLoad = @"didLoad";
static NSString *const kCDVTDCallbackDidFailToLoad = @"didFailToLoad";
static NSString *const kCDVTDCallbackDidClick = @"didClick";
static NSString *const kCDVTDCallbackDidRefresh = @"didRefresh";
static NSString *const kCDVTDCallbackWillDisplay = @"willDisplay";
static NSString *const kCDVTDCallbackDidDisplay = @"didDisplay";
static NSString *const kCDVTDCallbackDidClose = @"didClose";
static NSString *const kCDVTDCallbackDidVerify = @"didVerify";
static NSString *const kCDVTDCallbackDidRewardFail = @"didRewardFail";
static NSString *const kCDVTDCallbackDidCustomEvent = @"didCustomEvent";

@implementation CDVTapdaq

- (void)init:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    self.callbackId = command.callbackId;
    self.properties = [[TDProperties alloc] init];
    
    self.nativeAds = [[NSMutableDictionary alloc] init];
    self.nativeAdTypes = @{
                           kCDVTDNativeAdType1x1Large: @((int)TDNativeAdType1x1Large),
                           kCDVTDNativeAdType1x1Medium: @((int)TDNativeAdType1x1Medium),
                           kCDVTDNativeAdType1x1Small: @((int)TDNativeAdType1x1Small),
                           
                           kCDVTDNativeAdType1x2Large: @((int)TDNativeAdType1x2Large),
                           kCDVTDNativeAdType1x2Medium: @((int)TDNativeAdType1x2Medium),
                           kCDVTDNativeAdType1x2Small: @((int)TDNativeAdType1x2Small),
                           
                           kCDVTDNativeAdType2x1Large: @((int)TDNativeAdType2x1Large),
                           kCDVTDNativeAdType2x1Medium: @((int)TDNativeAdType2x1Medium),
                           kCDVTDNativeAdType2x1Small: @((int)TDNativeAdType2x1Small),
                           
                           kCDVTDNativeAdType2x3Large: @((int)TDNativeAdType2x3Large),
                           kCDVTDNativeAdType2x3Medium: @((int)TDNativeAdType2x3Medium),
                           kCDVTDNativeAdType2x3Small: @((int)TDNativeAdType2x3Small),
                           
                           kCDVTDNativeAdType3x2Large: @((int)TDNativeAdType3x2Large),
                           kCDVTDNativeAdType3x2Medium: @((int)TDNativeAdType3x2Medium),
                           kCDVTDNativeAdType3x2Small: @((int)TDNativeAdType3x2Small),
                           
                           kCDVTDNativeAdType1x5Large: @((int)TDNativeAdType1x5Large),
                           kCDVTDNativeAdType1x5Medium: @((int)TDNativeAdType1x5Medium),
                           kCDVTDNativeAdType1x5Small: @((int)TDNativeAdType1x5Small),
                           
                           kCDVTDNativeAdType5x1Large: @((int)TDNativeAdType5x1Large),
                           kCDVTDNativeAdType5x1Medium: @((int)TDNativeAdType5x1Medium),
                           kCDVTDNativeAdType5x1Small: @((int)TDNativeAdType5x1Small)
                           };
    
    self.validAdTypes = @{
                          kCDVTDAdTypeNone: @(0),
                          kCDVTDAdTypeInterstitial: @(1),
                          kCDVTDNativeAdType1x1Large: @(2),
                          kCDVTDNativeAdType1x1Medium: @(3),
                          kCDVTDNativeAdType1x1Small: @(4),
                          
                          kCDVTDNativeAdType1x2Large: @(5),
                          kCDVTDNativeAdType1x2Medium: @(6),
                          kCDVTDNativeAdType1x2Small: @(7),
                          
                          kCDVTDNativeAdType2x1Large: @(8),
                          kCDVTDNativeAdType2x1Medium: @(9),
                          kCDVTDNativeAdType2x1Small: @(10),
                          
                          kCDVTDNativeAdType2x3Large: @(11),
                          kCDVTDNativeAdType2x3Medium: @(12),
                          kCDVTDNativeAdType2x3Small: @(13),
                          
                          kCDVTDNativeAdType3x2Large: @(14),
                          kCDVTDNativeAdType3x2Medium: @(15),
                          kCDVTDNativeAdType3x2Small: @(16),
                          
                          kCDVTDNativeAdType1x5Large: @(17),
                          kCDVTDNativeAdType1x5Medium: @(18),
                          kCDVTDNativeAdType1x5Small: @(19),
                          
                          kCDVTDNativeAdType5x1Large: @(20),
                          kCDVTDNativeAdType5x1Medium: @(21),
                          kCDVTDNativeAdType5x1Small: @(22),
                          
                          kCDVTDAdTypeVideo: @(23),
                          kCDVTDAdTypeRewardedVideo: @(24),
                          kCDVTDAdTypeBanner: @(25),
                          kCDVTDAdTypeOfferwall: @(26)
                          };
    
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    
    NSDictionary *iosOptions = nil;
    if ([options objectForKey:@"ios"]) {
        iosOptions = (NSDictionary*)[options objectForKey:@"ios"];
    }
    
    bool isValid = [self validateInitOptions:options];
    
    if (!isValid) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"Incorrect options are given"];
        [pluginResult setKeepCallbackAsBool:YES];
        self.callbackId = command.callbackId;
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        return;
    }
    
    NSString *appId = [iosOptions objectForKey:@"appId"];
    NSString *clientKey = [iosOptions objectForKey:@"clientKey"];
    
    NSMutableArray *enabledPlacements = nil;
    if ([options objectForKey:@"enabledPlacements"]) {
        enabledPlacements = (NSMutableArray *) [options objectForKey:@"enabledPlacements"];
    }
    
    NSArray *testDevices = nil;
    if ([iosOptions objectForKey:@"testDevices"]) {
        testDevices = (NSArray *) [iosOptions objectForKey:@"testDevices"];
    }
    [self setTestDevices:testDevices toProperties:self.properties];
    
    BOOL isDebugEnabled = NO;
    if ([options objectForKey:@"debugMode"]) {
        isDebugEnabled = [[options objectForKey:@"debugMode"] boolValue];
        self.isDebug = isDebugEnabled;
    }
    self.properties.isDebugEnabled = self.isDebug;
    
    BOOL autoReloadAds = NO;
    if ([options objectForKey:@"autoReload"]) {
        autoReloadAds = [[options objectForKey:@"autoReload"] boolValue];
    }
    self.properties.autoReloadAds = autoReloadAds;
    
    NSMutableDictionary *tagsWithAdTypes = [[NSMutableDictionary alloc] init];
    
    // register MoreApps tags as tags for TDNativeAdType1x1Medium
    for (NSDictionary *dict in [enabledPlacements copy]) {
        NSString *adTypeStr = [dict objectForKey:@"adType"];
        NSArray *placementTags = [dict objectForKey:@"tags"];
        if([adTypeStr isEqualToString:kCDVTDAdTypeMoreApps]){
            NSDictionary *newPlacements = @{
                                            @"adType": kCDVTDNativeAdType1x1Medium,
                                            @"tags": placementTags
                                            };
            [enabledPlacements addObject: newPlacements];
        }
    }
    for (NSDictionary *dict in enabledPlacements) {
        
        NSString *adTypeStr = [dict objectForKey:@"adType"];
        NSArray *placementTags = [dict objectForKey:@"tags"];
        
        if ([placementTags count] > 0) {
            for (NSString *placementTag in placementTags) {
                
                // update tagsWithAdTypes
                NSNumber *combinedAdTypeNum = [tagsWithAdTypes objectForKey:placementTag];
                
                if (!combinedAdTypeNum) {
                    combinedAdTypeNum = @(0);
                }
                
                TDAdTypes adTypesCombined = [combinedAdTypeNum integerValue];
                
                NSNumber *adTypeNum = [self.validAdTypes objectForKey:adTypeStr];
                NSInteger adTypeInt = [adTypeNum integerValue];
                
                adTypesCombined |= 1 << adTypeInt;
                
                combinedAdTypeNum = @(adTypesCombined);
                
                [tagsWithAdTypes setObject:combinedAdTypeNum forKey:placementTag];
                
            }
        }
        
    }
    [self log: [NSString stringWithFormat: @"tagsWithAdTypes: %@", tagsWithAdTypes]];
    for (id key in tagsWithAdTypes) {
        
        if ([key isKindOfClass:[NSString class]] && [[tagsWithAdTypes objectForKey:key] integerValue] > 0) {
            NSString *tag = (NSString *) key;
            TDAdTypes adTypes = (TDAdTypes) [[tagsWithAdTypes objectForKey:key] integerValue];
            
            if (tag && [tag length] > 0) {
                TDPlacement *placement = [[TDPlacement alloc] initWithAdTypes:adTypes forTag:tag];
                [self.properties registerPlacement:placement];
            }
            
        }
        
    }
    
    @try {
        [[Tapdaq sharedSession] setApplicationId:appId clientKey:clientKey properties:self.properties];
        [[Tapdaq sharedSession] launch];
        [[Tapdaq sharedSession] setDelegate:self];
    } @catch (NSException *exception) {
        [self error: [NSString stringWithFormat: @"initialization error, reason: %@", exception.reason]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: [@"initialization error: " stringByAppendingString:exception.reason]];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
    }
    
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)load:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = nil;
    self.callbackId = command.callbackId;
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    
    NSString *tag = nil;
    if ([options objectForKey:@"tag"]) {
        tag = (NSString*)[options objectForKey:@"tag"];
    }
    
    NSString *size = nil;
    if ([options objectForKey:@"size"]) {
        size = (NSString*)[options objectForKey:@"size"];
    }
    
    NSDictionary *moreAppsConfig = nil;
    if ([options objectForKey:@"options"]) {
        size = (NSString*)[options objectForKey:@"options"];
    }
    
    if ([adType isEqualToString:kCDVTDAdTypeInterstitial]) {
        if (tag) {
            [[Tapdaq sharedSession] loadInterstitialForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] loadInterstitial];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeVideo]) {
        if (tag) {
            [[Tapdaq sharedSession] loadVideoForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] loadVideo];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeRewardedVideo]) {
        if (tag) {
            [[Tapdaq sharedSession] loadRewardedVideoForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] loadRewardedVideo];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeBanner]) {
        TDMBannerSize bannerSize = [self bannerSizeFromString:size];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[Tapdaq sharedSession] loadBanner:bannerSize];
        });
        
    } else if ([adType isEqualToString:kCDVTDAdTypeOfferwall]) {
        [[Tapdaq sharedSession] loadOfferwall];
    } else if ([adType isEqualToString:kCDVTDAdTypeMoreApps]) {
        if (moreAppsConfig != nil){
            [[TapdaqMoreApps sharedInstance] loadWithConfig: moreAppsConfig];
        }else{
            [[TapdaqMoreApps sharedInstance] load];
        }
    } else {
        NSNumber *nativeAdTypeNum = [self.nativeAdTypes objectForKey:adType];
        
        if (nativeAdTypeNum) {
            TDNativeAdType type = [nativeAdTypeNum intValue];
            [[Tapdaq sharedSession] loadNativeAdvertForPlacementTag:tag adType:type];
        }
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}


- (void)isReady:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult *pluginResult = nil;
    self.callbackId = command.callbackId;
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    
    NSString *tag = nil;
    if ([options objectForKey:@"tag"]) {
        tag = (NSString*)[options objectForKey:@"tag"];
    }
    
    BOOL result = NO;
    
    if ([adType isEqualToString:kCDVTDAdTypeInterstitial]) {
        if (tag) {
            result = [[Tapdaq sharedSession] isInterstitialReadyForPlacementTag:tag];
        } else {
            result = [[Tapdaq sharedSession] isInterstitialReady];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeVideo]) {
        if (tag) {
            result = [[Tapdaq sharedSession] isVideoReadyForPlacementTag:tag];
        } else {
            result = [[Tapdaq sharedSession] isVideoReady];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeRewardedVideo]) {
        if (tag) {
            result = [[Tapdaq sharedSession] isRewardedVideoReadyForPlacementTag:tag];
        } else {
            result = [[Tapdaq sharedSession] isRewardedVideoReady];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeBanner]) {
        result = [[Tapdaq sharedSession] isBannerReady];
    } else if ([adType isEqualToString:kCDVTDAdTypeOfferwall]) {
        result = [[Tapdaq sharedSession] isOfferwallReady];
    } else if ([adType isEqualToString:kCDVTDAdTypeMoreApps]) {
        result = [[TapdaqMoreApps sharedInstance] isReady];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:result];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = nil;
    self.callbackId = command.callbackId;
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    
    NSString *tag = nil;
    if ([options objectForKey:@"tag"]) {
        tag = (NSString*)[options objectForKey:@"tag"];
    }
    
    NSString *position = nil;
    if ([options objectForKey:@"position"]) {
        position = (NSString*)[options objectForKey:@"position"];
    }
    
    if ([adType isEqualToString:kCDVTDAdTypeInterstitial]) {
        if (tag) {
            [[Tapdaq sharedSession] showInterstitialForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] showInterstitial];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeVideo]) {
        if (tag) {
            [[Tapdaq sharedSession] showVideoForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] showVideo];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeRewardedVideo]) {
        if (tag) {
            [[Tapdaq sharedSession] showRewardedVideoForPlacementTag:tag];
        } else {
            [[Tapdaq sharedSession] showRewardedVideo];
        }
    } else if ([adType isEqualToString:kCDVTDAdTypeBanner]) {
        [self showBanner:position];
    } else if ([adType isEqualToString:kCDVTDAdTypeOfferwall]) {
        [[Tapdaq sharedSession] showOfferwall];
    } else if ([adType isEqualToString:kCDVTDAdTypeMoreApps]) {
        [[TapdaqMoreApps sharedInstance] show];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)setTestDevices:(NSArray *)testDevicesDictionaryArray toProperties:(TDProperties *)properties
{
    if(testDevicesDictionaryArray != nil) {
        NSArray* amArray = nil;
        NSArray* fbArray = nil;
        for (NSDictionary* obj in testDevicesDictionaryArray) {
            if([[obj objectForKey:@"network"] isEqual:@"AdMob"]){
                amArray = (NSArray*) [obj objectForKey:@"devices"];
                if(amArray != nil){
                    TDTestDevices *amTestDevices = [[TDTestDevices alloc] initWithNetwork:TDMAdMob testDevices:amArray];
                    [properties registerTestDevices: amTestDevices];
                }
            }
            if([[obj objectForKey:@"network"] isEqual:@"Facebook"]){
                fbArray = (NSArray*) [obj objectForKey:@"devices"];
                if(fbArray != nil){
                    TDTestDevices *amTestDevices = [[TDTestDevices alloc] initWithNetwork:TDMFacebookAudienceNetwork testDevices:fbArray];
                    [properties registerTestDevices: amTestDevices];
                }
            }
            
        }
    }
}

- (void)showDebugPanel:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult *pluginResult = nil;
    self.callbackId = command.callbackId;
    
    [[Tapdaq sharedSession] presentDebugViewController];
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)showBanner:(NSString*)position
{
    self.bannerView = [[Tapdaq sharedSession] getBanner];
    
    if (self.bannerView != nil) {
        CGSize bannerSize = self.bannerView.frame.size;
        CGSize webViewSize = self.webView.frame.size;
        
        // calculating Y of banner for "top" or "bottom" position
        float bannerY = [[position lowercaseString] isEqualToString:@"top"] ?
        0 : webViewSize.height-bannerSize.height;
        
        self.bannerView.frame = CGRectMake((webViewSize.width-bannerSize.width)/2,
                                           bannerY,
                                           bannerSize.width,
                                           bannerSize.height);
        
        [self.webView addSubview:self.bannerView];
    }
}

- (void)hide:(CDVInvokedUrlCommand*)command
{
    self.callbackId = command.callbackId;
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    if ([adType isEqualToString:kCDVTDAdTypeBanner]) {
        if (self.bannerView != nil) {
            [self.bannerView removeFromSuperview];
            self.bannerView = nil;
        }
    }
}

- (void)triggerNativeAdClick: (CDVInvokedUrlCommand*)command
{
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    NSString *uniqueId = nil;
    if ([options objectForKey:@"id"]) {
        uniqueId = (NSString*)[options objectForKey:@"id"];
    }
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    
    TDNativeAdvert *nativeAd = nil;
    if ([self.nativeAds objectForKey: uniqueId]) {
        nativeAd = (TDNativeAdvert*)[self.nativeAds objectForKey: uniqueId];
    }
    
    if (nativeAd != nil) {
        [nativeAd triggerClick];
        
    } else {
        [self error:[NSString stringWithFormat:@"Could not find nativeAd with uniqueId: %@", uniqueId]];
    }
}

- (void)triggerNativeAdImpression: (CDVInvokedUrlCommand*)command
{
    NSDictionary *options = (NSDictionary*)[command.arguments objectAtIndex:0];
    NSString *uniqueId = nil;
    if ([options objectForKey:@"id"]) {
        uniqueId = (NSString*)[options objectForKey:@"id"];
    }
    
    NSString *adType = nil;
    if ([options objectForKey:@"adType"]) {
        adType = (NSString*)[options objectForKey:@"adType"];
    }
    
    TDNativeAdvert *nativeAd = nil;
    if ([self.nativeAds objectForKey: uniqueId]) {
        nativeAd = (TDNativeAdvert*)[self.nativeAds objectForKey: uniqueId];
    }
    
    if(nativeAd != nil) {
        [nativeAd triggerImpression];
    } else {
        [self error:[NSString stringWithFormat:@"Could not find nativeAd with uniqueId: %@", uniqueId]];
    }
    
}

- (bool)validateInitOptions: (NSDictionary*)options
{
    NSDictionary *iosOptions = nil;
    if ([options objectForKey:@"ios"]) {
        iosOptions = (NSDictionary*)[options objectForKey:@"ios"];
    }
    
    if(options == nil){
        return false;
    }
    NSString *appId = nil;
    if ([iosOptions objectForKey:@"appId"]) {
        appId = [iosOptions objectForKey:@"appId"];
    }
    if(appId == nil){
        [self error:[NSString stringWithFormat:@"validate init options, appId is invalid"]];
        return false;
    }
    
    NSString *clientKey = nil;
    if ([iosOptions objectForKey:@"clientKey"]) {
        clientKey = [iosOptions objectForKey:@"clientKey"];
    }
    if(clientKey == nil){
        [self error:[NSString stringWithFormat:@"validate init options, clientKey is invalid"]];
        return false;
    }
    
    NSArray *enablePlacements = nil;
    if ([options objectForKey:@"enabledPlacements"]) {
        enablePlacements = [options objectForKey:@"enabledPlacements"];
    }
    if(enablePlacements == nil){
        [self error:[NSString stringWithFormat:@"validate init options, enabledPlacements is invalid"]];
        return false;
    }
    
    return true;
}

#pragma mark - Private methods

- (void)dispatchEvent:(NSString *)event forAdTypeString:(NSString *)adTypeStr
{
    [self dispatchEvent:event withPlacementTag:nil forAdTypeString:adTypeStr];
}

- (void)dispatchEvent:(NSString *)event
     withPlacementTag:(NSString *)tag
      forAdTypeString:(NSString *)adTypeStr
{
    NSDictionary *dict;
    
    if (tag) {
        dict = @{
                 @"adType": adTypeStr,
                 @"tag": tag
                 };
    }else{
        dict = @{
                 @"adType": adTypeStr
                 };
    }
    
    [self dispatchEvent:event withData:dict];
}

- (void)dispatchEvent:(NSString *)event withData:(NSDictionary *)eventData
{
    NSDictionary *response = @{
                               @"event": event,
                               @"eventData": eventData
                               };
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:response];
    [self log: [NSString stringWithFormat: @"dispatchEvent %@, eventData: %@", event, eventData]];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:self.callbackId];
}

- (TDMBannerSize)bannerSizeFromString:(NSString *)sizeStr
{
    TDMBannerSize bannerSize = TDMBannerStandard;
    
    if ([sizeStr isEqualToString:@"STANDARD"]) {
        bannerSize = TDMBannerStandard;
    } else if ([sizeStr isEqualToString:@"LARGE"]) {
        bannerSize = TDMBannerLarge;
    } else if ([sizeStr isEqualToString:@"MEDIUM_RECT"]) {
        bannerSize = TDMBannerMedium;
    } else if ([sizeStr isEqualToString:@"FULL"]) {
        bannerSize = TDMBannerFull;
    } else if ([sizeStr isEqualToString:@"LEADERBOARD"]) {
        bannerSize = TDMBannerLeaderboard;
    } else if ([sizeStr isEqualToString:@"SMART"]) {
        bannerSize = TDMBannerSmartPortrait;
    }
    
    return bannerSize;
}

- (NSString *)getStringFromAdType:(TDNativeAdType)adType
{
    NSArray* typeNumbers = [self.nativeAdTypes allKeysForObject:[NSNumber numberWithInt:(int)adType]];
    if(typeNumbers.count < 1)
        return @"TDNativeAdType1x1Large";
    return typeNumbers[0];
}

#pragma mark - Tapdaq Delegate

- (void)didLoadConfig
{
    [self dispatchEvent:kCDVTDCallbackDidInitialise
               withData:@{}];
}

#pragma mark Banner delegate methods

- (void)didLoadBanner
{
    [self dispatchEvent:kCDVTDCallbackDidLoad forAdTypeString:kCDVTDAdTypeBanner];
}

- (void)didFailToLoadBanner
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad forAdTypeString:kCDVTDAdTypeBanner];
}

- (void)didClickBanner
{
    [self dispatchEvent:kCDVTDCallbackDidClick forAdTypeString:kCDVTDAdTypeBanner];
}

- (void)didRefreshBanner
{
    [self dispatchEvent:kCDVTDCallbackDidRefresh forAdTypeString:kCDVTDAdTypeBanner];
}

#pragma mark Interstitial delegate methods

- (void)didLoadInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

- (void)didFailToLoadInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

- (void)willDisplayInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackWillDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

- (void)didDisplayInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

- (void)didCloseInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClose
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

- (void)didClickInterstitialForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClick
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeInterstitial];
}

#pragma mark Video delegate methods

- (void)didLoadVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

- (void)didFailToLoadVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

- (void)willDisplayVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackWillDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

- (void)didDisplayVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

- (void)didCloseVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClose
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

- (void)didClickVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClick
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeVideo];
}

#pragma mark Rewarded Video delegate methods

- (void)didLoadRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)didFailToLoadRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)willDisplayRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackWillDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)didDisplayRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidDisplay
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)didCloseRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClose
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)didClickRewardedVideoForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidClick
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

- (void)rewardValidationSucceededForPlacementTag:(NSString *)placementTag
                                      rewardName:(NSString *)rewardName
                                    rewardAmount:(int)rewardAmount
                                         payload:(NSDictionary *)payload
{
    NSMutableDictionary* dict = [@{
                                   @"adType": kCDVTDAdTypeRewardedVideo,
                                   @"tag": placementTag,
                                   @"rewardName": rewardName,
                                   @"rewardAmount": @(rewardAmount)
                                   } mutableCopy];
    if (payload) {
        dict[@"payload"] = payload;
    }
    
    [self dispatchEvent:kCDVTDCallbackDidVerify withData:dict];
}

- (void)rewardValidationErroredForPlacementTag:(NSString *)placementTag
{
    [self dispatchEvent:kCDVTDCallbackDidRewardFail
       withPlacementTag:placementTag
        forAdTypeString:kCDVTDAdTypeRewardedVideo];
}

#pragma mark Offerwall delegate methods

- (void)didLoadOfferwall
{
    [self dispatchEvent:kCDVTDCallbackDidLoad withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeOfferwall];
}

- (void)didFailToLoadOfferwall
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeOfferwall];
}

- (void)willDisplayOfferwall
{
    [self dispatchEvent:kCDVTDCallbackWillDisplay withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeOfferwall];
}

- (void)didDisplayOfferwall
{
    [self dispatchEvent:kCDVTDCallbackDidDisplay withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeOfferwall];
}

- (void)didCloseOfferwall
{
    [self dispatchEvent:kCDVTDCallbackDidClose withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeOfferwall];
}

- (void)didReceiveOfferwallCredits:(NSDictionary *)creditInfo
{
    NSMutableDictionary *dict = [creditInfo mutableCopy];
    dict[@"adType"] = kCDVTDAdTypeOfferwall;
    dict[@"tag"] = TDPTagDefault;
    
    [self dispatchEvent:kCDVTDCallbackDidCustomEvent
               withData:dict];
}

#pragma mark MoreApps delegate methods

- (void)didLoadMoreApps
{
    [self dispatchEvent:kCDVTDCallbackDidLoad withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeMoreApps];
}

- (void)didFailToLoadMoreApps
{
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeMoreApps];
}

- (void)willDisplayMoreApps
{
    [self dispatchEvent:kCDVTDCallbackWillDisplay withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeMoreApps];
}

- (void)didDisplayMoreApps
{
    [self dispatchEvent:kCDVTDCallbackDidDisplay withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeMoreApps];
}

- (void)didCloseMoreApps
{
    [self dispatchEvent:kCDVTDCallbackDidClose withPlacementTag:TDPTagDefault forAdTypeString:kCDVTDAdTypeMoreApps];
}

#pragma mark Logging

- (void)log:(NSString *)msg
{
    NSString *tag = @"[Tapdaq Cordova Plugin]";
    NSLog(@"%@ [DEBUG] %@", tag, msg);
}

- (void)error:(NSString *)msg
{
    NSString *tag = @"[Tapdaq Cordova Plugin]";
    NSLog(@"%@ [ERROR] %@", tag, msg);
}

#pragma mark Native delegate methods

- (void)didLoadNativeAdvertForPlacementTag:(NSString *)tag adType:(TDNativeAdType)nativeAdType
{
    TDNativeAdvert *nativeAd =  [[Tapdaq sharedSession] getNativeAdvertForPlacementTag:tag
                                                                                adType:nativeAdType];
    NSDictionary *dict = [self convertNativeAd:nativeAd
                                        forTag:tag];
    if(dict != nil){
        [self dispatchEvent:kCDVTDCallbackDidLoad
                   withData:dict];
    }
}

- (void)didFailToLoadNativeAdvertForPlacementTag:(NSString *)tag adType:(TDNativeAdType)nativeAdType
{
    NSString *nativeAdTypeString = [self getStringFromAdType:nativeAdType];
    
    [self dispatchEvent:kCDVTDCallbackDidFailToLoad
       withPlacementTag:tag
        forAdTypeString:nativeAdTypeString];
}

- (NSDictionary *)convertNativeAd:(TDNativeAdvert *)nativeAd forTag:(NSString *)tag
{
    if (!nativeAd) {
        return nil;
    }
    
    NSData *imageData;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *iconPath = [documentsDirectory stringByAppendingPathComponent:@"iconSelected2.png"]; //Add the file name
    
    if ([nativeAd.creative isKindOfClass:[TDImageCreative class]]) {
        TDImageCreative *creative = (TDImageCreative *) nativeAd.creative;
        imageData = UIImagePNGRepresentation(creative.image);
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"selected2.png"]; //Add the file name
        [imageData writeToFile:filePath atomically:YES];
    } else {
        imageData = UIImagePNGRepresentation(nativeAd.icon);
        [imageData writeToFile:iconPath atomically:YES];
    }
    
    NSString *uniqueId = [NSString stringWithFormat:@"%@-%@", [self getStringFromAdType:nativeAd.adType], nativeAd.subscriptionId];
    
    NSDictionary *dict = @{
                           @"adType": [self getStringFromAdType:nativeAd.adType],
                           @"tag": tag,
                           @"applicationId": nativeAd.applicationId,
                           @"targetingId": nativeAd.targetingId,
                           @"subscriptionId": nativeAd.subscriptionId,
                           @"appName": nativeAd.appName,
                           @"description": nativeAd.appDescription,
                           @"buttonText": nativeAd.buttonText,
                           @"developerName": nativeAd.developerName,
                           @"ageRating": nativeAd.ageRating,
                           @"appSize": @(nativeAd.appSize),
                           @"averageReview": @(nativeAd.averageReview),
                           @"totalReviews": @(nativeAd.totalReviews),
                           @"category": nativeAd.category,
                           @"appVersion": nativeAd.appVersion,
                           @"price": @(nativeAd.price),
                           @"iconUrl": [nativeAd.iconUrl absoluteString],
                           @"iconPath": iconPath,
                           @"creativeIdentifier": nativeAd.creative.identifier,
                           @"imageUrl": [nativeAd.creative.url absoluteString],
                           @"uniqueId": uniqueId
                           };
    
    [self.nativeAds setObject:nativeAd
                       forKey:uniqueId];
    
    return dict;
}

@end

