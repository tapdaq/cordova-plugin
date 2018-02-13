#import <Cordova/CDV.h>
#import <Tapdaq/Tapdaq.h>
#import <Foundation/Foundation.h>

@import AdSupport;
@import AVFoundation;
@import AVKit;
@import AudioToolbox;
@import CoreData;
@import CoreGraphics;
@import CoreMedia;
@import CoreMotion;
@import CoreTelephony;
@import EventKit;
@import EventKitUI;
@import Foundation;
@import GLKit;
@import QuartzCore;
@import MediaPlayer;
@import MediaToolbox;
@import MessageUI;
@import MobileCoreServices;
@import SafariServices;
@import Social;
@import StoreKit;
@import SystemConfiguration;
@import UIKit;
@import WebKit;

@interface CDVTapdaq : CDVPlugin <TapdaqDelegate> {
    // Member variables go here.
}

@property NSString *callbackId;
@property TDProperties *properties;
@property NSDictionary *validAdTypes;
@property NSDictionary *nativeAdTypes;
@property UIView *bannerView;
@property NSMutableDictionary *nativeAds;
@property bool isDebug;
@property bool autoReload;

- (void)init:(CDVInvokedUrlCommand*)command;

- (void)load:(CDVInvokedUrlCommand*)command;

- (void)show:(CDVInvokedUrlCommand*)command;

- (void)hide:(CDVInvokedUrlCommand*)command;

- (void)triggerNativeAdImpression: (CDVInvokedUrlCommand*)command;

- (void)triggerNativeAdClick: (CDVInvokedUrlCommand*)command;

- (void)isReady:(CDVInvokedUrlCommand*)command;

- (void)showDebugPanel:(CDVInvokedUrlCommand*)command;

@end

