//
//  TDOrientation.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TDOrientation) {
    TDOrientationUnknown,
    TDOrientationPortrait,
    TDOrientationLandscape
};

static NSString *const kOrientationUnknown = @"unknown";
static NSString *const kOrientationPortrait = @"portrait";
static NSString *const kOrientationLandscape = @"landscape";

#define kTDOrientation @"PORTRAIT", @"LANDSCAPE", @"UNIVERSAL", nil
