#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>
#import <Foundation/Foundation.h>

@interface CDVTapdaq : CDVPlugin

- (void)init:(CDVInvokedUrlCommand *)command;

- (void)launchDebugger:(CDVInvokedUrlCommand *)command;

- (void)load:(CDVInvokedUrlCommand *)command;

- (void)isReady:(CDVInvokedUrlCommand *)command;

- (void)getFrequencyCapError:(CDVInvokedUrlCommand *)command;

- (void)show:(CDVInvokedUrlCommand *)command;

- (void)hide:(CDVInvokedUrlCommand *)command;

- (void)destroy:(CDVInvokedUrlCommand *)command;

- (void)userSubjectToGDPRStatus:(CDVInvokedUrlCommand *)command;

- (void)setUserSubjectToGDPR:(CDVInvokedUrlCommand *)command;

- (void)consentStatus:(CDVInvokedUrlCommand *)command;

- (void)setConsent:(CDVInvokedUrlCommand *)command;

- (void)ageRestrictedUserStatus:(CDVInvokedUrlCommand *)command;

- (void)setAgeRestrictedUser:(CDVInvokedUrlCommand *)command;

- (void)userSubjectToUSPrivacyStatus:(CDVInvokedUrlCommand *)command;

- (void)setUserSubjectToUSPrivacy:(CDVInvokedUrlCommand *)command;

- (void)usPrivacyStatus:(CDVInvokedUrlCommand *)command;

- (void)setUSPrivacy:(CDVInvokedUrlCommand *)command;

- (void)adMobContentRating:(CDVInvokedUrlCommand *)command;

- (void)setAdMobContentRating:(CDVInvokedUrlCommand *)command;

- (void)forwardUserId:(CDVInvokedUrlCommand *)command;

- (void)setForwardUserId:(CDVInvokedUrlCommand *)command;

- (void)userId:(CDVInvokedUrlCommand *)command;

- (void)setUserId:(CDVInvokedUrlCommand *)command;

- (void)muted:(CDVInvokedUrlCommand *)command;

- (void)setMuted:(CDVInvokedUrlCommand *)command;

- (void)setUserDataString:(CDVInvokedUrlCommand *)command;

- (void)setUserDataBoolean:(CDVInvokedUrlCommand *)command;

- (void)setUserDataInteger:(CDVInvokedUrlCommand *)command;

- (void)userDataString:(CDVInvokedUrlCommand *)command;

- (void)userDataBoolean:(CDVInvokedUrlCommand *)command;

- (void)userDataInteger:(CDVInvokedUrlCommand *)command;

- (void)allUserData:(CDVInvokedUrlCommand *)command;

- (void)removeUserData:(CDVInvokedUrlCommand *)command;

- (void)rewardId:(CDVInvokedUrlCommand *)command;

- (void)networkStatuses:(CDVInvokedUrlCommand *)command;

- (void)setLogLevel:(CDVInvokedUrlCommand *)command;

@end
