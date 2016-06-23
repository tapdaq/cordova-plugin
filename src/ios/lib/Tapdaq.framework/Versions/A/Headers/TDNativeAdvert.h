//
//  TDNativeAdvert.h
//  Tapdaq
//
//  Created by Tapdaq <support@tapdaq.com>
//  Copyright (c) 2016 Tapdaq. All rights reserved.
//

#import "TDAdvert.h"

#import "TDNativeAdUnitEnum.h"
#import "TDNativeAdSizeEnum.h"
#import "TDNativeAdTypeEnum.h"
#import "TDOrientationEnum.h"

@interface TDNativeAdvert : TDAdvert

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, strong) NSString *appDescription;
@property (nonatomic, strong) NSString *buttonText;
@property (nonatomic, strong) NSString *developerName;
@property (nonatomic, strong) NSString *ageRating;
@property (nonatomic) float appSize;
@property (nonatomic) float averageReview;
@property (nonatomic) int totalReviews;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic) float price;
@property (nonatomic, strong) NSString *currency;

@property (nonatomic) TDNativeAdType adType;
@property (nonatomic) TDNativeAdUnit adUnit __deprecated;
@property (nonatomic) TDNativeAdSize adSize __deprecated;

- (id)initWithApplicationId:(NSString *)applicationId
                targetingId:(NSString *)targetingId
             subscriptionId:(NSString *)subscriptionId
                    storeId:(NSString *)storeId
                  customUrl:(NSString *)customUrl
     isBlockingInstalledApp:(BOOL)isBlockingInstalledApp
                   creative:(TDCreative *)creative
                        tag:(NSString *)tag
                     adType:(TDNativeAdType)adType
                    iconUrl:(NSString *)iconUrl
                    appName:(NSString *)appName
                description:(NSString *)description
                    ctaText:(NSString *)ctaText
              developerName:(NSString *)developerName
                  ageRating:(NSString *)ageRating
                    appSize:(float)appSize
              averageReview:(float)averageReview
               totalReviews:(int)totalReviews
                   category:(NSString *)category
                 appVersion:(NSString *)appVersion
                      price:(float)price
                   currency:(NSString *)currency;

@end
