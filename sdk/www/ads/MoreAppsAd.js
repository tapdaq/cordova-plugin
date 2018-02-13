(function(){
    'use strict';

    var EventsBus = require("cordova-plugin-tapdaq.EventsBus");
    var Ad = require("cordova-plugin-tapdaq.ads.Ad");
    var Promise = require("cordova-plugin-tapdaq.Promise");
    var exec = require("cordova/exec");

    var MoreAppsAd = function(adType, options) {        
        Ad.call(this, adType, "default");
        this._options = options || {};       
    };
    
    MoreAppsAd.prototype = Object.create(Ad.prototype);
    MoreAppsAd.prototype.constructor = MoreAppsAd;
    
    MoreAppsAd.OptionNames = {
        PlacementTagPrefix: "placementTagPrefix",
        HeaderText: "headerText",
        InstalledButtonText: "installedButtonText",
        HeaderTextColor: "headerTextColor",
        HeaderColor: "headerColor",
        HeaderCloseButtonColor: "headerCloseButtonColor",
        BackgroundColor: "backgroundColor",
        AppNameColor: "appNameColor",
        AppButtonColor: "appButtonColor",
        AppButtonTextColor: "appButtonTextColor",
        InstalledAppButtonTextColor: "installedAppButtonColor",
        InstalledAppButtonColor: "installedAppButtonTextColor",
        InstalledAppButtonText: "installedAppButtonText",
        MinAdsToDisplay: "minAdsToDisplay", 
        MaxAdsToDisplay: "maxAdsToDisplay",
    };
    
    MoreAppsAd.prototype.getOptions = function(){
        return this._options;
    }

    MoreAppsAd.prototype.setOptions = function(options){
        this._options = options;
    }
    
     MoreAppsAd.prototype.load = function(options){
        var _this = this;
        options = options || this._options;
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
            [{adType: _this.getType(), tag: _this.getTag(), options: options}]
        );
    };

    module.exports = MoreAppsAd;
})();