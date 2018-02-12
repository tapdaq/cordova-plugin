//
//  Tapdaq.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Tapdaq/TDOrientationEnum.h>
#import <Tapdaq/TDNativeAdUnitEnum.h>
#import <Tapdaq/TDNativeAdSizeEnum.h>

#import <Tapdaq/TDAdTypeEnum.h>
#import <Tapdaq/TDNativeAdTypeEnum.h>
#import <Tapdaq/TDMNetworkEnum.h>
#import <Tapdaq/TDMBannerSizeEnum.h>
#import <Tapdaq/TDReward.h>

@protocol TapdaqDelegate;

@class TDAdvert;
@class TDNativeAdvert;
@class TDInterstitialAdvert;
@class TDProperties;
@class TDPlacement;
@class TDMoreAppsConfig;

typedef NSString *const TDPTag;

// Default.
extern TDPTag const TDPTagDefault;
// Bootup - Initial bootup of game.
extern TDPTag const TDPTagBootup;
// Home Screen - Home screen the player first sees.
extern TDPTag const TDPTagHomeScreen;
// Main Menu - Menu that provides game options.
extern TDPTag const TDPTagMainMenu;
// Pause - Pause screen.
extern TDPTag const TDPTagPause;
// Level Start - Start of the level.
extern TDPTag const TDPTagLevelStart;
// Level Complete - Completion of the level.
extern TDPTag const TDPTagLevelComplete;
// Game Center - After a user visits the Game Center.
extern TDPTag const TDPTagGameCenter;
// IAP Store - The store where the player pays real money for currency or items.
extern TDPTag const TDPTagIAPStore;
// Item Store - The store where a player buys virtual goods.
extern TDPTag const TDPTagItemStore;
// Game Over - The game over screen after a player is finished playing.
extern TDPTag const TDPTagGameOver;
// Leaderboard - List of leaders in the game.
extern TDPTag const TDPTagLeaderBoard;
// Settings - Screen where player can change settings such as sound.
extern TDPTag const TDPTagSettings ;
// Quit - Screen displayed right before the player exits a game.
extern TDPTag const TDPTagQuit;

@interface Tapdaq : NSObject

@property (readonly, nonatomic) BOOL isConfigLoaded;

/**
 * Current version of the SDK
 */
@property (readonly, nonatomic) NSString *sdkVersion;

@property (nonatomic, weak) id <TapdaqDelegate> delegate;

#pragma mark Singleton
/**
 The singleton Tapdaq object, use this for all method calls
 
 @return The Tapdaq singleton.
 */
+ (instancetype)sharedSession;

- (void)trackPurchaseForProductName:(NSString *)productName price:(double)price priceLocale:(NSString *)priceLocale;

#pragma mark Initializing Tapdaq

/**
 A setter for the Application ID of your app, and the Client Key associated with your Tapdaq account. 
 You can obtain these details when you sign up and add your app to https://tapdaq.com
 You must use this in the application:didFinishLaunchingWithOptions method.
 
 @param applicationId The application ID tied to your app.
 @param clientKey The client key tied to your app.
 @param properties The properties object that overrides the Tapdaq defaults. See TDProperties for info on all configuration options.
 */
- (void)setApplicationId:(NSString *)applicationId
               clientKey:(NSString *)clientKey
              properties:(TDProperties *)properties;

/**
 * Get current SDK initialisation status
 *
 * @return YES if the SDK is initialised. NO otherwise.
 */
- (BOOL)isInitialised;

#pragma mark Reward
- (NSString *)rewardIdForPlacementTag:(NSString *)placementTag;

#pragma mark Debugger
- (void)presentDebugViewController;

#pragma mark Banner

- (void)loadBanner:(TDMBannerSize)size;

- (BOOL)isBannerReady;

- (UIView *)getBanner;

#pragma mark Interstitial

- (void)loadInterstitialForPlacementTag:(NSString *)placementTag;

- (BOOL)isInterstitialReadyForPlacementTag:(NSString *)placementTag;

- (void)showInterstitialForPlacementTag:(NSString *)placementTag;

