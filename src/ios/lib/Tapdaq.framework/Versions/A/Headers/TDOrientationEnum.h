//
//  TDOrientation.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDOrientation) {
    TDOrientationPortrait,
    TDOrientationLandscape,
    TDOrientationUniversal
};

#define kTDOrientation @"PORTRAIT", @"LANDSCAPE", @"UNIVERSAL", nil