//
//  TDMoreAppsConfig.h
//  Tapdaq iOS SDK
//
//  Created by Nick Reffitt on 12/03/2017.
//  Copyright © 2017 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TDNativeAdTypeEnum.h"

@interface TDMoreAppsConfig : NSObject

@property (nonatomic, strong) NSString *placementTagPrefix;

@property (nonatomic) int minAdsToDisplay;
@property (nonatomic) int maxAdsToDisplay;

@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) NSString *installedAppButtonText;

@property (nonatomic, strong) UIColor *headerTextColor;
@property (nonatomic, strong) UIColor *headerColor;
@property (nonatomic, strong) UIColor *headerCloseButtonColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *appNameColor;
@property (nonatomic, strong) UIColor *appButtonColor;
@property (nonatomic, strong) UIColor *appButtonTextColor;
@property (nonatomic, strong) UIColor *installedAppButtonColor;
@property (nonatomic, strong) UIColor *installedAppButtonTextColor;

@end
