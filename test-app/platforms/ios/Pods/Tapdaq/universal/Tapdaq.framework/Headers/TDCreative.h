//
//  TDCreative.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class TDAspectRatio;

extern NSString *const kTDCreativeTypeKey;
extern NSString *const kTDCreativeIdentifierKey;
extern NSString *const kTDCreativeURLKey;
extern NSString *const kTDCreativeLocalURLKey;
extern NSString *const kTDCreativeDateDownloadedKey;

#pragma mark - TDCreative
@interface TDCreative : NSObject // Abstract

/**
 * The date creative was downloaded
 */
@property (nonatomic, strong) NSDate *dateDownloaded;

/**
* Unique identifier of the creative
*/
@property (nonatomic, strong) NSString *identifier;

/**
 * URL of the remotely stored data
 */
@property (nonatomic, strong) NSURL *url;

/**
 * URL of the locally stored data
 */
@property (nonatomic, strong) NSURL *localUrl;

- (id)initWithIdentifier:(NSString *)identifier urlString:(NSString *)urlString;
+ (instancetype)creativeWithDictionary:(NSDictionary *)dictionary;

/**
 * Size of the creative if available
 */
- (CGSize)getSize;
@end

#pragma mark - TDImageCreative
typedef void(^TDImageCreativeGetImageBlock)(UIImage *, NSError *);

@interface TDImageCreative : TDCreative
@property (nonatomic, readonly, getter=getImage) UIImage *image;

- (id)initWithIdentifier:(NSString *)identifier
                imageUrl:(NSString *)url;

- (void)getImageWithCompletion:(TDImageCreativeGetImageBlock)completion;
@end

#pragma mark - TDVideoCreative
@interface TDVideoCreative : TDCreative
- (id)initWithIdentifier:(NSString *)identifier
                videoUrl:(NSString *)urlString;
@end


