//
//  TDAspectRatio.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `TDAspectRatio` is a class that represents the aspect ratio of a given set of dimensions.
 
 If `width` and `height` are provided to the initializer, it will calculate the aspect ratio. 
 If the default initialiser is used, it will obtain the screen's dimensions.
 */
@interface TDAspectRatio : NSObject

@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic) int originalWidth;
@property (nonatomic) int originalHeight;

/**
 Initializes a TDAspectRatio object based on a given `width` and `height`.
 
 @param width The width
 @param height The height
 */
- (id)initWithWidth:(int)width height:(int)height;

/**
 Returns a dictionary representation of the TDAspectRatio object, this is used in HTTP requests back to the Tapdaq servers
 
 @return NSDictionary a dictionary representation of the TDAspectRatio object.
 */
- (NSDictionary *)toDictionary;

@end
