#import "CDVTDAdRequestDelegate.h"
#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

static NSString *const kCDVTDCallbackDidLoad = @"didLoad";
static NSString *const kCDVTDCallbackDidFailToLoad = @"didFailToLoad";
static NSString *const kCDVTDCallbackDidClick = @"didClick";
static NSString *const kCDVTDCallbackDidRefresh = @"didRefresh";
static NSString *const kCDVTDCallbackDidFailToRefresh = @"didFailToRefresh";
static NSString *const kCDVTDCallbackWillDisplay = @"willDisplay";
static NSString *const kCDVTDCallbackDidDisplay = @"didDisplay";
static NSString *const kCDVTDCallbackDidFailToDisplay = @"didFailToDisplay";
static NSString *const kCDVTDCallbackDidClose = @"didClose";
static NSString *const kCDVTDCallbackDidValidateReward = @"didValidateReward";

NSNotificationName const CDVTDAdRequestDelegateRemoveAdRequestNotification = @"CDVTDAdRequestDelegateRemoveAdRequestNotification";
NSString *const CDVTDAdRequestDelegateDelegateKey = @"CDVTDAdRequestDelegateDelegateKey";

@implementation CDVTDAdRequestDelegate
#pragma mark - TDAdRequestDelegate

- (void)postRemoveAdRequestNotification {
    NSMutableDictionary *userInfo = NSMutableDictionary.dictionary;
    userInfo[CDVTDAdRequestDelegateDelegateKey] = self;
    [NSNotificationCenter.defaultCenter postNotificationName:CDVTDAdRequestDelegateRemoveAdRequestNotification
                                                      object:self
                                                    userInfo:userInfo];
}

- (void)didLoadAdRequest:(TDAdRequest *)adRequest
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidLoad
                                              adRequest:adRequest];

    if (adRequest.placement.adUnit != TDUnitBanner) {
        [self postRemoveAdRequestNotification];
    }
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToLoadWithError:(TDError *)error
{
    NSDictionary *dict = [self dictionaryForTDError:error
                                          eventName:kCDVTDCallbackDidFailToLoad
                                          adRequest:adRequest];
    [self postRemoveAdRequestNotification];
    [self sendCallbackErrorGivenDict:dict];
}

#pragma mark - TDDisplayableAdRequestDelegate

- (void)willDisplayAdRequest:(TDAdRequest *)adRequest
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackWillDisplay
                                              adRequest:adRequest];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)didDisplayAdRequest:(TDAdRequest *)adRequest
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidDisplay
                                              adRequest:adRequest];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToDisplayWithError:(TDError *)error
{
    NSDictionary *dict = [self dictionaryForTDError:error
                                          eventName:kCDVTDCallbackDidFailToDisplay
                                          adRequest:adRequest];

    [self postRemoveAdRequestNotification];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)didCloseAdRequest:(TDAdRequest * _Nonnull)adRequest
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidClose
                                              adRequest:adRequest];
    [self postRemoveAdRequestNotification];
    [self sendCallbackSuccessGivenDict:dict];
}

#pragma mark - TDClickableAdRequestDelegate

- (void)didClickAdRequest:(TDAdRequest * _Nonnull)adRequest;
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidClick
                                              adRequest:adRequest];
    [self sendCallbackSuccessGivenDict:dict];
}

#pragma mark - TDRewardedVideoAdRequestDelegate

// todo DRY
- (void)adRequest:(TDAdRequest *)adRequest didValidateReward:(TDReward *)reward
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidValidateReward
                                              adRequest:adRequest
                                                 reward:reward];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)adRequest:(TDAdRequest *)adRequest didFailToValidateReward:(TDReward *)reward
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidValidateReward
                                              adRequest:adRequest
                                                 reward:reward];
    [self sendCallbackSuccessGivenDict:dict];
}

#pragma mark - TDBannerDelegate

- (void)didRefreshBannerForAdRequest:(TDBannerAdRequest * _Nonnull)adRequest
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidRefresh
                                              adRequest:adRequest];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)didFailToRefreshBannerForAdRequest:(TDBannerAdRequest * _Nonnull)adRequest
                                 withError:(TDError * _Nullable)error
{
    NSDictionary *dict = [self dictionaryForTDError:error
                                          eventName:kCDVTDCallbackDidFailToRefresh
                                          adRequest:adRequest];
    [self sendCallbackErrorGivenDict:dict];
}
@end