- (void)loadInterstitial __attribute__((deprecated("loadInterstitial has been deprecated. Please use loadInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

- (BOOL)isInterstitialReady __attribute__((deprecated("isInterstitialReady has been deprecated. Please use isInterstitialReadyForPlacementTag: instead. This method will be removed in future releases.")));

- (void)showInterstitial __attribute__((deprecated("showInterstitial has been deprecated. Please use showInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

#pragma mark Video

- (void)loadVideoForPlacementTag:(NSString *)placementTag;

- (BOOL)isVideoReadyForPlacementTag:(NSString *)placementTag;

- (void)showVideoForPlacementTag:(NSString *)placementTag;

- (void)loadVideo __attribute__((deprecated("loadVideo has been deprecated. Please use loadVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (BOOL)isVideoReady __attribute__((deprecated("isVideoReady has been deprecated. Please use isVideoReadyForPlacementTag: instead. This method will be removed in future releases.")));

- (void)showVideo __attribute__((deprecated("showVideo has been deprecated. Please use showVideoForPlacementTag: instead. This method will be removed in future releases.")));

#pragma mark Rewarded Video

- (void)loadRewardedVideoForPlacementTag:(NSString *)placementTag;

- (BOOL)isRewardedVideoReadyForPlacementTag:(NSString *)placementTag;

- (void)showRewardedVideoForPlacementTag:(NSString *)placementTag;

- (void)loadRewardedVideo __attribute__((deprecated("loadRewardedVideo has been deprecated. Please use loadRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (BOOL)isRewardedVideoReady __attribute__((deprecated("isRewardedVideoReady has been deprecated. Please use isRewardedVideoReadyForPlacementTag: instead. This method will be removed in future releases.")));

- (void)showRewardedVideo __attribute__((deprecated("showRewardedVideo has been deprecated. Please use showRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));
    
#pragma mark Offerwall
    
- (void)loadOfferwall;
    
- (BOOL)isOfferwallReady;
    
- (void)showOfferwall;

#pragma mark Native adverts

/**
 Loads a native advert for a particular placement tag, this will fetch the native advert's creative, and call either -didLoadNativeAdvert:forPlacementTag:adType: if the advert is successfully loaded, or -didFailToLoadNativeAdvertForPlacementTag:adType: if it fails to load.
 We recommend you implement both delegate methods to handle the advert accordingly.
 
 @param placementTag The placement tag of the advert to be loaded.
 @param nativeAdType The native ad type of the advert to be loaded.
 */
- (void)loadNativeAdvertForPlacementTag:(NSString *)placementTag adType:(TDNativeAdType)nativeAdType;

/**
 Fetches a TDNativeAdvert for a particular placement tag.
 You must register the tag in TDProperties otherwise adverts will not display.
 
 @param placementTag The placement tag
 @param nativeAdType The native advert type to be fetched.
 */
- (TDNativeAdvert *)getNativeAdvertForPlacementTag:(NSString *)placementTag adType:(TDNativeAdType)nativeAdType;

/**
 This method must be called when the advert is displayed to the user. You do not need to call this method when using -showInterstitial. 
 This should only be used when either a TDInterstitialAdvert or TDNativeAdvert has been fetched.
 
 @param advert The TDAdvert that has been displayed to the user, this can be a TDInterstitialAdvert or TDNativeAdvert.
 */
- (void)triggerImpression:(TDAdvert *)advert;

/**
 This method must be called when a user taps on the advert, you do not need to call this method when using -showInterstitial. 
 This should only be used when either TDInterstitialAdvert or TDNativeAdvert has been fetched.
 Unlike -triggerImpression:, this method will also direct users to the the App Store, or to a custom URL, depending on the adverts configuration.
 
 @param advert The TDAdvert that has been displayed to the user, this can be a TDInterstitialAdvert or TDNativeAdvert.
 */
- (void)triggerClick:(TDAdvert *)advert;

/**
 Loads a native advert, this will fetch the native advert's creative, and call either -didLoadNativeAdvert:forAdType: if the advert is successfully loaded, or -didFailToLoadNativeAdvertForAdType: if it fails to load.
 We recommend you implement both delegate methods to handle the advert accordingly.
 
 @param nativeAdType The native advert type to be loaded.
 */
- (void)loadNativeAdvertForAdType:(TDNativeAdType)nativeAdType;

/**
 Fetches a TDNativeAdvert which, unlike -showInterstitial, gives you full control over the UI layout.
 This advert will include the already-fetched creative, icon, and other data such as app name, description, etc.
 You must implement -triggerImpression: and -triggerClick: when using this method.
 
 @param nativeAdType The native advert type to be fetched.
 @return A TDNativeAdvert.
 */
- (TDNativeAdvert *)getNativeAdvertForAdType:(TDNativeAdType)nativeAdType;

#pragma mark - More apps

- (void)loadMoreApps;

- (void)loadMoreAppsWithConfig:(TDMoreAppsConfig *)moreAppsConfig;

- (BOOL)isMoreAppsReady;

- (void)showMoreApps;

#pragma mark Misc

/**
 * This method is only used for plugins such as Unity which do not automatically trigger the launch request on application bootup.
 * Or in the case -setApplicationId:clientKey:properties: is called outside AppDelegate.
 */
- (void)launch;

@end

#pragma mark -
#pragma mark TapdaqDelegate

@protocol TapdaqDelegate <NSObject>

@optional

- (void)didLoadConfig;

- (void)didFailToLoadConfig;

#pragma mark Banner delegate methods

/**
 Called immediately after the banner is loaded.
 This method should be used in conjunction with -getBanner:.
 */
- (void)didLoadBanner;

/**
 Called when, for whatever reason, the banner was not able to be loaded.
 Tapdaq will automatically attempt to load a banner again with a 1 second delay.
 */
- (void)didFailToLoadBanner;

/**
 Called when the user clicks the banner.
 */
- (void)didClickBanner;

/**
 Called when the ad within the banner view loads another ad.
 */
- (void)didRefreshBanner;

#pragma mark Interstitial delegate methods

/**
 Called immediately after an interstitial is available to the user for a specific placement tag.
 This method should be used in conjunction with -showInterstitialForPlacementTag:.
 @param placementTag A placement tag.
 */
- (void)didLoadInterstitialForPlacementTag:(NSString *)placementTag;

/**
 Called when the interstitial was not able to be loaded for a specific placement tag.
 Tapdaq will automatically attempt to load an interstitial again with a 1 second delay.
 @param placementTag A placement tag.
 */
- (void)didFailToLoadInterstitialForPlacementTag:(NSString *)placementTag;

/**
 Called immediately before the interstitial is to be displayed to the user.
 */
- (void)willDisplayInterstitial __attribute__((deprecated("willDisplayInterstitial has been deprecated. Please use willDisplayInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

- (void)willDisplayInterstitialForPlacementTag:(NSString *)placementTag;

/**
 Called immediately after the interstitial is displayed to the user.
 */
- (void)didDisplayInterstitial __attribute__((deprecated("didDisplayInterstitial has been deprecated. Please use didDisplayInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didDisplayInterstitialForPlacementTag:(NSString *)placementTag;

/**
 Called when the user closes interstitial, either by tapping the close button, or the background surrounding the interstitial.
 */
- (void)didCloseInterstitial __attribute__((deprecated("didCloseInterstitial has been deprecated. Please use didCloseInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didCloseInterstitialForPlacementTag:(NSString *)placementTag;

/**
 Called when the user clicks the interstitial.
 */
- (void)didClickInterstitial __attribute__((deprecated("didClickInterstitial has been deprecated. Please use didClickInterstitialForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didClickInterstitialForPlacementTag:(NSString *)placementTag;

#pragma mark Video delegate methods

/**
 Called immediately after a video is available to the user for a specific placement tag.
 This method should be used in conjunction with -showVideoForPlacementTag:.
 @param placementTag A placement tag.
 */
- (void)didLoadVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when, for whatever reason, the video was not able to be loaded.
 Tapdaq will automatically attempt to load a video again with a 1 second delay.
 @param placementTag A placement tag.
 */
- (void)didFailToLoadVideoForPlacementTag:(NSString *)placementTag;

/**
 Called immediately before the video is to be displayed to the user.
 */
- (void)willDisplayVideo __attribute__((deprecated("willDisplayVideo has been deprecated. Please use willDisplayVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)willDisplayVideoForPlacementTag:(NSString *)placementTag;

/**
 Called immediately after the video is displayed to the user.
 */
- (void)didDisplayVideo __attribute__((deprecated("didDisplayVideo has been deprecated. Please use didDisplayVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didDisplayVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when the user closes the video.
 */
- (void)didCloseVideo __attribute__((deprecated("didCloseVideo has been deprecated. Please use didCloseVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didCloseVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when the user clicks the video ad.
 */
- (void)didClickVideo __attribute__((deprecated("didClickVideo has been deprecated. Please use didClickVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didClickVideoForPlacementTag:(NSString *)placementTag;


#pragma mark Rewarded Video delegate methods

/**
 Called immediately after a rewarded video is available to the user for a specific placement tag.
 This method should be used in conjunction with -showRewardedVideoForPlacementTag:.
 @param placementTag A placement tag.
 */
- (void)didLoadRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when, for whatever reason, the rewarded video was not able to be loaded.
 Tapdaq will automatically attempt to load a rewarded video again with a 1 second delay.
 @param placementTag A placement tag.
 */
- (void)didFailToLoadRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called immediately before the rewarded video is to be displayed to the user.
 */
- (void)willDisplayRewardedVideo __attribute__((deprecated("willDisplayRewardedVideo has been deprecated. Please use willDisplayRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)willDisplayRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called immediately after the rewarded video is displayed to the user.
 */
- (void)didDisplayRewardedVideo __attribute__((deprecated("didDisplayRewardedVideo has been deprecated. Please use didDisplayRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didDisplayRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when the user closes the rewarded video.
 */
- (void)didCloseRewardedVideo __attribute__((deprecated("didCloseRewardedVideo has been deprecated. Please use didCloseRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didCloseRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when the user clicks the rewarded video ad.
 */
- (void)didClickRewardedVideo __attribute__((deprecated("didClickRewardedVideo has been deprecated. Please use didClickRewardedVideoForPlacementTag: instead. This method will be removed in future releases.")));

- (void)didClickRewardedVideoForPlacementTag:(NSString *)placementTag;

/**
 Called when a reward is ready for the user.
 @param rewardName The name of the reward.
 @param rewardAmount The value of the reward.
 */
- (void)rewardValidationSucceededForRewardName:(NSString *)rewardName
                                  rewardAmount:(int)rewardAmount __attribute__((deprecated("rewardValidationSucceededForRewardName:rewardAmount: has been deprecated. Please use rewardValidationSucceeded: instead. This method will be removed in future releases.")));
/**
 Called when a reward is ready for the user.
 @param placementTag Placement tag.
 @param rewardName The name of the reward.
 @param rewardAmount The value of the reward.
 */
- (void)rewardValidationSucceededForPlacementTag:(NSString *)placementTag
                                      rewardName:(NSString *)rewardName
                                    rewardAmount:(int)rewardAmount __attribute__((deprecated("rewardValidationSucceededForPlacementTag:rewardName:rewardAmount: has been deprecated. Please use rewardValidationSucceeded: instead. This method will be removed in future releases.")));
/**
 Called when a reward is ready for the user.
 @param placementTag Placement tag.
 @param rewardName The name of the reward.
 @param rewardAmount The value of the reward.
 @param payload Dictionary payload configured on the dashboard.
 */
- (void)rewardValidationSucceededForPlacementTag:(NSString *)placementTag
                                      rewardName:(NSString *)rewardName
                                    rewardAmount:(int)rewardAmount
                                         payload:(NSDictionary *)payload  __attribute__((deprecated("rewardValidationSucceededForPlacementTag:rewardName:rewardAmount:payload: has been deprecated. Please use rewardValidationSucceeded: instead. This method will be removed in future releases.")));

/**
Called when a reward is ready for the user.
@param reward Reward object.
@see TDReward
*/
- (void)rewardValidationSucceeded:(TDReward *)reward;

/**
 Called if an error occurred when rewarding the user.
 */
- (void)rewardValidationErrored __attribute__((deprecated("rewardValidationErrored has been deprecated. Please use rewardValidationErroredForPlacementTag: instead. This method will be removed in future releases.")));

- (void)rewardValidationErroredForPlacementTag:(NSString *)placementTag;

#pragma mark Native advert delegate methods

/**
 Called when a native advert is successfully loaded, used in conjunction with -loadNativeAdvertForPlacementTag:adType:.
 
 @param placementTag The placement tag of the native advert that loaded.
 @param nativeAdType The ad type of the native advert that loaded.
 */
- (void)didLoadNativeAdvertForPlacementTag:(NSString *)placementTag
                                    adType:(TDNativeAdType)nativeAdType;

/**
 Called when the native ad failed to load, used in conjunction with -loadNativeAdvertForPlacementTag:adType:.
 
 @param placementTag The placement tag that failed to load the native ad.
 @param nativeAdType The ad type of the native advert that failed to load.
 */
- (void)didFailToLoadNativeAdvertForPlacementTag:(NSString *)placementTag
                                          adType:(TDNativeAdType)nativeAdType;

#pragma mark More apps delegate methods

- (void)didLoadMoreApps;

- (void)didFailToLoadMoreApps;

- (void)willDisplayMoreApps;

- (void)didDisplayMoreApps;

- (void)didCloseMoreApps;

#pragma mark Offerwall delegate methods
    
- (void)didLoadOfferwall;
    
- (void)didFailToLoadOfferwall;
    
- (void)willDisplayOfferwall;
    
- (void)didDisplayOfferwall;
    
- (void)didCloseOfferwall;
    
- (void)didReceiveOfferwallCredits:(NSDictionary *)creditInfo;
    
- (void)didFailToReceiveOfferwallCredits;
@end
