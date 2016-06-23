//
//  TDNativeAdUnitEnum.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDNativeAdUnit) {
    TDNativeAdUnitSquare,
    TDNativeAdUnitNewsfeed,
    TDNativeAdUnitFullscreen,
    TDNativeAdUnitStrip
};

#define kTDNativeAdUnit @"SQUARE", @"NEWSFEED", @"FULLSCREEN", @"STRIP", nil