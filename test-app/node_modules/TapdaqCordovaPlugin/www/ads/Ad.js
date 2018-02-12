(function(){
    'use strict';

    var EventsBus = require("cordova-plugin-tapdaq.EventsBus");
    var Promise = require("cordova-plugin-tapdaq.Promise");
    var exec = require("cordova/exec");

    var Ad = function(adType, tag, position) {

        this.adType = adType;
        tag = tag || "default";
        this.tag = tag;
		
        if (adType === Ad.AdTypes.BANNER && 
                typeof position === 'undefined' && 
                [Ad.AdBannerPositions.BOTTOM, Ad.AdBannerPositions.TOP].indexOf(tag) !== -1) {
			position = tag;
		} else {
			position = position || Ad.AdBannerPositions.BOTTOM;			
        }

        this.position = position;

    };


    Ad.prototype.on = function(type, callback) {
        EventsBus.off(type, callback, this);
        EventsBus.on(type, callback, this);
    };

    Ad.prototype.once = function(type, callback) {
        EventsBus.once(type, callback, this);
    };

    Ad.prototype.off = function(type, callback) {
        EventsBus.off(type, callback, this);
    };

    Ad.prototype.getHash = function() {
        var hash = this.getType() + "-" + (this.getType() === Ad.AdTypes.BANNER ? "" : this.getTag());

        return hash;
    };

    Ad.events = {
        didClose: "didClose",
        didClick: "didClick",
        willDisplay: "willDisplay",
        didDisplay: "didDisplay",
        didLoad: "didLoad",
        didFailToLoad: "didFailToLoad",
        onUserDeclined: "onUserDeclined",
        didRewardFail: "didRewardFail",        
        didVerify: "didVerify",
        didEngagement: "didEngagement",
        didComplete: "didComplete",
        didCustomEvent: "didCustomEvent"
    };

    Ad.AdTypes = {
        INTERSTITIAL: "AdTypeInterstitial",
        VIDEO: "AdTypeVideo",
        REWARDED_VIDEO: "AdTypeRewardedVideo",
        BANNER: "AdTypeBanner", 
        OFFERWALL: "AdTypeOfferwall",
        MORE_APPS: "AdTypeMoreApps",
        NATIVE_AD: "AdTypeNative"
    };

    Ad.AdBannerSizes = {
        STANDARD: "STANDARD",
        LARGE: "LARGE",
        MEDIUM_RECT: "MEDIUM_RECT",
        FULL: "FULL",
        LEADERBOARD: "LEADERBOARD",
        SMART: "SMART"
    };

    Ad.AdBannerPositions = {
       TOP: "top",
       BOTTOM: "bottom"
    };

    /**
     *
     * @returns {string}
     */
    Ad.prototype.getType = function() {
        return this.adType;
    };

    /**
     *
     * @returns {string}
     */
    Ad.prototype.getTag = function(){
        return this.tag;
    };

    Ad.prototype.getPosition = function(){
        return this.position;
    };

    Ad.prototype.load = function(size){
        var _this = this;
        size = size || null;
        exec(
            function(data) {
                if (data && data.event) {
                    EventsBus.dispatchEvent(data.event, data.eventData);
                }else{
                    //console.warn("Invalid response in Ad.load callback", data);
                }
            },
            function(error) {
                console.error(error);
            },
            "Tapdaq",
            "load",
            [{adType: _this.getType(), tag: _this.getTag(), size: size}]
        );
    };

    /**
     * Will trigger related events like "willDisplay", "didDisplay" etc.
     *
     * @return void
     */
    Ad.prototype.show = function() {
        var _this = this;
        var position = this.position;
        var tag = _this.tag;

        exec(
            function(data) {
                if (data && data.event) {
                    EventsBus.dispatchEvent(data.event, data.eventData);
                } else {
                    //console.warn("Invalid response in Ad.show callback", data);
                }
            },
            function (error) {
                reject(error);
            },
            "Tapdaq",
            "show",
            [{adType: _this.adType, tag: tag, position: position}]
        );
    };

   Ad.prototype.hide = function() {
		var _this = this;
	   if(_this.adType === Ad.AdTypes.BANNER) {
			exec(
				function(data) {
                    if (data && data.event) {
                        EventsBus.dispatchEvent(data.event, data.eventData);
                    } else {
                        //console.warn("Invalid response in Ad.hide callback", data);
                    }
				},
				function(error) {
					console.error(error);
				},
				"Tapdaq",
				"hide",
				[{adType: _this.adType}]
			);
		}else{
			console.log("Ad::hide available only for AdTypeBanner");
	   }
	};

    /**
     *
     * @returns {Promise}
     */
   Ad.prototype.isReady = function(){
       var _this = this;
       return new Promise(function(resolve, reject) {
           var options = {
               adType: _this.adType,
               tag: _this.tag
           };
           exec(
               function(data) {
                   resolve(data);
               },
               function(error) {
                   reject(error);
               },
               "Tapdaq",
               "isReady",
               [options]
           );
       });
   };

    module.exports = Ad;
})();