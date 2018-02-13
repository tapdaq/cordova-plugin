//
//  TDNativeAdTypeEnum.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifndef TDNativeAdTypeEnum_h
#define TDNativeAdTypeEnum_h
typedef NS_ENUM(NSUInteger, TDNativeAdType) {
    
    TDNativeAdType1x1Large,
    TDNativeAdType1x1Medium,
    TDNativeAdType1x1Small,
    
    TDNativeAdType1x2Large,
    TDNativeAdType1x2Medium,
    TDNativeAdType1x2Small,
    
    TDNativeAdType2x1Large,
    TDNativeAdType2x1Medium,
    TDNativeAdType2x1Small,
    
    TDNativeAdType2x3Large,
    TDNativeAdType2x3Medium,
    TDNativeAdType2x3Small,
    
    TDNativeAdType3x2Large,
    TDNativeAdType3x2Medium,
    TDNativeAdType3x2Small,
    
    TDNativeAdType1x5Large,
    TDNativeAdType1x5Medium,
    TDNativeAdType1x5Small,
    
    TDNativeAdType5x1Large,
    TDNativeAdType5x1Medium,
    TDNativeAdType5x1Small,
    
    TDNativeAdTypeUnknown
    
};

#define kTDNativeAdType @"square_large", @"square_medium", @"square_small", @"newsfeed_tall_large", @"newsfeed_tall_medium", @"newsfeed_tall_small", @"newsfeed_wide_large", @"newsfeed_wide_medium", @"newsfeed_wide_small", @"fullscreen_tall_large", @"fullscreen_tall_medium", @"fullscreen_tall_small", @"fullscreen_wide_large", @"fullscreen_wide_medium", @"fullscreen_wide_small", @"strip_tall_large", @"strip_tall_medium", @"strip_tall_small", @"strip_wide_large", @"strip_wide_medium", @"strip_wide_small", @"unknown", nil


static NSString *const kNativeAdType1x1Large = @"square_large";
static NSString *const kNativeAdType1x1Medium = @"square_medium";
static NSString *const kNativeAdType1x1Small = @"square_small";

static NSString *const kNativeAdType1x2Large = @"newsfeed_tall_large";
static NSString *const kNativeAdType1x2Medium = @"newsfeed_tall_medium";
static NSString *const kNativeAdType1x2Small = @"newsfeed_tall_small";

static NSString *const kNativeAdType2x1Large = @"newsfeed_wide_large";
static NSString *const kNativeAdType2x1Medium = @"newsfeed_wide_medium";
static NSString *const kNativeAdType2x1Small = @"newsfeed_wide_small";

static NSString *const kNativeAdType2x3Large = @"fullscreen_tall_large";
static NSString *const kNativeAdType2x3Medium = @"fullscreen_tall_medium";
static NSString *const kNativeAdType2x3Small = @"fullscreen_tall_small";

static NSString *const kNativeAdType3x2Large = @"fullscreen_wide_large";
static NSString *const kNativeAdType3x2Medium = @"fullscreen_wide_medium";
static NSString *const kNativeAdType3x2Small = @"fullscreen_wide_small";

static NSString *const kNativeAdType1x5Large = @"strip_tall_large";
static NSString *const kNativeAdType1x5Medium = @"strip_tall_medium";
static NSString *const kNativeAdType1x5Small = @"strip_tall_small";

static NSString *const kNativeAdType5x1Large = @"strip_wide_large";
static NSString *const kNativeAdType5x1Medium = @"strip_wide_medium";
static NSString *const kNativeAdType5x1Small = @"strip_wide_small";

static NSString *const kNativeAdTypeUnknown = @"unknown";
#endif
