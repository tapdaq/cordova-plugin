//
//  TDMBannerSizeEnum.h
//  Tapdaq iOS SDK
//
//  Created by Mukund Agarwal on 17/10/2016.
//  Copyright © 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDMBannerSize) {
    TDMBannerStandard,
    TDMBannerLarge,
    TDMBannerMedium,
    TDMBannerFull,
    TDMBannerLeaderboard,
    TDMBannerSmartPortrait,
    TDMBannerSmartLandscape,
    TDMBannerSkyscraper
};

#define kTDMBannerSize @"Standard", @"Large", @"Medium", @"Full", @"Leaderboard", @"Smart Portrait", @"Smart Landscape", @"Skyscraper", nil
