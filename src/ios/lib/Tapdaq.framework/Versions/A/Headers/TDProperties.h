//
//  TDProperties.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDOrientationEnum.h"
#import "TDAdTypeEnum.h"
#import "TDPlacement.h"

@interface TDProperties : NSObject

/**
 Set to YES if you want to display test adverts, NO for live adverts.
 --WARNING-- You must set this to NO when submitting your app to the App Store.
 
 Defaults to NO.
 */
@property (nonatomic) BOOL testMode;

/**
 Declare which adverts you want to use in your application. 
 Tapdaq will then fetch adverts for each TDAdType in the background.
 
 Defaults to TDAdTypeInterstitial.
 */
@property (nonatomic) TDAdTypes advertTypesToEnable;

/**
 Set how often the same advert should appear to the user.
 
 Defaults to 2.
 */
@property (nonatomic) NSInteger frequencyCap;

/**
 Set the number of days the frequencyCap should be applied to.
 For example, a frequencyDurationInDays = 2, frequencyCap = 3 means the same ad will be shown to the user a maximum of 3 times in 2 days.
 
 Defaults to 1.
 */
@property (nonatomic) NSInteger frequencyDurationInDays;

/**
 Set how many adverts per TDAdType should be cached on the device. The more adverts that are cached, the faster adverts are displayed to the user, but uses more storage.
 
 Defaults to 3.
 */
@property (nonatomic) NSUInteger maxCachedAdverts;

/**
 Force an orientation to be set when fetching interstitial adverts. 
 For some environments, the orientation does not get set correctly (e.g Unity).
 
 Defaults to TDOrientationUniversal.
 */
@property (nonatomic) TDOrientation orientation;

/**
 Note: For plugin developers only.
 Prefix the name of your library/plugin
 */
@property (nonatomic) NSString *sdkIdentifierPrefix;

/**
 Set to YES if you want to use mediation model. 
 This mode means that you load adverts manually one at a time, the success or failure is sent to delegates
 
 Defaults to NO.
 */
@property (nonatomic) BOOL mediationMode;

/**
 To use placement tags, you must create a TDPlacement object and register it.
 If you do not register a placement tag but attempt to use a custom one elsewhere, adverts will not display.
 
 @param placement The TDPlacement object to be registered
 */
- (BOOL)registerPlacement:(TDPlacement *)placement;
- (BOOL)registerPlacements:(NSArray *)placements;

- (NSArray *)registeredPlacements;

@end
