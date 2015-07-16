//
//  Tapdaq.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDOrientationEnum.h"
#import "TDNativeAdUnitEnum.h"
#import "TDNativeAdSizeEnum.h"

@protocol TapdaqDelegate;

@class TDAdvert;
@class TDNativeAdvert;
@class TDInterstitialAdvert;

@interface Tapdaq : NSObject

@property (nonatomic, weak) id <TapdaqDelegate> delegate;

// The singleton Tapdaq object, use this for all method calls
+ (instancetype)sharedSession;

// A setter for the Application ID of your app, and the Client Key associated with your Tapdaq account
- (void)setApplicationId:(NSString *)applicationId
               clientKey:(NSString *)clientKey;

- (void)setApplicationId:(NSString *)applicationId
               clientKey:(NSString *)clientKey
             orientation:(TDOrientation)orientation;

- (void)setApplicationId:(NSString *)applicationId
               clientKey:(NSString *)clientKey
                  config:(NSDictionary *)config;

- (TDInterstitialAdvert *)getInterstitialAdvert;

- (TDInterstitialAdvert *)getInterstitialAdvertForOrientation:(TDOrientation)orientation;

- (void)loadInterstitialAdvertForOrientation:(TDOrientation)orientation;

// Gets a native advert - expects config defaults to be set
- (TDNativeAdvert *)getNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                                        size:(TDNativeAdSize)adSize;

- (TDNativeAdvert *)getNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                                        size:(TDNativeAdSize)adSize
                                 orientation:(TDOrientation)orientation;

- (void)loadNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                             size:(TDNativeAdSize)adSize
                      orientation:(TDOrientation)orientation;

/** 
 Displays an interstitial to the user, if an interstitial is available to be shown. This method will time out gracefully (ie. no exception thrown) after 3 seconds if no advert is presented to the user in that time.
 */
- (void)showInterstitial;

- (void)showInterstitial:(UIView *)view;

- (void)triggerImpression:(TDAdvert *)advert;
- (void)sendImpression:(TDAdvert *)advert;

- (void)triggerClick:(TDAdvert *)advert;
- (void)sendClick:(TDAdvert *)advert;

- (void)launch;

@end

@protocol TapdaqDelegate <NSObject>

@optional

// Called before interstitial is shown
- (void)willDisplayInterstitial;

// Called after interstitial is shown
- (void)didDisplayInterstitial;

// Called when interstitial is closed
- (void)didCloseInterstitial;

// Called when interstitial is clicked
- (void)didClickInterstitial;

// Called with an error occurs when requesting
// interstitials from the Tapdaq servers
- (void)didFailToLoadInterstitial;

- (void)didFailToShowInterstitial;

// Called when the request for interstitials was successful,
// but no interstitials were found
- (void)hasNoInterstitialsAvailable;

// Called when the request for interstitials was successful
// and 1 or more interstitials were found
- (void)hasInterstitialsAvailableForOrientation:(TDOrientation)orientation;

- (void)didLoadInterstitial:(TDInterstitialAdvert *)advert forOrientation:(TDOrientation)orientation;
- (void)didFailToLoadInterstitialForOrientation:(TDOrientation)orientation;

- (void)didFailToLoadNativeAdverts;

- (void)hasNoNativeAdvertsAvailable;

- (void)hasNativeAdvertsAvailableForAdUnit:(TDNativeAdUnit)adUnit
                                      size:(TDNativeAdSize)adSize
                               orientation:(TDOrientation)orientation;


- (void)didLoadNativeAdvert:(TDNativeAdvert *)advert
                  forAdUnit:(TDNativeAdUnit)adUnit
                       size:(TDNativeAdSize)adSize
                orientation:(TDOrientation)orientation;

- (void)didFailToLoadNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                                      size:(TDNativeAdSize)adSize
                               orientation:(TDOrientation)orientation;

@end