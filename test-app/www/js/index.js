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

        var placementTagField = $('#placement-tag-field');
        var placementTag = placementTagField.val(); 
        placementTagField.on('change', function() {
            placementTag = $(this).val();
        });

        var placementTagForm = $('#placement-tag-form');
        placementTagForm.on('submit', function(e) {
            e.preventDefault();
        });

        var bannerPositionOptions = $('#bannerPositionMenu ul li a');
        var bannerPosition = "";
        bannerPositionOptions.on('click', function(e) {
            e.preventDefault();
            bannerPosition = $(this).data('value');
        });

        var bannerSizeOptions = $('#bannerSizeMenu ul li a');
        var bannerSize = "";
        bannerSizeOptions.on('click', function(e) {
            e.preventDefault();
            bannerSize = $(this).data('value');
        });

        var bannerWidthField = $('#banner-width');
        var bannerWidth = bannerWidthField.val();
        bannerWidthField.on('change', function() {
            bannerWidth = parseFloat($(this).val());
        })

        var bannerHeightField = $('#banner-height');
        var bannerHeight = bannerHeightField.val();
        bannerHeightField.on('change', function() {
            bannerHeight = parseFloat($(this).val());
        })

        var bannerXField = $('#banner-x');
        var bannerX = bannerXField.val();
        bannerXField.on('change', function() {
            bannerX = parseFloat($(this).val());
        })

        var bannerYField = $('#banner-y');
        var bannerY = bannerYField.val();
        bannerYField.on('change', function() {
            bannerY = parseFloat($(this).val());
        })

        const Tapdaq = cordova.require("cordova-plugin-tapdaq.Tapdaq");

        // Tapdaq.setUserSubjectToGDPR(Tapdaq.Status.TRUE);
        // Tapdaq.setConsent(Tapdaq.Status.TRUE);
        // Tapdaq.setAgeRestrictedUser(Tapdaq.Status.FALSE);
        // Tapdaq.setAdMobContentRating("MA");
        // Tapdaq.setUserSubjectToUSPrivacy(Tapdaq.Status.TRUE);
        // Tapdaq.setUSPrivacy(Tapdaq.Status.TRUE);
        // Tapdaq.setAdvertiserTracking(Tapdaq.Status.FALSE);
        // Tapdaq.setMuted(true);
        //
        // Tapdaq.setForwardUserId(true);
        // Tapdaq.setUserId("Cordova User");

       // Tapdaq.setUserDataBoolean("test_boolean", true);
       // Tapdaq.setUserDataInteger("test_integer", 5);
       // Tapdaq.setUserDataString("test_string", "hello world");
       // Tapdaq.setUserDataInteger("test_integer_remove", false);

        // Tapdaq.userSubjectToGDPRStatus(function (status) {
        //     console.log("userSubjectToGDPRStatus: " + status);
        // });
        //
        // Tapdaq.consentStatus(function (status) {
        //     console.log("consentStatus: " + status);
        // });
        //
        // Tapdaq.ageRestrictedUserStatus(function (status) {
        //     console.log("ageRestrictedUserStatus: " + status);
        // });
        //
        // Tapdaq.userSubjectToUSPrivacyStatus(function (status) {
        //     console.log("userSubjectToUSPrivacyStatus: " + status);
        // });
        //
        // Tapdaq.usPrivacyStatus(function (status) {
        //     console.log("usPrivacyStatus: " + status);
        // });
        //
        // Tapdaq.advertiserTracking(function (status) {
        //     console.log("advertiserTracking: " + status);
        // });
        //
        // Tapdaq.adMobContentRating(function (status) {
        //     console.log("adMobContentRating: " + status);
        // });
        //
        // Tapdaq.muted(function (status) {
        //     console.log("muted: " + status);
        // });
        //
        // Tapdaq.forwardUserId(function (status) {
        //     console.log("forwardUserId: " + status);
        // });
        //
        // Tapdaq.userId(function (status) {
        //     console.log("userId: " + status);
        // });
        //
        // Tapdaq.userDataBoolean("test_boolean", function(value) {
        //     console.log("UserDataBoolean: " + value);
        // });
        //
        // Tapdaq.userDataInteger("test_integer", function(value) {
        //     console.log("UserDataInteger: " + value);
        // });
        //
        // Tapdaq.userDataString("test_string", function(value) {
        //     console.log("UserDataString: " + value);
        // });
        //
        // Tapdaq.removeUserData("test_integer_remove");
        //
        // Tapdaq.allUserData(function(value) {
        //     console.log("AllUserData: " + JSON.stringify(value));
        // });
        //
        // Tapdaq.networkStatuses(function(value) {
        //     console.log("Network Statuses: " + JSON.stringify(value));
        // });

        var config = {
            ios: {
                appId: "<iOS_APP_ID>",
                clientKey: "<IOS_CLIENT_KEY>",
                testDevices: [
                    {
                        network: Tapdaq.AdNetwork.AdMob,
                        devices: [
                            "<ADMOB_TEST_DEVICE_ID>"
                        ]
                    },
                    {
                        network: Tapdaq.AdNetwork.FacebookAN,
                        devices: [
                            "<FAN_TEST_DEVICE_ID>"
                        ]
                    }
                ] 
            },
            android: {
                appId: "ANDROID_APP_ID",
                clientKey: "ANDROID_CLIENT_KEY",
                testDevices: [
                    {
                        network: Tapdaq.AdNetwork.AdMob,
                        devices: [
                            "ADMOB_TEST_DEVICE_ID"
                        ]
                    },
                    {
                        network: Tapdaq.AdNetwork.FacebookAN,
                        devices: [
                            "FAN_TEST_DEVICE_ID"
                        ]
                    }
                ]
            },
            logLevel: Tapdaq.LogLevel.Debug
            // userId:"Demo User",
            // forwardUserId:false,
            // userSubjectToGDPR:Tapdaq.Status.UNKNOWN,
            // isConsentGiven:Tapdaq.Status.FALSE,
            // isAgeRestrictedUser: Tapdaq.Status.TRUE,
            // userSubjectToUSPrivacy: Tapdaq.Status.FALSE,
            // usPrivacy: Tapdaq.Status.FALSE,
            // advertiserTracking:Tapdaq.Status.TRUE
            // adMobContentRating: Tapdaq.AdMobContentRating.G,
            // muted:false
        };
        
        const loadOpts = {
            didLoad: function (response) {
                console.log('didLoad: ' + JSON.stringify(response));
            },
            didFailToLoad: function (error, response) {
                console.log('didFailToLoad: error: ' + JSON.stringify(error) + ', response: ' + JSON.stringify(response));
            }
        }
        const showOpts = {
            willDisplay: function(response) {
                console.log('willDisplay: ' + JSON.stringify(response));
            },
            didDisplay: function(response) {
                console.log('didDisplay: ' + JSON.stringify(response));
            },
            didFailToDisplay: function(error, response) {
                console.log('didFailToDisplay: error: ' + JSON.stringify(error) + ', response: ' + JSON.stringify(response));
            },
            didClose: function(response) {
                console.log('didClose: ' + JSON.stringify(response));
            },
            didClick: function(response) {
                console.log('didClick: ' + JSON.stringify(response));
            }, 
            didValidateReward: function(response) {
                console.log('didValidateReward: ' + JSON.stringify(response));
            }
        };
        const bannerOpts = {
            didLoad: function (response) {
                console.log('didLoad: ' + JSON.stringify(response));
            },
            didFailToLoad: function (error, response) {
                console.log('didFailToLoad: error: ' + JSON.stringify(error) + ', response: ' + JSON.stringify(response));
            },
            didRefresh: function (response) {
                console.log('didRefresh: ' + JSON.stringify(response));
            },
            didFailToRefresh: function (error, response) {
                console.log('didFailToRefresh: error: ' + JSON.stringify(error) + ', response: ' + JSON.stringify(response));
            },
            didClick: function(response) {
                console.log('didClick: ' + JSON.stringify(response));
            }
        }

        var allBtns = $('.btn');
        allBtns.prop("disabled", true);

        var initBtn = $("#init-sdk-btn");
        
        var loadInterBtn = $("#load-interstitial-btn");
        var loadVideoBtn = $("#load-video-btn");
        var loadVideoRewardBtn = $("#load-video-reward-btn");
        var loadBannerBtn = $('#load-banner-btn');
        
        var showInterBtn = $("#show-interstitial-btn");
        var showVideoBtn = $("#show-video-btn");
        var showVideoRewardBtn = $("#show-video-reward-btn");
        var showBannerBtn = $('#show-banner-btn');

        var hideBannerBtn = $('#hide-banner-btn');
        var destroyBannerBtn = $('#destroy-banner-btn');

        var mediationDebugBtn = $("#show-mediation-debug-btn");

        
        // init click events for buttons
        initBtn.on("click", function(e) {
            e.preventDefault();

            initBtn.prop("disabled", true);
            
            // init SDK

            var opts = {
                didInitialise: function() {
                    console.log('cb: didInitialise');
                    allBtns.prop("disabled", false);

                    // Tapdaq.networkStatuses(function(value) {
                    //     console.log("Network Statuses: " + JSON.stringify(value));
                    // });
                },
                didFailToInitialise: function(error) {
                    console.log('cb: didFailToInitialise: ' + JSON.stringify(error));
                }
            };

            Tapdaq.init(config, opts);
        });

        initBtn.prop("disabled", false);
        mediationDebugBtn.prop("disabled", false);
        
        // Interstitial

        loadInterBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.loadInterstitial(placementTag, loadOpts);
        });

        showInterBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.getInterstitialFrequencyError(placementTag, function (e) {
                console.log("IntersitialFrequencyCap - " + placementTag + " - " + JSON.stringify(e));
            });

            Tapdaq.isInterstitialReady(placementTag, function (e) {
               console.log("isInterstitialReady - " + placementTag + " - " + e);
            });
            Tapdaq.showInterstitial(placementTag, showOpts);
        });

        // Video
        
        loadVideoBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.loadVideo(placementTag, loadOpts);
        });

        showVideoBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.getVideoFrequencyError(placementTag, function (e) {
                console.log("VideoFrequencyCap - " + placementTag + " - " + JSON.stringify(e));
            });

            Tapdaq.isVideoReady(placementTag, function (e) {
                console.log("isVideoReady - " + placementTag + " - " + e);
            });
            Tapdaq.showVideo(placementTag, showOpts);
        });
        
        // Rewarded Video

        loadVideoRewardBtn.on("click", function(e) {
            e.preventDefault();

            Tapdaq.loadRewardedVideo(placementTag, loadOpts);
        });
        
        showVideoRewardBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.getRewardedVideoFrequencyError(placementTag, function (e) {
                console.log("RewardedVideoFrequencyCap - " + placementTag + " - " + JSON.stringify(e));
            });

            Tapdaq.isRewardedVideoReady(placementTag, function (e) {
                console.log("isRewardedVideoReady - " + placementTag + " - " + e);
            });
            Tapdaq.showRewardedVideo(placementTag, showOpts);
        });

        // Banner

        loadBannerBtn.on("click", function(e) {
            e.preventDefault();

            if (bannerSize === "custom") {
                const customSize = { width: bannerWidth, height: bannerHeight };
                Tapdaq.loadBanner(placementTag, customSize, bannerOpts);
            } else {
                Tapdaq.loadBanner(placementTag, bannerSize, bannerOpts);
            }
        });

        showBannerBtn.on("click", function(e) {
            e.preventDefault();

            Tapdaq.isBannerReady(placementTag, function (e) {
                console.log("isBannerReady - " + placementTag + " - " + e);
            });

            if (bannerPosition === "custom") {
                const customPosition = { x: bannerX, y: bannerY };
                Tapdaq.showBanner(placementTag, customPosition);
            } else {
                Tapdaq.showBanner(placementTag, bannerPosition);
            }

        });

        hideBannerBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.hideBanner(placementTag);
        });

        destroyBannerBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.destroyBanner(placementTag);
        })

        mediationDebugBtn.on("click", function(e) {
            e.preventDefault();
            Tapdaq.launchDebugger();


        });

        //IDFA Request
        const idfaPlugin = cordova.plugins.idfa;

        idfaPlugin.getInfo()
            .then(function(info) {
                    if (!info.trackingLimited) {
                        return info.idfa || info.aaid;
                    } else if (info.trackingPermission === idfaPlugin.TRACKING_PERMISSION_NOT_DETERMINED) {
                        return idfaPlugin.requestPermission().then(function(result) {
                            if (result === idfaPlugin.TRACKING_PERMISSION_AUTHORIZED) {
                                return idfaPlugin.getInfo().then(function(info) {
                                    return info.idfa || info.aaid;
                                });
                            }
                        });
                    }
            })
            .then(function(idfaOrAaid){
                if (idfaOrAaid) {
                    console.log(idfaOrAaid);
                }
            });
    },

    // Update DOM on a Received Event
    receivedEvent: function (id) {
        console.log('Received Event: ' + id);


    }
};

app.initialize();



$('.dropdown ul li a').on('click', function(e) {
    e.preventDefault();
    const optionText = $(this).text();
    
    const button = $(this).closest('.dropdown').find('.dropdown-toggle');
    if (button.length) {
        button.html(optionText + ' <span class="caret"></span>');
    } 

    const customInputs = $('.' + button.data('customtag'));
    customInputs.prop('disabled', optionText !== 'Custom');
});
