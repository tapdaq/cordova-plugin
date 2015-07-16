/**
 Tapdaq Cordova Wrapper
 */

#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>

@interface CDVTapdaq : CDVPlugin <TapdaqDelegate>

- (void)init:(CDVInvokedUrlCommand *)command;

- (void)showInterstitial:(CDVInvokedUrlCommand *)command;

@end

@implementation CDVTapdaq

- (void)init:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult *pluginResult = nil;
        NSString *appId = [command.arguments objectAtIndex:0];
        NSString *clientKey = [command.arguments objectAtIndex:1];
        
        NSMutableDictionary *tapdaqConfig = [[NSMutableDictionary alloc] init];
        
        [tapdaqConfig setObject:@"cordova" forKey:@"sdkIdentifierPrefix"];
        [tapdaqConfig setObject:@YES forKey:@"testAdvertsEnabled"];
        
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