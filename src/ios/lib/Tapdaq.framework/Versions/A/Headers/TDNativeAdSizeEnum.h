//
//  TDNativeAdSizeEnum.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 16/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDNativeAdSize) {
    TDNativeAdSizeSmall,
    TDNativeAdSizeMedium,
    TDNativeAdSizeLarge
};

#define kTDNativeAdSize @"SMALL", @"MEDIUM", @"LARGE", nil