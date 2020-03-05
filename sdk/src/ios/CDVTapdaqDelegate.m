#import "CDVTapdaqDelegate.h"

static NSString *const kCDVTDCallbackDidInitialise = @"didInitialise";
static NSString *const kCDVTDCallbackDidFailToInitialise = @"didFailToInitialise";

@implementation CDVTapdaqDelegate

- (void)didLoadConfig
{
    NSDictionary *dict = [self dictionaryGivenEventName:kCDVTDCallbackDidInitialise];
    [self sendCallbackSuccessGivenDict:dict];
}

- (void)didFailToLoadConfigWithError:(NSError *)error
{
    NSDictionary *dict = [self dictionaryGivenError:error
                                          eventName:kCDVTDCallbackDidFailToInitialise];
    [self sendCallbackErrorGivenDict:dict];
}

@end