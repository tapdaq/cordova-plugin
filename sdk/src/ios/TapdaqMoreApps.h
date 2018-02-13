#import <Foundation/Foundation.h>
#import <Tapdaq/Tapdaq.h>

@protocol TapdaqStandardAd

+ (instancetype) sharedInstance;
- (BOOL)isReady;
- (void)show;
- (void)load;

@end


@interface TapdaqMoreApps : NSObject<TapdaqStandardAd>

- (void)loadWithConfig:(NSDictionary *)moreAppsConfig;

@end
