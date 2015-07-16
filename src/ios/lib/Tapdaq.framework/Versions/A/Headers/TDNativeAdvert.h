//
//  TDNativeAdvert.h
//  Tapdaq-sdk-v2
//
//  Created by Nick on 15/03/2015.
//  Copyright (c) 2015 Tapdaq. All rights reserved.
//

#import "TDAdvert.h"

#import "TDNativeAdUnitEnum.h"
#import "TDNativeAdSizeEnum.h"
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

@property (nonatomic) TDNativeAdUnit adUnit;
@property (nonatomic) TDNativeAdSize adSize;

- (id)initWithApplicationId:(NSString *)applicationId
                targetingId:(NSString *)targetingId
             subscriptionId:(NSString *)subscriptionId
                    storeId:(NSString *)storeId
                  customUrl:(NSString *)customUrl
     isBlockingInstalledApp:(BOOL)isBlockingInstalledApp
                   creative:(TDCreative *)creative
                       size:(TDNativeAdSize)size
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
