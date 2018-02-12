/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    tapdaq: null,
    // Application Constructor
    initialize: function () {
        document.addEventListener('deviceready', this.onDeviceReady.bind(this), false);
    },

    // deviceready Event Handler
    //
    // Bind any cordova events here. Common events are:
    // 'pause', 'resume', etc.
    onDeviceReady: function () { 
        this.receivedEvent('deviceready');
        var loadedAds = [];

        this.tapdaq = Tapdaq = cordova.require("cordova-plugin-tapdaq.Tapdaq");
        var Ad = cordova.require("cordova-plugin-tapdaq.ads.Ad");
        var MoreAppsAd = cordova.require("cordova-plugin-tapdaq.ads.MoreAppsAd");  
        var NativeAd = cordova.require("cordova-plugin-tapdaq.ads.NativeAd");

        var options = {
            ios: {
                appId: "58d11456162f1b3998b7709b",
                //appId: "561254ec0e01158033582c46",
                clientKey: "3564a57a-9391-485b-ac01-83efea9b0599",
                testDevices: [
                    {
                        network: Tapdaq.AdNetworks.AdMob,
                        devices: [
                            "40f5f2f59358affc29312f7aa31f71a5a1252ee9",
                            "0f2a750934567997550226163c5891e0"
                        ]
                    },
                    {
                        network: Tapdaq.AdNetworks.FacebookAN,
                        devices: [
                            "40f5f2f59358affc29312f7aa31f71a5a1252ee9"
                        ]
                    }
                ] 
            },
            android: {
                appId: "58a1879f24e637002e48d4d5",
                clientKey: "3564a57a-9391-485b-ac01-83efea9b0599",
                testDevices: [
                    {
                        network: Tapdaq.AdNetworks.AdMob, 
                        devices: [
                             "40f5f2f59358affc29312f7aa31f71a5a1252ee9",
                             "0f2a750934567997550226163c5891e0"                            
                        ]
                    },{ 
                        network: Tapdaq.AdNetworks.FacebookAN, 
                        devices: [                            
                            "c9c3013e50b43a77c389b14ef797369e"
                        ]
                    }                    
                ]
                
            },
            enabledPlacements: [
                 {
                    adType: Ad.AdTypes.INTERSTITIAL,
                    tags: ["main_menu"]
                },{
                    adType: Ad.AdTypes.VIDEO,
                    tags: ["main_menu"]
                },{
                    adType: Ad.AdTypes.REWARDED_VIDEO,
                    tags: ["main_menu"]
                },{
                    adType: Ad.AdTypes.BANNER,
                    size: Ad.AdBannerSizes.STANDARD,
                    position: Ad.AdBannerPositions.BOTTOM,
                    tags: []
                },{
                    adType: Ad.AdTypes.OFFERWALL,
                    tags: ["default"]
                },{
                    adType: Ad.AdTypes.MORE_APPS,  
                    tags: ["tray-position-1", "tray-position-2", "tray-position-3", "tray-position-4", "tray-position-5", "tray-position-backfill"],                  
                    options: {
                        [MoreAppsAd.OptionNames.HeaderText]: "Some Header",
                        [MoreAppsAd.OptionNames.HeaderColor]: "#eeeeee",
                        [MoreAppsAd.OptionNames.HeaderTextColor]: "#ff0000",
                        [MoreAppsAd.OptionNames.AppButtonColor]: "#0000ee",
                    }
                },{
                    adType: NativeAd.AdTypes.AdType1x1Large,
                    tags: ["default"]
                }
            ],
            frequencyCap: 2,
            durationInDays: 1,
            debugMode: true,
			autoReload: true
        };

        var _this = this;
        $('.btn').prop("disabled", true);

        var initBtn = $("#init-sdk-btn");
        //var loadBtn = $("#load-ads-btn");
        
        var loadInterBtn = $("#load-interstitial-btn");
        var loadBannerBtn = $("#load-banner-btn");        
        var loadVideoBtn = $("#load-video-btn");
        var loadVideoRewardBtn = $("#load-video-reward-btn");
		var loadOfferwallBtn = $("#load-offerwall-btn");
        var loadMoreAppsBtn = $("#load-moreapps-btn");
        var loadNativeBtn = $("#load-native-btn");
        
        var showInterBtn = $("#show-interstitial-btn");
        var showBannerBtn = $("#show-banner-btn");
        var hideBannerBtn = $("#hide-banner-btn");
		var bannerSizeSelect = $("#banner-size-select");
		bannerSizeSelect.combobox();
		bannerSizeSelect.on("change", function(){
			showBannerBtn.prop("disabled", true);
			hideBannerBtn.prop("disabled", true);
		});
        var showVideoBtn = $("#show-video-btn");
        var showVideoRewardBtn = $("#show-video-reward-btn");
		var showOfferwallBtn = $("#show-offerwall-btn");
        var showMoreappsBtn = $("#show-moreapps-btn");
        var showNativeBtn = $("#show-native-btn");
        var mediationDebugBtn = $("#show-mediation-debug-btn");
        
        var toggleButton = function(adType, isEnabled) {
            var btn = null;

            console.log("adType: " + adType + ", isEnabled: " + isEnabled);

            switch (adType) {
                case Ad.AdTypes.INTERSTITIAL:
                    btn = showInterBtn;
                    break;
                case Ad.AdTypes.BANNER:
                    btn = showBannerBtn;
                    break;
                case Ad.AdTypes.VIDEO:
                    btn = showVideoBtn;
                    break;
                case Ad.AdTypes.REWARDED_VIDEO:
                    btn = showVideoRewardBtn;
                    break;
				case Ad.AdTypes.OFFERWALL:
                    btn = showOfferwallBtn;
                    break;
                case Ad.AdTypes.MORE_APPS:
                    btn = showMoreappsBtn;
                    break;
                default: btn = showNativeBtn;
            }

            btn.prop("disabled", !isEnabled);
        }

        var eventHandler = function (e) {
            var ad = e.target;
			console.log(e.type, e.target.getType());
            if (e.type == Ad.events.didLoad || 
                    e.type == Ad.events.didFailToLoad || 
                    e.type == Ad.events.didClose) {
                var toggleShowButton = e.type == Ad.events.didLoad;
                toggleButton(ad.getType(), toggleShowButton);
            }
        }

        // Handler for new Ad created callback
        var createdHandler = function (ad) {
            // new Ad created
            // check whether ad ready or not
            ad.isReady().then(function(res){
                console.log(ad.getType() + "- isReady? ", res);
            }).catch(function(err){
                console.warn(err);
            })

            // also here we can subscribe to some related events
            ad.on(Ad.events.didLoad, eventHandler);
             // also here we can subscribe to some related events
            ad.on(Ad.events.didFailToLoad, eventHandler);
            // also here we can subscribe to some related events
            ad.on(Ad.events.willDisplay, eventHandler);
            ad.on(Ad.events.didDisplay, eventHandler);
            ad.on(Ad.events.didClose, eventHandler);
            ad.on(Ad.events.didClick, eventHandler);
            ad.on(Ad.events.didVerify, eventHandler);
            ad.on(Ad.events.didRewardFail, eventHandler);
            ad.on(Ad.events.didComplete, eventHandler);

            var sizeOrOptions = null;
            if(ad.getType() == Ad.AdTypes.BANNER){
                sizeOrOptions = Ad.AdBannerSizes.STANDARD;
            }else  if(ad.getType() == Ad.AdTypes.MORE_APPS){                
                placement = options.enabledPlacements.find(function(placement){
                    return placement.adType == Ad.AdTypes.MORE_APPS;
                });
                sizeOrOptions = placement.options;
            }
            // load Ad
            ad.load(sizeOrOptions);
            // persist ads to enable/disable buttons
            loadedAds.push(ad);
            
            if(ad.getType() == Ad.AdTypes.NATIVE_AD){
               $(".close-btn").prop("disabled", false).on("click", function(){
                    ad.hide();
                }); 
            }
        };
        
        // init click events for buttons
        initBtn.on("click", function (e) {
            console.log("SDK initialization...");
            initBtn.prop("disabled", true);
            
            // init SDK
            Tapdaq.init(options).then(function () {

                // alternative way to subscribe to Ad's lifecicle events
                Tapdaq.on(Ad.events.didLoad, eventHandler);
                Tapdaq.on(Ad.events.didFailToLoad, eventHandler);
                Tapdaq.on(Ad.events.didClick, eventHandler);
                Tapdaq.on(Ad.events.didDisplay, eventHandler);
                Tapdaq.on(Ad.events.didClose, eventHandler);
                Tapdaq.on(Ad.events.didVerify, eventHandler);
                Tapdaq.on(Ad.events.didRewardFail, eventHandler);

                // all stuff is initialized and ready to load
                console.log("Tapdaq SDK is initialized and ready to load ads");
                $('.load-btn, .debug-btn').prop("disabled", false);
            });
        });
        initBtn.prop("disabled", false);
        

        // load AdTypeInterstitial
        loadInterBtn.on("click", function (e) {
            //Tapdaq.createAd(Ad.AdTypes.INTERSTITIAL).forTag("bootup").then(createdHandler);
            Tapdaq.loadAd(Ad.AdTypes.INTERSTITIAL, "main_menu"); // alternative way to load Ad
        });
        
        // load AdTypeBanner
        loadBannerBtn.on("click", function (e) {
            //Tapdaq.createAd(Ad.AdTypes.BANNER).forSize(Ad.AdBannerSizes.SMART).then(createdHandler);
			var size = bannerSizeSelect.val() || Ad.AdBannerSizes.STANDARD;
			console.log("Banner size: " + size);
            Tapdaq.loadAd(Ad.AdTypes.BANNER, Ad.AdBannerPositions.BOTTOM, size); // alternative way to load Ad
			
			showBannerBtn.prop("disabled", false);
			hideBannerBtn.prop("disabled", false);
        });
        // load AdTypeVideo
        loadVideoBtn.on("click", function (e) {
           // Tapdaq.createAd(Ad.AdTypes.VIDEO).forTag("main_menu").then(createdHandler);
           Tapdaq.loadAd(Ad.AdTypes.VIDEO, "main_menu"); // alternative way to load Ad
        });
        
        // load AdTypeVideoReward
        loadVideoRewardBtn.on("click", function (e) {
            //Tapdaq.createAd(Ad.AdTypes.REWARDED_VIDEO).forTag("bootup").then(createdHandler);
            Tapdaq.loadAd(Ad.AdTypes.REWARDED_VIDEO, "main_menu"); // alternative way to load Ad
        });
        
         // load AdTypeNative
        loadNativeBtn.on("click", function (e) {            
            // Example of usage of NativeAd
            var adContainer = document.querySelector(".native-ad-container");
            
            var nativeAdOptions = options.enabledPlacements[options.enabledPlacements.length - 1];
        
            Tapdaq.createNativeAd(nativeAdOptions.adType)
                .forTag(nativeAdOptions.tags[0])
                .withContainer(adContainer).then(createdHandler);
                
          /*  Tapdaq.loadAd(nativeAdOptions.adType, nativeAdOptions.tags[0], {
                container: adContainer,
                clickElement: clickBtn
            }); // alternative way to load Ad*/
        });
		
        
		 // load AdTypeOfferWall
        loadOfferwallBtn.on("click", function (e) {
            Tapdaq.createAd(Ad.AdTypes.OFFERWALL).then(createdHandler); // create offerwall Ad for default tag
            //Tapdaq.loadAd(Ad.AdTypes.OFFERWALL); // alternative way to load Ad
        });
		
          
		 // load AdTypeMoreApps
        loadMoreAppsBtn.on("click", function (e) {
           // Tapdaq.createAd(Ad.AdTypes.MORE_APPS).then(createdHandler); // create MoreApps Ad with default options, we can set options later, pass them to .load method
            
            var placement = options.enabledPlacements.find(function(placement){
                return placement.adType == Ad.AdTypes.MORE_APPS;
            });
            var opts = placement.options;
            Tapdaq.loadAd(Ad.AdTypes.MORE_APPS, opts); // alternative way to load Ad
        });
        
        mediationDebugBtn.on("click", function(e){
            e.preventDefault();
            Tapdaq.showDebugPanel();
        });
        
        showInterBtn.on("click", function (e) {
            Tapdaq.showAd(Ad.AdTypes.INTERSTITIAL, "main_menu"); // if ad hasn't loaded yet then didFailToLoad event will be triggered
            
           /* loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.INTERSTITIAL) {
                    ad.show();
                    showInterBtn.prop("disabled", true);
                }
            })*/
        });
        showBannerBtn.on("click", function (e) {
             Tapdaq.showAd(Ad.AdTypes.BANNER, Ad.AdBannerPositions.BOTTOM);
              $(showBannerBtn).addClass("hidden");
              $(hideBannerBtn).removeClass("hidden");
              $(hideBannerBtn).prop("disabled", false);
            /*loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.BANNER) {
                    ad.show();
                    $(showBannerBtn).addClass("hidden");
                    $(hideBannerBtn).removeClass("hidden");
                    $(hideBannerBtn).prop("disabled", false);
                }
            })*/
        });
        hideBannerBtn.on("click", function (e) {
             Tapdaq.hideBanner(Ad.AdBannerPositions.BOTTOM);
             $(showBannerBtn).removeClass("hidden");
             $(hideBannerBtn).addClass("hidden");
            /*loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.BANNER) {
                    ad.hide();
                    $(showBannerBtn).removeClass("hidden");
                    $(hideBannerBtn).addClass("hidden");
                }
            })*/
        });
        showVideoBtn.on("click", function (e) {
            Tapdaq.showAd(Ad.AdTypes.VIDEO, "main_menu");
           /* loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.VIDEO) {
                    ad.show();
                    showVideoBtn.prop("disabled", true);
                }
            })*/
        });
        showVideoRewardBtn.on("click", function (e) {
            Tapdaq.showAd(Ad.AdTypes.REWARDED_VIDEO, "main_menu");
            /*loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.REWARDED_VIDEO) {
                    ad.show();
                    showVideoRewardBtn.prop("disabled", true);
                }
            })*/
        });
		showOfferwallBtn.on("click", function (e) {
           // Tapdaq.showAd(Ad.AdTypes.OFFERWALL);
            loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.OFFERWALL) {
                    ad.show();
                    showOfferwallBtn.prop("disabled", true);
                }
              });
        });
        
        showMoreappsBtn.on("click", function (e) {
            var ad = Tapdaq.showAd(Ad.AdTypes.MORE_APPS);
            ad.on(Ad.events.didDisplay, function(){
                showMoreappsBtn.prop("disabled", true);
            })
            /*loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.MORE_APPS) {
                    ad.show();
                    showMoreappsBtn.prop("disabled", true);
                }
              });*/
        });
        
        showNativeBtn.on("click", function (e) {
           var nativeAdOptions = options.enabledPlacements[options.enabledPlacements.length - 1];
        
            loadedAds.forEach(function (ad) {
                if (ad.getType() == Ad.AdTypes.NATIVE_AD) {
                    ad.show();
                    showNativeBtn.prop("disabled", true);
                }
              });
              //Tapdaq.showAd(nativeAdOptions.adType, nativeAdOptions.tags[0]);// alternative way
        });
        
        

    },

    // Update DOM on a Received Event
    receivedEvent: function (id) {
        console.log('Received Event: ' + id);
    }
};

app.initialize();
