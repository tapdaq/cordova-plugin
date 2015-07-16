

# Tapdaq SDK

Thank you for downloading the Tapdaq SDK! The installation is very
simple, here's a quick how-to guide.

### 1. Add Dependencies

Open your project in Xcode, click on the project file, and select the
target of the application, then click 'Build Phases'. 

Please add the following frameworks under the 'Link Binary With
Libraries' section:

- Foundation (required)
- UIKit (required)
- QuartzCore (required)
- AdSupport (required)

### 2. Add Framework

Drag the unzipped `Tapdaq.framework` folder. We
recommend that you tick 'Copy items into destination group's folder'.

### 3. Add Bundle

Drag the unzipped `TapdaqResources.bundle` file into your project. We
recommend that you tick 'Copy items into destination group's folder'.

### 4. Authenticate with Tapdaq

Once you have added the framework, next you need to add the following
`#import` statement at the top of your `AppDelegate.m` file:

    #import <Tapdaq/Tapdaq.h>

Navigate to the following method in your `AppDelegate.m` file and add
the following command:

    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    {
    	NSMutableDictionary *tapdaqConfig = [[NSMutableDictionary alloc] init];
	    [tapdaqConfig setObject:@YES forKey:@"testAdvertsEnabled"];

        [[Tapdaq sharedSession] setApplicationId:@"YOUR_TAPDAQ_APP_ID"
                                       clientKey:@"YOUR_TAPDAQ_CLIENT_KEY"
                                          config:tapdaqConfig];
        
        return YES;
    }


Please replace `YOUR_TAPDAQ_APP_ID` and `YOUR_TAPDAQ_CLIENT_KEY` with the
details that you should have received in an email, please check your
inbox. 

Build your application to test it is installed correctly.

**WARNING: If Test Mode is enabled when you submit your App to the App Store, you will display test adverts to your customers.**

You will need to ensure that `testAdvertsEnabled` key in the config is not included in the release build. 
We recommend that you use the `#IFDEF` preprocessor directive to exclude the setting from the build e.g.:

	#ifdef DEBUG
		[tapdaqConfig setObject:@YES forKey:@"testAdvertsEnabled"];
	#endif

## Fetching an advert

### Requirements

By fetching adverts manually, it is your responsibility to tell Tapdaq when an impression and click occurs, 
here are some examples below on how to do this.
Note: The method `sendClick` will direct the user to the advertised application in the App Store.

First, lets assume that your header file has:
	
	#import <Tapdaq/Tapdaq.h>
	...

	@property (nonatomic, strong) TDInterstitialAdvert *interstitialAdvert;

Then somewhere in your implementation file:

	...
	self.interstitialAdvert = [[Tapdaq sharedSession] getInterstitialAdvertForOrientation:TDOrientationPortrait];
	...

#### Method 1

In your implementation file, at the point when you display the advert to the user:

	...
	[[Tapdaq sharedSession] sendImpression:self.interstitialAdvert];
	...

Then in your implementation file, at the point when the user clicks the advert:

	...
	[[Tapdaq sharedSession] sendClick:self.interstitialAdvert];
	...

#### Method 2

In your implementation file, at the point when you display the advert to the user:

	...
	[self.interstitialAdvert sendImpression];
	...

Then in your implementation file, at the point when the user clicks the advert:

	...
	[self.interstitialAdvert sendClick];
	...

## Fetching an interstitial

To take full control over the adverts you wish to display to the user, you first need to fetch the advert.

	TDInterstitialAdvert *interstitialAdvert = [[Tapdaq sharedSession] getInterstitialAdvertForOrientation:TDOrientationPortrait];

For interstitials, only use `TDOrientationPortrait` and `TDOrientationLandscape` enum values. The structure of an interstitial is as follows:

	(TDInterstitialAdvert) =>
		(NSString) applicationId
		(NSString) targetingId
		(NSString) subscriptionId // (optional) 
		(TDCreative) creative =>
			(NSString) identifier
			(TDOrientation) orientation // Can be either `TDOrientationPortrait` or `TDOrientationLandscape
			(TDResolution) resolution // Can be `TDResolution1x`, `TDResolution2x` or `TDResolution3x`
			(TDAspectRatio) aspectRatio => 
				(int) width
				(int) height
			(NSURL) url
			(UIImage) image

You do not need to manually fetch the interstitial image, an object will only be made available to you once the 
interstitial is fully prepared to be presented to the user.

## Interstitial delegate methods

	// Called before interstitial is shown
	- (void)willDisplayInterstitial;

	// Called after interstitial is shown
	- (void)didDisplayInterstitial;

	// Called when interstitial is closed
	- (void)didCloseInterstitial;

	// Called when interstitial is clicked
	- (void)didClickInterstitial;

	// Called with an error occurs when requesting
	// interstitials from the Tapdaq servers
	- (void)didFailToLoadInterstitial;

	// Called when the request for interstitials was successful,
	// but no interstitials were found
	- (void)hasNoInterstitialsAvailable;

	// Called when the request for interstitials was successful
	// and 1 or more interstitials were found
	- (void)hasInterstitialsAvailableForOrientation:(TDOrientation)orientation;

## Fetching a native advert

### Updating the config

In order to fetch adverts, you need to add the advert type to the config, for example:

	NSMutableDictionary *tapdaqConfig = [[NSMutableDictionary alloc] init];
	
	...
	
	[tapdaqConfig setObject:@[ @"interstitialPortrait", @"nativeSquareLarge" ]
                     forKey:@"advertTypesEnabled"];

