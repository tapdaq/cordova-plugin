# Tapdaq Cordova Plugin

Tapdaq's official plugin for Apache Cordova.

## Installation

    cordova plugin add https://github.com/tapdaq/cordova-plugin 
    
## Quickstart
    
To get started, sign up to Tapdaq and add your application. 
You will then be given an `appId` and `clientKey` under the app settings.
    
Once you have got those, add the following:
    
    Tapdaq.setOptions({ 
      testAdvertsEnabled: true # Set to false when submitting to the app store!
    });

    Tapdaq.init("YOUR_APP_ID", "YOUR_CLIENT_KEY");
    
Replace `YOUR_APP_ID` and `YOUR_CLIENT_KEY` with your real details.

## Display an interstitial

To get the most out of the Tapdaq community, we recommend you display an interstitial, like so:

    Tapdaq.showInterstitial();
    
## Additional settings

The config object passed to `Tapdaq.setOptions()` contains the following options:

    {
        testAdvertsEnabled: true|false, # sets the SDK to test mode, must be set to false when app is released
        trackInstallsOnly: true|false, # turns off ad fetching, adverts will not display
        orientation: "universal|portrait|landscape" # forces an orientation in the SDK
    }
        
### Example

The following sets Tapdaq to test mode and forces the orientation to portrait.
    
    Tapdaq.setOptions({
        testAdvertsEnabled: true,
        orientation: "portrait"
    });
