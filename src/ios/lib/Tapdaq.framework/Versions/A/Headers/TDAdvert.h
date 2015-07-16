//
//  TDAdvert.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 15/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TDCreative.h"

@interface TDAdvert : NSObject

@property (nonatomic, strong) NSString *applicationId;
@property (nonatomic, strong) NSString *targetingId;
@property (nonatomic, strong) NSString *subscriptionId;
@property (nonatomic, strong) NSString *storeId;
@property (nonatomic, strong) NSURL *customUrl;
@property (nonatomic) BOOL isBlockingInstalledApp;

@property (nonatomic, strong) TDCreative *creative;

@property (nonatomic, strong) NSURL *iconUrl;
@property (nonatomic, strong) UIImage *icon;

- (id)initWithApplicationId:(NSString *)applicationId
                targetingId:(NSString *)targetingId
             subscriptionId:(NSString *)subscriptionId
                    storeId:(NSString *)storeId
                  customUrl:(NSString *)customUrl
     isBlockingInstalledApp:(BOOL)isBlockingInstalledApp
                   creative:(TDCreative *)creative;

- (void)triggerImpression;

- (void)triggerClick;

@end
