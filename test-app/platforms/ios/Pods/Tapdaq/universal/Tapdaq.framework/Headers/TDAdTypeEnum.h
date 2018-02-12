//
//  TDAdTypeEnum.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, TDAdTypes) {
    
    TDAdTypeNone         = 1 << 0,
    
    TDAdTypeInterstitial = 1 << 1,
    
    TDAdType1x1Large     = 1 << 2,
    TDAdType1x1Medium    = 1 << 3,
    TDAdType1x1Small     = 1 << 4,
    
    TDAdType1x2Large     = 1 << 5,
    TDAdType1x2Medium    = 1 << 6,
    TDAdType1x2Small     = 1 << 7,
    
    TDAdType2x1Large     = 1 << 8,
    TDAdType2x1Medium    = 1 << 9,
    TDAdType2x1Small     = 1 << 10,
    
    TDAdType2x3Large     = 1 << 11,
    TDAdType2x3Medium    = 1 << 12,
    TDAdType2x3Small     = 1 << 13,
    
    TDAdType3x2Large     = 1 << 14,
    TDAdType3x2Medium    = 1 << 15,
    TDAdType3x2Small     = 1 << 16,
    
    TDAdType1x5Large     = 1 << 17,
    TDAdType1x5Medium    = 1 << 18,
    TDAdType1x5Small     = 1 << 19,
    
    TDAdType5x1Large     = 1 << 20,
    TDAdType5x1Medium    = 1 << 21,
    TDAdType5x1Small     = 1 << 22,
    
    TDAdTypeVideo        = 1 << 23,
    TDAdTypeRewardedVideo= 1 << 24,
    TDAdTypeBanner       = 1 << 25,
    
    TDAdTypeOfferwall    = 1 << 26

};
