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
#import "TDTestDevices.h"
#import "TDLogLevel.h"

@interface TDProperties : NSObject

/**
 * Enables/Disables logging of the adapters.
 */
@property (nonatomic) BOOL isDebugEnabled;

/**
 * Enables/Disables ad auto reloading.
 */
@property (nonatomic) BOOL autoReloadAds;

/**
 Note: For plugin developers only.
 */
@property (nonatomic) NSString *pluginVersion;

/**
 * Set how fine-grained information is provided in Tapdaq's logs.
 * Default level is TDLogLevelInfo
 */
@property (assign, nonatomic) TDLogLevel logLevel;

/**
 * An new instance with default values;
 */
+ (instancetype)defaultProperties;

/**
 To use placement tags, you must create a TDPlacement object and register it.
 If you do not register a placement tag but attempt to use a custom one elsewhere, adverts will not display.
 
 @param placement The TDPlacement object to be registered
 */
- (BOOL)registerPlacement:(TDPlacement *)placement;
- (BOOL)registerPlacements:(NSArray *)placements;

- (BOOL)registerTestDevices:(TDTestDevices *)testDevices;

- (NSArray *)registeredPlacements;

- (NSArray *)registeredTestDevices;

@end
