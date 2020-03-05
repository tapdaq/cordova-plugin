#import "CDVTapdaq.h"
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Tapdaq/Tapdaq+PluginSupport.h>
#import "CDVTapdaqDelegate.h"
#import "CDVTDAdRequestDelegate.h"
#import "CDVInvokedUrlCommand+tapdaq.h"

static NSString *const kCDVTDPropertiesLogLevelValueDebug = @"debug";
static NSString *const kCDVTDPropertiesLogLevelValueInfo = @"info";
static NSString *const kCDVTDPropertiesLogLevelValueWarning = @"warning";
static NSString *const kCDVTDPropertiesLogLevelValueError = @"error";

@interface CDVTapdaq()
@property (nonatomic, strong) Tapdaq *tapdaq;
@property (nonatomic, strong) CDVTapdaqDelegate* tapdaqDelegate;
@property (nonatomic, strong) NSMutableDictionary<NSString *, CDVTDAdRequestDelegate*> *adRequests;

@end

@implementation CDVTapdaq

- (void)pluginInitialize
{
    [super pluginInitialize];
    
    self.tapdaq = [Tapdaq sharedSession];
    self.adRequests = [NSMutableDictionary new];
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(removeAdRequestNotification:)
                                               name:CDVTDAdRequestDelegateRemoveAdRequestNotification
                                             object:nil];
}

/**
 Init the plugin.
 Waits until either didInitialise or didFailToInitialise is called
 */
- (void)init:(CDVInvokedUrlCommand *)command
{
    TDProperties *properties = [self generatePropertiesGivenCommand:command];

    // App ID
    NSString *appId = [command td_getArgumentAppId];

    // Client Key
    NSString *clientKey = [command td_getArgumentClientKey];
    
    @try {
        [self.commandDelegate runInBackground:^{
            [self setTapdaqDelegate:[[CDVTapdaqDelegate alloc] initWithCommand:command usingDelegate:self.commandDelegate]];
            [self.tapdaq setDelegate:[self tapdaqDelegate]];
            [self.tapdaq setApplicationId:appId
                                clientKey:clientKey
                               properties:properties];
        }];
    } @catch (NSException *exception) {
        // TODO handle exception?
    }

}

- (CDVTDAdRequestDelegate*) generateAdRequestDelegateWithCommand:(CDVInvokedUrlCommand*)command shouldStore:(BOOL)shouldStore
{
    if (command.callbackId == nil) { return nil; }
    CDVTDAdRequestDelegate* adRequestDelegate = [[CDVTDAdRequestDelegate alloc] initWithCommand:command usingDelegate:self.commandDelegate];
    if (shouldStore) {
        @synchronized (self.adRequests) { self.adRequests[command.callbackId] = adRequestDelegate; };
    }
    return adRequestDelegate;
}

- (void)launchDebugger:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.tapdaq presentDebugViewController];
        }];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)removeAdRequestNotification:(NSNotification *)notification {
     CDVTDAdRequestDelegate *adRequestDelegate = notification.userInfo[CDVTDAdRequestDelegateDelegateKey];
    [self removeAdRequestDelegate:adRequestDelegate];
}

- (void)removeAdRequestDelegate:(CDVTDAdRequestDelegate *)adRequestDelegate {
    NSArray* keys = [self.adRequests allKeysForObject:adRequestDelegate];
    NSString *key = [keys firstObject];
    if (key != nil) {
         @synchronized (self.adRequests) { self.adRequests[key] = nil; }
    }
}

