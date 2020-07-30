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

- (void)getFrequencyCapError:(CDVInvokedUrlCommand *)command
{
    TDAdUnit adUnit = [command td_getArgumentAdUnit];

    NSString *placementTag = [command td_getArgumentPlacementTag];

    __block TDError* error;
    [self.commandDelegate runInBackground:^{
        if (adUnit == TDUnitStaticInterstitial) {
            error = [self.tapdaq interstitialCappedForPlacementTag:placementTag];
        } else if (adUnit == TDUnitVideoInterstitial) {
            error = [self.tapdaq videoCappedForPlacementTag:placementTag];
        } else if (adUnit == TDUnitRewardedVideo) {
            error = [self.tapdaq rewardedVideoCappedForPlacementTag:placementTag];
        }

        NSDictionary* errorDict;
        if(error != nil) {
            errorDict = @{
                @"code": @(error.code),
                @"message": (error.localizedDescription == nil ? @"" : error.localizedDescription)
            };
        } else {
            errorDict = @{};
        }


        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                messageAsDictionary:errorDict];
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
    __block TDPrivacyStatus subjectToGDPR;
    [self.commandDelegate runInBackground:^{
        subjectToGDPR = [self.tapdaq.properties.privacySettings userSubjectToGdpr];

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
    TDPrivacyStatus userSubjectToGDPR = (TDPrivacyStatus) [userSubjectToGDPRStatusNum integerValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties.privacySettings setUserSubjectToGdpr:userSubjectToGDPR];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)consentStatus:(CDVInvokedUrlCommand *)command
{
    __block TDPrivacyStatus isConsentGiven;
    [self.commandDelegate runInBackground:^{
        isConsentGiven = [self.tapdaq.properties.privacySettings gdprConsentGiven];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                       messageAsNSInteger: isConsentGiven];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setConsent:(CDVInvokedUrlCommand *)command
{
    NSNumber *consentStatusNum = (NSNumber *) command.arguments.firstObject;
    TDPrivacyStatus isConsentGiven = [consentStatusNum integerValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties.privacySettings setGdprConsentGiven:isConsentGiven];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)ageRestrictedUserStatus:(CDVInvokedUrlCommand *)command
{
    __block TDPrivacyStatus isAgeRestrictedUser;
    [self.commandDelegate runInBackground:^{
        isAgeRestrictedUser = [self.tapdaq.properties.privacySettings ageRestrictedUser];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsNSInteger:isAgeRestrictedUser];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setAgeRestrictedUser:(CDVInvokedUrlCommand *)command
{
    NSNumber *ageRestrictedUserStatusNum = (NSNumber *) command.arguments.firstObject;
    TDPrivacyStatus isAgeRestrictedUser = [ageRestrictedUserStatusNum integerValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties.privacySettings setAgeRestrictedUser:isAgeRestrictedUser];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)userSubjectToUSPrivacyStatus:(CDVInvokedUrlCommand *)command
{
    __block TDPrivacyStatus status;
    [self.commandDelegate runInBackground:^{
        status = [self.tapdaq.properties.privacySettings userSubjectToUSPrivacy];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                            messageAsNSInteger:status];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setUserSubjectToUSPrivacy:(CDVInvokedUrlCommand *)command
{
    NSNumber *statusNum = (NSNumber *) command.arguments.firstObject;
    TDPrivacyStatus status = (TDPrivacyStatus) [statusNum integerValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties.privacySettings setUserSubjectToUSPrivacy:status];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)usPrivacyStatus:(CDVInvokedUrlCommand *)command
{
    __block TDPrivacyStatus status;
        [self.commandDelegate runInBackground:^{
        status = [self.tapdaq.properties.privacySettings usPrivacyDoNotSell];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                            messageAsNSInteger:status];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setUSPrivacy:(CDVInvokedUrlCommand *)command
{
    NSNumber *statusNum = (NSNumber *) command.arguments.firstObject;
    TDPrivacyStatus status = (TDPrivacyStatus) [statusNum integerValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties.privacySettings setUsPrivacyDoNotSell:status];
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


- (void)muted:(CDVInvokedUrlCommand *)command
{
    __block BOOL muted;
    [self.commandDelegate runInBackground:^{
        muted = [self.tapdaq.properties isMuted];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                           messageAsBool:muted];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                        callbackId:command.callbackId];
    }];
}

- (void)setMuted:(CDVInvokedUrlCommand *)command
{
    NSNumber *mutedNum = (NSNumber *) command.arguments.firstObject;

    BOOL muted = [mutedNum boolValue];

    [self.commandDelegate runInBackground:^{
        [self.tapdaq.properties setMuted:muted];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)setUserDataString:(CDVInvokedUrlCommand *)command
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    NSString *value = (NSString *) [command.arguments objectAtIndex:1];

    [self.commandDelegate runInBackground:^{
        [[self.tapdaq properties] setUserDataString:value forKey:key];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)setUserDataBoolean:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    NSNumber *valueNum = (NSNumber *) [command.arguments objectAtIndex:1];
    BOOL value = (BOOL) [valueNum boolValue];

    [self.commandDelegate runInBackground:^{
        [[self.tapdaq properties] setUserDataBool:value forKey:key];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)setUserDataInteger:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    NSNumber *value = (NSNumber *) [command.arguments objectAtIndex:1];

    [self.commandDelegate runInBackground:^{
        [[self.tapdaq properties] setUserDataInteger:[value intValue] forKey:key];
    }];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:command.callbackId];
}

- (void)userDataString:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    __block NSString *value;

    [self.commandDelegate runInBackground:^{
        value = [[self.tapdaq properties] userDataStringForKey:key];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsString:value];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)userDataBoolean:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    __block BOOL value;

    [self.commandDelegate runInBackground:^{
        value = [[self.tapdaq properties] userDataBoolForKey:key];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsBool:value];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)userDataInteger:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];
    __block NSInteger value;

    [self.commandDelegate runInBackground:^{
        value = [[self.tapdaq properties] userDataIntegerForKey:key];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsNSInteger:value];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)allUserData:(CDVInvokedUrlCommand *)command;
{
    __block NSDictionary *value;

    [self.commandDelegate runInBackground:^{
        value = [[[Tapdaq sharedSession] properties] userData];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsDictionary:value];
        [pluginResult setKeepCallbackAsBool:YES];
        [self.commandDelegate sendPluginResult:pluginResult
                                            callbackId:command.callbackId];
    }];
}

- (void)removeUserData:(CDVInvokedUrlCommand *)command;
{
    NSString *key = (NSString *) [command.arguments objectAtIndex:0];

    [self.commandDelegate runInBackground:^{
        [[self.tapdaq properties] removeUserDataForKey:key];
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

- (void)networkStatuses:(CDVInvokedUrlCommand *)command
{
    __block NSArray *value;

    [self.commandDelegate runInBackground:^{
        value = [self.tapdaq networkStatusesDictionary];

        CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                                  messageAsArray:value];
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
        [TDLogger setLogLevel:logLevel];
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
    [TDLogger setLogLevel:[self logLevelFromString:[command td_getArgumentLogLevel]]];

    // User ID
    NSString *userId = [command td_getArgumentUserId];
    if (userId) {
        [properties setUserId:userId];
    }

    // Forward user ID
    NSNumber *forwardUserId = [command td_getArgumentForwardUserId];
    if (forwardUserId != nil) {
        [properties setForwardUserId:[forwardUserId boolValue]];
    }

    // Muted
    NSNumber *muted = [command td_getArgumentMuted];
    if (muted != nil) {
        [properties setMuted:[muted boolValue]];
    }

    // User Subject to GDPR
    NSNumber *userSubjectToGDPRNumber = [command td_getArgumentSubjectToGdpr];
    if (userSubjectToGDPRNumber != nil) {
        [properties.privacySettings setUserSubjectToGdpr:(TDPrivacyStatus) [userSubjectToGDPRNumber integerValue]];
    }

    // Consent
    NSNumber *consentGivenNumber = [command td_getArgumentConsentGiven];
    if (consentGivenNumber != nil) {
        [properties.privacySettings setGdprConsentGiven:(TDPrivacyStatus)[consentGivenNumber integerValue]];
    }

    // Age restricted user
    NSNumber *ageRestrictedUserNumber = [command td_getArgumentAgeRestrictedUser];
    if (ageRestrictedUserNumber != nil) {
        [properties.privacySettings setAgeRestrictedUser:(TDPrivacyStatus)[ageRestrictedUserNumber integerValue]];
    }

    // User Subject to USPrivacy
    NSNumber *userSubjectToUSPrivacyNumber = [command td_getArgumentSubjectToUSPrivacy];
    if (userSubjectToUSPrivacyNumber != nil) {
        [properties.privacySettings setUserSubjectToUSPrivacy:(TDPrivacyStatus) [userSubjectToUSPrivacyNumber integerValue]];
    }

    // USPrivacy
    NSNumber *usPrivacyNumber = [command td_getArgumentUSPrivacy];
    if (usPrivacyNumber != nil) {
        [properties.privacySettings setUsPrivacyDoNotSell:(TDPrivacyStatus) [usPrivacyNumber integerValue]];
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

