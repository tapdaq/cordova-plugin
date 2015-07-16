//
//  TDAspectRatio.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 14/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDAspectRatio : NSObject

@property (nonatomic) int width;
@property (nonatomic) int height;

- (id)initWithWidth:(int)width height:(int)height;
- (NSDictionary *)toDictionary;

@end