- (void)load:(CDVInvokedUrlCommand *)command
{
    TDAdUnit adUnit = [command td_getArgumentAdUnit];

    NSString *placementTag = [command td_getArgumentPlacementTag];

    CDVTDAdRequestDelegate* adRequestDelegate = [self generateAdRequestDelegateWithCommand:command shouldStore:YES];

    if (adUnit == TDUnitStaticInterstitial) {
        [self.commandDelegate runInBackground:^{
            [self.tapdaq loadInterstitialForPlacementTag:placementTag delegate:adRequestDelegate];
        }];
    } else if (adUnit == TDUnitVideoInterstitial) {
        [self.commandDelegate runInBackground:^{
            [self.tapdaq loadVideoForPlacementTag:placementTag delegate:adRequestDelegate];
        }];
    } else if (adUnit == TDUnitRewardedVideo) {
        [self.commandDelegate runInBackground:^{
            [self.tapdaq loadRewardedVideoForPlacementTag:placementTag delegate:adRequestDelegate];
        }];
    } else if (adUnit == TDUnitBanner) {

        TDMBannerSize bannerSize = [command td_getArgumentBannerSize];
        if (bannerSize == TDMBannerCustom) {
            CGSize targetBannerSize = CGSizeMake([command td_getArgumentBannerWidth], [command td_getArgumentBannerHeight]);
            [self.commandDelegate runInBackground:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.tapdaq loadPluginBannerForPlacementTag:placementTag
                                                  withTargetSize:targetBannerSize
                                                        delegate:adRequestDelegate];
                }];
            }];

        } else {
            [self.commandDelegate runInBackground:^{
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self.tapdaq loadPluginBannerForPlacementTag:placementTag
                                                        withSize:bannerSize
                                                        delegate:adRequestDelegate];
                }];
            }];
        }

    }
}

- (void)isReady:(CDVInvokedUrlCommand *)command
{
    TDAdUnit adUnit = [command td_getArgumentAdUnit];

    NSString *placementTag = [command td_getArgumentPlacementTag];

    __block BOOL isReady;
    [self.commandDelegate runInBackground:^{
        if (adUnit == TDUnitStaticInterstitial) {
            isReady = [self.tapdaq isInterstitialReadyForPlacementTag:placementTag];
        } else if (adUnit == TDUnitVideoInterstitial) {
            isReady = [self.tapdaq isVideoReadyForPlacementTag:placementTag];
        } else if (adUnit == TDUnitRewardedVideo) {
            isReady = [self.tapdaq isRewardedVideoReadyForPlacementTag:placementTag];
        } else if (adUnit == TDUnitBanner) {
            isReady = [self.tapdaq isBannerReadyBannerForPlacementTag:placementTag];
        }

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                messageAsBool:isReady];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)show:(CDVInvokedUrlCommand*)command
{
    TDAdUnit adUnit = [command td_getArgumentAdUnit];

    NSString *placementTag = [command td_getArgumentPlacementTag];

    CDVTDAdRequestDelegate* adRequestDelegate = [self generateAdRequestDelegateWithCommand:command shouldStore:adUnit != TDUnitBanner];

    if (adUnit == TDUnitStaticInterstitial) {
        [self.commandDelegate runInBackground:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tapdaq showInterstitialForPlacementTag:placementTag delegate:adRequestDelegate];
            }];
        }];
    } else if (adUnit == TDUnitVideoInterstitial) {
        [self.commandDelegate runInBackground:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tapdaq showVideoForPlacementTag:placementTag delegate:adRequestDelegate];
            }];
        }];
    } else if (adUnit == TDUnitRewardedVideo) {
        [self.commandDelegate runInBackground:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tapdaq showRewardedVideoForPlacementTag:placementTag delegate:adRequestDelegate];
            }];
        }];
    } else if (adUnit == TDUnitBanner) {
        TDBannerPositionType positionType = [command td_getArgumentBannerPosition];

        TDBannerPosition position;
        if (positionType == TDBannerPositionTypeCustom) {
            CGPoint location = CGPointMake([command td_getArgumentBannerX], [command td_getArgumentBannerY]);
            position = TDBannerPositionMakeCustom(location);
        } else {
            position = TDBannerPositionMake(positionType);
        }

        [self.commandDelegate runInBackground:^{
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.tapdaq showBannerForPlacementTag:placementTag
                                            atPosition:position
                                                inView:self.webView];
            }];
        }];
    }
}

