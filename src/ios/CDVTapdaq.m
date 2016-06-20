/**
 Tapdaq Cordova Wrapper
 */

#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>


static NSString *const kConfigTestAdvertsEnabled = @"testAdvertsEnabled";
static NSString *const kConfigTrackInstallsOnly = @"trackInstallsOnly";
static NSString *const kConfigAdvertTypesEnabled = @"advertTypesEnabled";
static NSString *const kConfigOrientation = @"orientation";
static NSString *const kConfigFrequencyCap = @"frequencyCap";
static NSString *const kConfigFrequencyDurationInDays = @"frequencyDurationInDays";
static NSString *const kConfigMaxCachedAdverts = @"maxCachedAdverts";

static NSString *const kOrientationUniversal = @"universal";
static NSString *const kOrientationPortrait = @"portrait";
static NSString *const kOrientationLandscape = @"landscape";

static NSString *const kSdkIdentifierPrefix = @"cordova";

static NSString *const kEventKey = @"event";
static NSString *const kEventValueWillDisplayInterstitial = @"willDisplayInterstitial";
static NSString *const kEventValueDidDisplayInterstitial = @"didDisplayInterstitial";
static NSString *const kEventValueDidFailToDisplayInterstitial = @"didFailToDisplayInterstitial";
static NSString *const kEventValueDidCloseInterstitial = @"didCloseInterstitial";
static NSString *const kEventValueDidClickInterstitial = @"didClickInterstitial";
static NSString *const kEventValueDidFailToFetchInterstitialsFromServer = @"didFailToFetchInterstitialsFromServer";
static NSString *const kEventValueHasNoInterstitialsAvailable = @"hasNoInterstitialsAvailable";
static NSString *const kEventValueHasInterstitialsAvailableForOrientation = @"hasInterstitialsAvailableForOrientation";

static NSString *const kEventMessage = @"event";
static NSString *const kEventMessageOrientation = @"orientation";


@interface CDVTapdaq : CDVPlugin <TapdaqDelegate>

@property (nonatomic, strong) NSString *callbackId;
@property (nonatomic, strong) TDProperties *properies;

- (void)setOptions:(CDVInvokedUrlCommand *)command;

- (void)init:(CDVInvokedUrlCommand *)command;

- (void)showInterstitial:(CDVInvokedUrlCommand *)command;

@end


@implementation CDVTapdaq

- (void)setOptions:(CDVInvokedUrlCommand *)command
{
    self.properies = [[TDProperties alloc] init];
    NSDictionary *config = (NSDictionary *)[command.arguments objectAtIndex:0];

    if ([config objectForKey:kConfigTestAdvertsEnabled]) {
        BOOL testAdvertsEnabled = [config objectForKey:kConfigTestAdvertsEnabled];
        [self.properies setTestMode:testAdvertsEnabled];
    }

    if ([config objectForKey:kConfigOrientation]) {
        NSString *orientation = [config objectForKey:kConfigOrientation];

        orientation = [orientation lowercaseString];

        if ([orientation isEqualToString:kOrientationUniversal]) {
            [self.properies setOrientation:TDOrientationUniversal];
        } else if ([orientation isEqualToString:kOrientationLandscape]) {
            [self.properies setOrientation:TDOrientationLandscape];
        } else if ([orientation isEqualToString:kOrientationPortrait]) {
            [self.properies setOrientation:TDOrientationPortrait];
        }
    }

    if ([config objectForKey:kConfigTrackInstallsOnly]) {
        BOOL trackInstallsOnly = [config objectForKey:kConfigTrackInstallsOnly];

        if (trackInstallsOnly) {
            [self.properies setAdvertTypesToEnable:TDAdTypeNone];
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


        [self.properies setSdkIdentifierPrefix:kSdkIdentifierPrefix];

        [[Tapdaq sharedSession] setApplicationId:appId clientKey:clientKey properties:self.properies];
        [[Tapdaq sharedSession] launch];
        [[Tapdaq sharedSession] setDelegate:self];

        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [pluginResult setKeepCallbackAsBool:YES];
        self.callbackId = command.callbackId;

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

- (void)showInterstitial:(CDVInvokedUrlCommand *)command
{
    [[Tapdaq sharedSession] showInterstitial];

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

#pragma mark - Delegate methods

- (void)willDisplayInterstitial
{
    [self sendEventWithEventValue:kEventValueWillDisplayInterstitial];
}

- (void)didDisplayInterstitial
{
    [self sendEventWithEventValue:kEventValueDidDisplayInterstitial];
}

- (void)didFailToDisplayInterstitial
{
    [self sendEventWithEventValue:kEventValueDidFailToDisplayInterstitial];
}

- (void)didCloseInterstitial
{
    [self sendEventWithEventValue:kEventValueDidCloseInterstitial];
}

- (void)didClickInterstitial
{
    [self sendEventWithEventValue:kEventValueDidClickInterstitial];
}

- (void)didFailToFetchInterstitialsFromServer
{
    [self sendEventWithEventValue:kEventValueDidFailToFetchInterstitialsFromServer];
}

- (void)hasNoInterstitialsAvailable
{
    [self sendEventWithEventValue:kEventValueHasNoInterstitialsAvailable];
}

- (void)hasInterstitialsAvailableForOrientation:(TDOrientation)orientation
{
    NSString *orientationStr = kOrientationUniversal;

    if (orientation == TDOrientationPortrait) {
        orientationStr = kOrientationPortrait;
    } else if (orientation == TDOrientationLandscape) {
        orientationStr = kOrientationLandscape;
    }

    NSDictionary *dict = @{
                           kEventMessageOrientation: orientationStr
                           };

    [self sendEventWithEventValue:kEventValueHasInterstitialsAvailableForOrientation message:dict];
}

#pragma mark - Private methods

- (void)sendEventWithEventValue:(NSString *)eventValue
{
    NSDictionary *dict = @{
                           kEventKey: eventValue
                           };

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

- (void)sendEventWithEventValue:(NSString *)eventValue message:(NSDictionary *)message
{
    NSDictionary *dict = @{
                           kEventKey: eventValue,
                           kEventMessage: message
                           };

    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:dict];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
}

@end
