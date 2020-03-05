#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>
#import <Foundation/Foundation.h>

@interface CDVTDDelegateBase : NSObject
@property (nonatomic, strong) CDVInvokedUrlCommand *command;
@property (nonatomic, strong) id<CDVCommandDelegate> commandDelegate;

- (id)initWithCommand:(CDVInvokedUrlCommand *) command usingDelegate:(id<CDVCommandDelegate>) delegate;

- (void)sendCallbackSuccessGivenDict:(NSDictionary *)dictionary;

- (void)sendCallbackErrorGivenDict:(NSDictionary *)dictionary;

- (NSMutableDictionary *)dictionaryGivenEventName:(NSString *)eventName;

- (NSMutableDictionary *)dictionaryGivenEventName:(NSString *)eventName
                                        adRequest:(TDAdRequest *)adRequest;

- (NSDictionary *)dictionaryForTDError:(TDError *)error
                             eventName:(NSString *)eventName
                             adRequest:(TDAdRequest *)adRequest;

- (NSMutableDictionary *)dictionaryForError:(NSError *)error;

- (NSDictionary *)dictionaryGivenEventName:(NSString *)eventName
                                 adRequest:(TDAdRequest *)adRequest
                                    reward:(TDReward *)reward;


- (NSDictionary *)dictionaryGivenError:(NSError *)error
                             eventName:(NSString *)eventName;
@end