- (void)hide:(CDVInvokedUrlCommand *)command
{
    NSString *placementTag = [command td_getArgumentPlacementTag];

    [self.tapdaq hideBannerForPlacementTag:placementTag];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)destroy:(CDVInvokedUrlCommand *)command
{
    NSString *placementTag = [command td_getArgumentPlacementTag];
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [[(CDVTDAdRequestDelegate *)evaluatedObject command] td_getArgumentAdUnit] == [command td_getArgumentAdUnit] && [[[(CDVTDAdRequestDelegate *)evaluatedObject command] td_getArgumentPlacementTag] isEqualToString:[command td_getArgumentPlacementTag]];
    }];
    [self removeAdRequestDelegate:[self.adRequests.allValues filteredArrayUsingPredicate:predicate].firstObject];
    [self.tapdaq destroyBannerForPlacementTag:placementTag];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)userSubjectToGDPRStatus:(CDVInvokedUrlCommand *)command
{
    __block TDSubjectToGDPR subjectToGDPR;
    [self.commandDelegate runInBackground:^{
        subjectToGDPR = [self.tapdaq userSubjectToGDPR];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                            messageAsNSInteger:subjectToGDPR];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setUserSubjectToGDPR:(CDVInvokedUrlCommand *)command
{
    NSNumber *userSubjectToGDPRStatusNum = (NSNumber *) command.arguments.firstObject;
    TDSubjectToGDPR userSubjectToGDPR = (TDSubjectToGDPR) [userSubjectToGDPRStatusNum integerValue];
    
    [self.commandDelegate runInBackground:^{
        [self.tapdaq setUserSubjectToGDPR:userSubjectToGDPR];
    }];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)consentStatus:(CDVInvokedUrlCommand *)command
{
    __block BOOL isConsentGiven;
    [self.commandDelegate runInBackground:^{
        isConsentGiven = [self.tapdaq isConsentGiven];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsNSInteger:(NSInteger) isConsentGiven];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setConsent:(CDVInvokedUrlCommand *)command
{
    NSNumber *consentStatusNum = (NSNumber *) command.arguments.firstObject;
    BOOL isConsentGiven = [consentStatusNum integerValue] == 1;
    
    [self.commandDelegate runInBackground:^{
        [self.tapdaq setIsConsentGiven:isConsentGiven];
    }];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)ageRestrictedUserStatus:(CDVInvokedUrlCommand *)command
{
    __block BOOL isAgeRestrictedUser;
    [self.commandDelegate runInBackground:^{
        isAgeRestrictedUser = [self.tapdaq isAgeRestrictedUser];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsNSInteger:(NSInteger) isAgeRestrictedUser];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setAgeRestrictedUser:(CDVInvokedUrlCommand *)command
{
    NSNumber *ageRestrictedUserStatusNum = (NSNumber *) command.arguments.firstObject;
    BOOL isAgeRestrictedUser = [ageRestrictedUserStatusNum integerValue] == 1;
    
    [self.commandDelegate runInBackground:^{
        [self.tapdaq setIsAgeRestrictedUser:isAgeRestrictedUser];
    }];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)adMobContentRating:(CDVInvokedUrlCommand *)command
{
    __block NSString *adMobContentRating;

    [self.commandDelegate runInBackground:^{
        adMobContentRating = [self.tapdaq adMobContentRating];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsString:adMobContentRating];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)setAdMobContentRating:(CDVInvokedUrlCommand *)command
{
    NSString *adMobContentRating = (NSString *) command.arguments.firstObject;
    [self.commandDelegate runInBackground:^{
        [self.tapdaq setAdMobContentRating:adMobContentRating];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}


- (void)forwardUserId:(CDVInvokedUrlCommand *)command
{
    __block BOOL forwardUserId;
    [self.commandDelegate runInBackground:^{
        forwardUserId = [self.tapdaq forwardUserId];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsBool:forwardUserId];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setForwardUserId:(CDVInvokedUrlCommand *)command
{
    NSNumber *forwardUserIdNum = (NSNumber *) command.arguments.firstObject;

    BOOL forwardUserId = [forwardUserIdNum boolValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq setForwardUserId:forwardUserId];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)userId:(CDVInvokedUrlCommand *)command
{
    __block NSString *userId;

    [self.commandDelegate runInBackground:^{
        userId = [self.tapdaq userId];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsString:userId];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)setUserId:(CDVInvokedUrlCommand *)command
{
    NSString *userId = (NSString *) command.arguments.firstObject;
    [self.commandDelegate runInBackground:^{
        [self.tapdaq setUserId:userId];
    }];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)rewardId:(CDVInvokedUrlCommand *)command
{
    NSString *placementTag = (NSString *) command.arguments.firstObject;
    __block NSString *rewardId;
    
    [self.commandDelegate runInBackground:^{
        rewardId = [self.tapdaq rewardIdForPlacementTag:placementTag];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                              messageAsString:rewardId];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setLogLevel:(CDVInvokedUrlCommand *)command
{
    NSString *logLevelString = (NSString *) command.arguments.firstObject;

    TDLogLevel logLevel = [self logLevelFromString:logLevelString];
    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties setLogLevel:logLevel];
    }];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

#pragma mark - Private methods

- (TDProperties *)generatePropertiesGivenCommand:(CDVInvokedUrlCommand *)command
{
    TDProperties *properties = [self.tapdaq properties];
    
    // Plugin version
    NSString *pluginVersion = [command td_getArgumentPluginVersion];
    if (pluginVersion) {
        [properties setPluginVersion:pluginVersion];
    }
    
    // Log Level
    [properties setLogLevel:[self logLevelFromString:[command td_getArgumentLogLevel]]];
    
    // User ID
    NSString *userId = [command td_getArgumentUserId];
    if (userId) {
        [properties setUserId:userId];
    }
    
    // Forward user ID
    BOOL forwardUserId = [command td_getArgumentForwardUserId];
    if (forwardUserId) {
        [properties setForwardUserId:forwardUserId];
    }
    
    // User Subject to GDPR
    NSNumber *userSubjectToGDPRNumber = [command td_getArgumentSubjectToGdpr];
    if (userSubjectToGDPRNumber != nil) {
        [properties setUserSubjectToGDPR:(TDSubjectToGDPR) [userSubjectToGDPRNumber integerValue]];
    }
    
    // Consent
    NSNumber *consentGivenNumber = [command td_getArgumentConsentGiven];
    if (consentGivenNumber != nil) {
        [properties setIsConsentGiven:[consentGivenNumber integerValue] == 1];
    }
    
    // Age restricted user
    NSNumber *ageRestrictedUserNumber = [command td_getArgumentAgeRestrictedUser];
    if (ageRestrictedUserNumber != nil) {
        [properties setIsAgeRestrictedUser:[ageRestrictedUserNumber integerValue] == 1];
    }
    
    // AdMob Content Rating
    NSString *adMobContentRating = [command td_getArgumentAdMobContentRating];
    if (adMobContentRating != nil) {
        [properties setAdMobContentRating:adMobContentRating];
    }
    
    // Test Devices
    NSArray<TDTestDevices *> *testDevices = [command td_getArgumentTestDevices];
    for (TDTestDevices *device in testDevices) {
        [properties registerTestDevices:device];
    }
    
    return properties;
}

- (TDLogLevel)logLevelFromString:(NSString *)logLevelString {
    TDLogLevel logLevel = TDLogLevelDisabled;

    if ([logLevelString isEqualToString:kCDVTDPropertiesLogLevelValueInfo]) {
        logLevel = TDLogLevelInfo;
    } else if ([logLevelString isEqualToString:kCDVTDPropertiesLogLevelValueWarning]) {
        logLevel = TDLogLevelWarning;
    } else if ([logLevelString isEqualToString:kCDVTDPropertiesLogLevelValueError]) {
        logLevel = TDLogLevelError;
    } else if ([logLevelString isEqualToString:kCDVTDPropertiesLogLevelValueDebug]) {
        logLevel = TDLogLevelDebug;
    }

    return logLevel;
}
@end

