//
//  TDCreative.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 15/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TDOrientationEnum.h"
#import "TDResolutionEnum.h"

@class TDAspectRatio;

@interface TDCreative : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic) TDOrientation orientation;
@property (nonatomic) TDResolution resolution;
@property (nonatomic, strong) TDAspectRatio *aspectRatio;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) UIImage *image;

- (id)initWithIdentifier:(NSString *)identifier
              resolution:(TDResolution)resolution
             aspectRatio:(TDAspectRatio *)aspectRatio
                     url:(NSURL *)url;

- (id)initWithIdentifier:(NSString *)identifier
        resolutionNumber:(int)resolution
             aspectRatio:(TDAspectRatio *)aspectRatio
                     url:(NSString *)url
             orientation:(TDOrientation)orientation;

@end
