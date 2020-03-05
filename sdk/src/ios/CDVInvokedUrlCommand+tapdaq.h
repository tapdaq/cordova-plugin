#import <Foundation/Foundation.h>
#import <Tapdaq/Tapdaq.h>
#import <Cordova/CDV.h>

@interface CDVInvokedUrlCommand (tapdaq)
// If class is nil the method will return and object fo any class.
- (id)td_getArgumentWithKey:(NSString *)key ofClass:(Class)class;
// Calls -td_getArgumentWithKey:ofClass: with class being nil.
- (id)td_getArgumentWithKey:(NSString *)key;

// Config
- (NSString *)td_getArgumentAppId;
- (NSString *)td_getArgumentClientKey;
- (NSArray <TDTestDevices *>*)td_getArgumentTestDevices;

- (NSString *)td_getArgumentLogLevel;

- (NSString *)td_getArgumentPluginVersion;
- (NSString *)td_getArgumentUserId;
- (BOOL)td_getArgumentForwardUserId;

// Privacy
- (NSString *)td_getArgumentAdMobContentRating;
// Returning these as NSNumber instead of basic types to know whether these settings were set.
- (NSNumber *)td_getArgumentConsentGiven;
- (NSNumber *)td_getArgumentSubjectToGdpr;
- (NSNumber *)td_getArgumentAgeRestrictedUser;


// Ads
- (NSString *)td_getArgumentPlacementTag;
- (TDAdUnit)td_getArgumentAdUnit;

- (CGFloat)td_getArgumentBannerWidth;
- (CGFloat)td_getArgumentBannerHeight;
- (TDMBannerSize)td_getArgumentBannerSize;
- (TDBannerPositionType)td_getArgumentBannerPosition;
- (CGFloat)td_getArgumentBannerX;
- (CGFloat)td_getArgumentBannerY;
@end