//
//  TDOrientation.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 15/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDOrientation) {
    TDOrientationPortrait,
    TDOrientationLandscape,
    TDOrientationUniversal
};

#define kTDOrientation @"PORTRAIT", @"LANDSCAPE", @"UNIVERSAL", nil