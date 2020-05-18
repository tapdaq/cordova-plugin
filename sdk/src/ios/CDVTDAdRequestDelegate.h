#import <Tapdaq/Tapdaq.h>
#import <Foundation/Foundation.h>
#import "CDVTDDelegateBase.h"

extern NSNotificationName const CDVTDAdRequestDelegateRemoveAdRequestNotification;
extern NSString *const CDVTDAdRequestDelegateDelegateKey;

@interface CDVTDAdRequestDelegate : CDVTDDelegateBase <TDAdRequestDelegate, TDBannerAdRequestDelegate, TDInterstitialAdRequestDelegate, TDRewardedVideoAdRequestDelegate, TDBannerAdRequestDelegate>
@end
