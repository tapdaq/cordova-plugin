/**
 Tapdaq Cordova Wrapper
 */

#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>

static NSString *const kConfigTestAdvertsEnabled = @"testAdvertsEnabled";
static NSString *const kConfigSdkIdentifierPrefix = @"sdkIdentifierPrefix";
static NSString *const kConfigOrientation = @"orientation";

@interface CDVTapdaq : CDVPlugin <TapdaqDelegate>

@property (nonatomic, strong) NSMutableDictionary *config;

- (void)setOptions:(CDVInvokedUrlCommand *)command;

- (void)init:(CDVInvokedUrlCommand *)command;

- (void)showInterstitial:(CDVInvokedUrlCommand *)command;

@end

@implementation CDVTapdaq

- (void)setOptions:(CDVInvokedUrlCommand *)command
{
    self.config = [[NSMutableDictionary alloc] init];
    NSDictionary *config = (NSDictionary *)[command.arguments objectAtIndex:0];
    
    if ([config objectForKey:kConfigTestAdvertsEnabled]) {
        BOOL testAdvertsEnabled = [config objectForKey:kConfigTestAdvertsEnabled];
        [self.config setObject:[NSNumber numberWithBool:testAdvertsEnabled] forKey:kConfigTestAdvertsEnabled];
    }
    
    if ([config objectForKey:kConfigOrientation]) {
        NSString *orientation = [config objectForKey:kConfigOrientation];
        
        orientation = [orientation lowercaseString];
        
        if ([orientation isEqualToString:@"universal"]) {
            [self.config setObject:[NSNumber numberWithInteger:TDOrientationUniversal] forKey:kConfigOrientation];
        } else if ([orientation isEqualToString:@"landscape"]) {
            [self.config setObject:[NSNumber numberWithInteger:TDOrientationLandscape] forKey:kConfigOrientation];
        } else if ([orientation isEqualToString:@"portrait"]) {
            [self.config setObject:[NSNumber numberWithInteger:TDOrientationPortrait] forKey:kConfigOrientation];
        }
    }
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

}

- (void)init:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult = nil;
        
        NSString *appId = [command.arguments objectAtIndex:0];
        NSString *clientKey = [command.arguments objectAtIndex:1];
        
        NSMutableDictionary *tapdaqConfig = [[NSMutableDictionary alloc] init];
        
        if (self.config && [self.config count] > 0) {
            tapdaqConfig = [NSMutableDictionary dictionaryWithDictionary:self.config];
        }
        
        [tapdaqConfig setObject:@"cordova" forKey:kConfigSdkIdentifierPrefix];
        
        [[Tapdaq sharedSession] setApplicationId:appId clientKey:clientKey config:tapdaqConfig];
        [[Tapdaq sharedSession] launch];
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)showInterstitial:(CDVInvokedUrlCommand *)command
{
    [[Tapdaq sharedSession] showInterstitial];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end

