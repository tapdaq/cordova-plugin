//
//  TapdaqMoreApps.m
//  Unity-iPhone
//
//  Created by Andriy Medvid on 16.03.17.
//
//

#import "TapdaqMoreApps.h"

@implementation TapdaqMoreApps

+ (TapdaqMoreApps*)sharedInstance
{
    static dispatch_once_t once;
    static TapdaqMoreApps* sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isReady {
    return [[Tapdaq sharedSession] isMoreAppsReady];
}

- (void)show {
    [[Tapdaq sharedSession] showMoreApps];
}

- (void)load {
    [[Tapdaq sharedSession] loadMoreApps];
}

- (void)loadWithConfig:(NSDictionary *)moreAppsConfig {
    
    NSLog(@"TapdaqMoreApps.loadWithConfig. config:  %@", moreAppsConfig);            
    [[Tapdaq sharedSession] loadMoreAppsWithConfig: [self configFromDictionary: moreAppsConfig]];
}

- (int) intFromString:(NSString *) intString atPos:(int) position {
    
    char digit = [intString characterAtIndex: position];
    
    if(digit >= '0' && digit <= '9')
        return digit - '0';
    
    if(digit >= 'a' && digit <= 'f')
        return digit - 'a' + 10;
    
    if(digit >= 'A' && digit <= 'F')
        return digit - 'A' + 10;
    
    return 0;
}

- (UIColor *) colorFromString:(NSString *) colorString {
    
    if(colorString == nil || colorString.length != 9)
        return nil;
    
    int alpha = [self intFromString:colorString atPos:1]*16 + [self intFromString:colorString atPos:2];
    int red = [self intFromString:colorString atPos:3]*16 + [self intFromString:colorString atPos:4];
    int green = [self intFromString:colorString atPos:5]*16 + [self intFromString:colorString atPos:6];
    int blue = [self intFromString:colorString atPos:7]*16 + [self intFromString:colorString atPos:8];
    
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha/255.0];
}

- (TDMoreAppsConfig *) configFromDictionary: (NSDictionary *) dict {
    TDMoreAppsConfig * config = [[TDMoreAppsConfig alloc] init];
    
    if([dict objectForKey: @"placementTagPrefix"] != nil)
        config.placementTagPrefix = (NSString *)[dict objectForKey: @"placementTagPrefix"];
    
    if([dict objectForKey: @"minAdsToDisplay"] != nil)
        config.minAdsToDisplay = [(NSNumber *)[dict objectForKey: @"minAdsToDisplay"] intValue];
    
    if([dict objectForKey: @"maxAdsToDisplay"] != nil)
        config.maxAdsToDisplay = [(NSNumber *)[dict objectForKey: @"maxAdsToDisplay"] intValue];
    
    if([dict objectForKey: @"headerText"] != nil)
        config.headerText = (NSString *)[dict objectForKey: @"headerText"];
    
    if([dict objectForKey: @"installedAppButtonText"] != nil)
        config.installedAppButtonText = (NSString *)[dict objectForKey: @"installedAppButtonText"];
    
    if([dict objectForKey: @"headerTextColor"] != nil)
        config.headerTextColor = [self colorFromString: [dict objectForKey: @"headerTextColor"]] ;
    
    if([dict objectForKey: @"headerColor"] != nil)
        config.headerColor = [self colorFromString: [dict objectForKey: @"headerColor"]];
    
    if([dict objectForKey: @"headerCloseButtonColor"] != nil)
        config.headerCloseButtonColor = [self colorFromString: [dict objectForKey: @"headerCloseButtonColor"]];
    
    if([dict objectForKey: @"backgroundColor"] != nil)
        config.backgroundColor = [self colorFromString: [dict objectForKey: @"backgroundColor"]];
    
    if([dict objectForKey: @"appNameColor"] != nil)
        config.appNameColor = [self colorFromString: [dict objectForKey: @"appNameColor"]];
    
    if([dict objectForKey: @"appButtonColor"] != nil)
        config.appButtonColor = [self colorFromString: [dict objectForKey: @"appButtonColor"]];
    
    if([dict objectForKey: @"appButtonTextColor"] != nil)
        config.appButtonTextColor = [self colorFromString: [dict objectForKey: @"appButtonTextColor"]];
    
    if([dict objectForKey: @"installedAppButtonColor"] != nil)
        config.installedAppButtonColor = [self colorFromString: [dict objectForKey: @"installedAppButtonColor"]];
    
    if([dict objectForKey: @"installedAppButtonTextColor"] != nil)
        config.installedAppButtonTextColor = [self colorFromString: [dict objectForKey: @"installedAppButtonTextColor"]];
    
    return config;
}

@end