The possible values are as follows, and they are all of type NSString.

	interstitialPortrait
	interstitialLandscape
	nativeSquareLarge
	nativeSquareMedium
	nativeSquareSmall
	nativeNewsfeedPortraitLarge
	nativeNewsfeedPortraitMedium
	nativeNewsfeedPortraitSmall
	nativeNewsfeedLandscapeLarge
	nativeNewsfeedLandscapeMedium
	nativeNewsfeedLandscapeSmall
	nativeFullscreenPortraitLarge
	nativeFullscreenPortraitMedium
	nativeFullscreenPortraitSmall
	nativeFullscreenLandscapeLarge
	nativeFullscreenLandscapeMedium
	nativeFullscreenLandscapeSmall
	nativeStripPortraitLarge
	nativeStripPortraitMedium
	nativeStripPortraitSmall
	nativeStripLandscapeLarge
	nativeStripLandscapeMedium
	nativeStripLandscapeSmall

## Fetching the advert

To take full control over the adverts you wish to display to the user, you first need to fetch the advert.

	TDNativeAdvert *nativeAdvert = [[Tapdaq sharedSession] getNativeAdvertForAdUnit:TDNativeAdUnitSquare 
																			   size:TDNativeAdSizeLarge 
																	    orientation:TDOrientationUniversal];

The ad unit enum values are as follows:
	
	TDNativeAdUnitSquare
    TDNativeAdUnitNewsfeed
    TDNativeAdUnitFullscreen
    TDNativeAdUnitStrip

The ad size enum values are as follows:

	TDNativeAdSizeSmall
    TDNativeAdSizeMedium
    TDNativeAdSizeLarge

Finally, the orientation enum values are:

	TDOrientationPortrait,
    TDOrientationLandscape,
    TDOrientationUniversal

Note: `TDOrientationUniversal` is ONLY to be used with `TDNativeAdUnitSquare`.

THe native advert structure is as follows:

	(TDNativeAdvert) =>
		(NSString) applicationId
		(NSString) targetingId
		(NSString) subscriptionId // (optional) 
		(NSString) title
		(NSString) appName
		(NSString) appDescription
		(NSString) buttonText
		(NSString) developerName
		(NSString) ageRating
		(NSString) appSize
		(float) averageReview
		(int) totalReviews
		(NSString) category
		(NSString) appVersion
		(float) price
		(NSString) currency
		(TDNativeAdUnit) adUnit // Can be either `TDNativeAdUnitSquare`, `TDNativeAdUnitNewsfeed`, `TDNativeAdUnitFullscreen`, `TDNativeAdUnitStrip`
		(TDNativeAdSize) adSize // Can be either `TDNativeAdSizeSmall`, `TDNativeAdSizeMedium`, `TDNativeAdSizeLarge`
		(NSURL) iconUrl
		(UIImage) icon
		(NSURL) customUrl
		(BOOL) isBlockingInstalledApp
		(TDCreative) creative =>
			(NSString) identifier
			(TDOrientation) orientation // Can be either `TDOrientationPortrait` or `TDOrientationLandscape
			(TDResolution) resolution // Can be `TDResolution1x`, `TDResolution2x` or `TDResolution3x`
			(TDAspectRatio) aspectRatio => 
				(int) width
				(int) height
			(NSURL) url
			(UIImage) image

You do not need to manually fetch the native image or icon, an object will only be made available to you once the native is 
fully prepared to be presented to the user.

## Native advert delegate methods

	- (void)didFailToLoadNativeAdverts;

	- (void)hasNoNativeAdvertsAvailable;

	- (void)hasNativeAdvertsAvailableForAdUnit:(TDNativeAdUnit)adUnit
	                                      size:(TDNativeAdSize)adSize
	                               orientation:(TDOrientation)orientation;

## Advanced settings

#### Frequency Cap

By default the iOS SDK ships with advert frequency enabled, set to a max of 2 per day. If you would like to change these settings,
you can update the config dictionary like so: 

	[tapdaqConfig setObject:[NSNumber numberWithInt:1] forKey:@"frequencyCap"];
    [tapdaqConfig setObject:[NSNumber numberWithInt:7] forKey:@"frequencyDurationInDays"];

This example will change the frequency to 1 per week.


#### Ad Mediation Mode

Mediation mode allows you to have full control over when to fetch an advert from the Tapdaq servers.

To enable mediation mode, add the following to the config dictionary:

	[tapdaqConfig setObject:@YES forKey:@"mediationModeEnabled"];

One that is enabled, you can use the following method calls to load the advert:

	- (void)loadNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
                             size:(TDNativeAdSize)adSize
                      orientation:(TDOrientation)orientation;

    - (void)loadInterstitialAdvertForOrientation:(TDOrientation)orientation;

This will load the interstitial or native advert, which is sent to the TapdaqDelegate. The following methods are provided for you to handle
when an advert fails or is successfully loaded.

	- (void)didLoadNativeAdvert:(TDNativeAdvert *)advert
	                  forAdUnit:(TDNativeAdUnit)adUnit
	                       size:(TDNativeAdSize)adSize
	                orientation:(TDOrientation)orientation;

	- (void)didFailToLoadNativeAdvertForAdUnit:(TDNativeAdUnit)adUnit
	                                      size:(TDNativeAdSize)adSize
	                               orientation:(TDOrientation)orientation;


	- (void)didLoadInterstitial:(TDInterstitialAdvert *)advert forOrientation:(TDOrientation)orientation;

	- (void)didFailToLoadInterstitialForOrientation:(TDOrientation)orientation;

