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

@property (nonatomic, assign) id <TapdaqDelegate> delegate;

// The singleton Tapdaq object, use this for all method calls
+ (id)sharedSession;

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

// Gets a native advert - expects config defaults to be set
- (TDNativeAdvert *)getNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                                        size:(TDNativeAdSize)adSize;

- (TDNativeAdvert *)getNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                                        size:(TDNativeAdSize)adSize
                                 orientation:(TDOrientation)orientation;

/** 
 Displays an interstitial to the user, if an interstitial is available to be shown. This method will time out gracefully (ie. no exception thrown) after 3 seconds if no advert is presented to the user in that time.
 */
- (void)showInterstitial;

- (void)triggerImpression:(TDAdvert *)advert;
- (void)sendImpression:(TDAdvert *)advert;

- (void)triggerClick:(TDAdvert *)advert;
- (void)sendClick:(TDAdvert *)advert;

- (void)launch;

// If you have disabled automatic advert fetching on application launch, then calling this method will begin fetching advert queues
- (void)fetchAds;

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

// Called when the request for interstitials was successful,
// but no interstitials were found
- (void)hasNoInterstitialsAvailable;

// Called when the request for interstitials was successful
// and 1 or more interstitials were found
- (void)hasInterstitialsAvailableForOrientation:(TDOrientation)orientation;

- (void)didFailToLoadNativeAdverts;

- (void)hasNoNativeAdvertsAvailable;

- (void)hasNativeAdvertsAvailableForAdUnit:(TDNativeAdUnit)adUnit
                                      size:(TDNativeAdSize)adSize
                               orientation:(TDOrientation)orientation;

@end