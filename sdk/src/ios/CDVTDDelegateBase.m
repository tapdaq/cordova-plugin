#import "CDVTDAdRequestDelegate.h"

static NSString *const kCDVTDRewardKeyEventId = @"eventId";
static NSString *const kCDVTDRewardKeyName = @"name";
static NSString *const kCDVTDRewardKeyValue = @"value";
static NSString *const kCDVTDRewardKeyTag = @"placementTag";
static NSString *const kCDVTDRewardKeyIsValid = @"isValid";
static NSString *const kCDVTDRewardKeyCustomJson = @"customJson";

static NSString *const kCDVTDCallbackResponseAdUnit = @"adUnit";
static NSString *const kCDVTDCallbackResponsePlacementTag = @"placementTag";
static NSString *const kCDVTDCallbackResponseReward = @"reward";

static NSString *const kCDVTDCallbackKeyEventName = @"eventName";
static NSString *const kCDVTDCallbackKeyError = @"error";
static NSString *const kCDVTDCallbackKeyResponse = @"response";

static NSString *const kCDVTDCallbackErrorKeyCode = @"code";
static NSString *const kCDVTDCallbackErrorKeyMessage = @"message";
static NSString *const kCDVTDCallbackErrorKeySubErrors = @"subErrors";

@implementation CDVTDDelegateBase

- (id)initWithCommand:(CDVInvokedUrlCommand *) command usingDelegate:(id<CDVCommandDelegate>) delegate;
{
    self = [super init];
    if (self) {
        self.command = command;
        self.commandDelegate = delegate;
    }
    return self;
}

- (void)sendCallbackSuccessGivenDict:(NSDictionary *)dictionary
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                  messageAsDictionary:dictionary];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:[self command].callbackId];
}

- (void)sendCallbackErrorGivenDict:(NSDictionary *)dictionary
{
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                                  messageAsDictionary:dictionary];
    [pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult
                                callbackId:[self command].callbackId];
}

- (NSMutableDictionary *)dictionaryGivenEventName:(NSString *)eventName
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[kCDVTDCallbackKeyEventName] = eventName;
    return dict;
}

- (NSMutableDictionary *)dictionaryGivenEventName:(NSString *)eventName
                                        adRequest:(TDAdRequest *)adRequest
{
    NSMutableDictionary *dict = [self dictionaryGivenEventName:eventName];

    NSMutableDictionary *responseDict = [NSMutableDictionary new];
    responseDict[kCDVTDCallbackResponseAdUnit] = NSStringFromAdUnit(adRequest.placement.adUnit);
    responseDict[kCDVTDCallbackResponsePlacementTag] = adRequest.placement.tag;

    dict[kCDVTDCallbackKeyResponse] = responseDict;
    return dict;
}

- (NSDictionary *)dictionaryForTDError:(TDError *)error
                             eventName:(NSString *)eventName
                             adRequest:(TDAdRequest *)adRequest
{
    NSMutableDictionary *dict = [self dictionaryGivenEventName:eventName adRequest:adRequest];

    NSMutableDictionary *errorDict = [[self dictionaryForError:error] mutableCopy];
    if (error) {
        NSMutableDictionary<NSString *, NSArray *> *subErrorsDict = [NSMutableDictionary new];
        for (NSString *key in error.subErrors) {
            NSArray<NSError *> *errorDictEntry = error.subErrors[key];
            NSMutableArray<NSDictionary *> *errorArr = [NSMutableArray new];
            for (NSError *subError in errorDictEntry) {
                [errorArr addObject:[self dictionaryForError:subError]];
            }
            subErrorsDict[key] = errorArr;
        }

        if ([subErrorsDict count] > 0) {
            errorDict[kCDVTDCallbackErrorKeySubErrors] = subErrorsDict;
        }
    }
    dict[kCDVTDCallbackKeyError] = errorDict;

    return dict;
}

- (NSMutableDictionary *)dictionaryForError:(NSError *)error
{
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (error) {
        dict[kCDVTDCallbackErrorKeyCode] = @(error.code);
        dict[kCDVTDCallbackErrorKeyMessage] = error.localizedDescription;
    }
    return dict;
}

- (NSDictionary *)dictionaryGivenEventName:(NSString *)eventName
                                 adRequest:(TDAdRequest *)adRequest
                                    reward:(TDReward *)reward
{
    NSMutableDictionary *rewardDict = [NSMutableDictionary new];
    if (reward) {
        rewardDict[kCDVTDRewardKeyEventId] = reward.eventId;
        rewardDict[kCDVTDRewardKeyName] = reward.name;
        rewardDict[kCDVTDRewardKeyValue] = @(reward.value);
        rewardDict[kCDVTDRewardKeyIsValid] = @(reward.isValid);
        rewardDict[kCDVTDRewardKeyTag] = reward.tag;
        rewardDict[kCDVTDRewardKeyCustomJson] = reward.customJson;
    }

    NSMutableDictionary *dict = [self dictionaryGivenEventName:eventName
                                                     adRequest:adRequest];
    NSMutableDictionary *responseDict = dict[kCDVTDCallbackKeyResponse];
    responseDict[kCDVTDCallbackResponseReward] = rewardDict;
    return dict;
}


- (NSDictionary *)dictionaryGivenError:(NSError *)error
                             eventName:(NSString *)eventName
{
    NSMutableDictionary *dict = [self dictionaryGivenEventName:eventName];
    NSDictionary *errorDict = [self dictionaryForError:error];
    dict[kCDVTDCallbackKeyError] = errorDict;
    return dict;
}

@end