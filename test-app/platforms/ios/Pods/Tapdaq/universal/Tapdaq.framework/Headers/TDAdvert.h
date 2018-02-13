//
//  TDAdvert.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDCreative.h"

@interface TDAdvert : NSObject

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *targetingId;
@property (nonatomic, strong) NSString *subscriptionId;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSURL *customUrl;
@property (nonatomic) BOOL isBlockingInstalledApp;

@property (nonatomic) NSNumber *frequencyCap;
@property (nonatomic) NSNumber *frequencyCapDurationInDays;

@property (nonatomic, strong) TDCreative *creative;

@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, strong) UIImage *icon;

- (id)initWithApplicationId:(NSString *)applicationId
                targetingId:(NSString *)targetingId
             subscriptionId:(NSString *)subscriptionId
                    storeId:(NSString *)storeId
                  customUrl:(NSString *)customUrl
     isBlockingInstalledApp:(BOOL)isBlockingInstalledApp
                        tag:(NSString *)tag;

- (void)triggerImpression;

- (void)triggerClick;

- (void)preloadAppStore;
@end
