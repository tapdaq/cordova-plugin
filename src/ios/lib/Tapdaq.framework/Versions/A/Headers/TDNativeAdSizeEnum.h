//
//  TDNativeAdSizeEnum.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDNativeAdSize) {
    TDNativeAdSizeSmall,
    TDNativeAdSizeMedium,
    TDNativeAdSizeLarge
};

#define kTDNativeAdSize @"SMALL", @"MEDIUM", @"LARGE", nil