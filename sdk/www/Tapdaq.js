(function () {
    'use strict';

    var exec = require("cordova/exec");
    var EventsBus = require("cordova-plugin-tapdaq.EventsBus");
    var Promise = require("cordova-plugin-tapdaq.Promise");
    var Ad = require("cordova-plugin-tapdaq.ads.Ad");
    var MoreAppsAd = require("cordova-plugin-tapdaq.ads.MoreAppsAd");
    var NativeAd = require("cordova-plugin-tapdaq.ads.NativeAd");

   
    var handleAdEvent = function(event){
        this._dispatchEvent(event.type, event.data, event.target);
    };
    var loadedAds = {};

    var Tapdaq = function () {

        /**
         *
         * @type {Array} enabledPlacements
         * [{adType: "interstitial", tags: []}, {adType: "banner", tags: []}]
         */

        this.enabledPlacements = [];
        this.enabledAds = [];

    };

    Tapdaq.events = Tapdaq.prototype.events = {
        didInitialise: "didInitialise"
    };
    
    Tapdaq.prototype.AdNetworks = {
        AdMob: "AdMob",
        FacebookAN: "Facebook",
        AdColony: "AdColony",
        AppLovin: "AppLovin",
        UnityAds: "UnityAds",
        HyprMX: "HyprMX",
        Tapjoy: "Tapjoy",
        Chartboost: "Chartboost",
        InMobi: "InMobi",
        IronSource: "IronSource",
        Vungle: "Vungle"
    }
	
    Tapdaq.prototype._listeners = {};

    Tapdaq.prototype._dispatchEvent = function(type, data, target) {
        var event = {
            type: type,
            target: target, 
            data: data
        };
        var args = [];
        var numOfArgs = arguments.length;
        for(var i=0; i<numOfArgs; i++){
            args.push(arguments[i]);
        }
        args = args.length > 2 ? args.splice(2, args.length-1) : [];
        args = [event].concat(args);


        if(typeof this._listeners[type] != "undefined") {
            var listeners = this._listeners[type].slice();
            var numOfCallbacks = listeners.length;
            for(var i=0; i<numOfCallbacks; i++) {
                var listener = listeners[i];
                if(listener && listener.callback) {
                    var concatArgs = args.concat(listener.args);
                    listener.callback.apply(listener.scope, concatArgs);
                }
            }
        }
    };

    Tapdaq.prototype.on = function(type, callback, scope){
        var args = [];
        scope = scope || this;
        var numOfArgs = arguments.length;
        for(var i=0; i<numOfArgs; i++){
            args.push(arguments[i]);
        }
        args = args.length > 3 ? args.splice(3, args.length-1) : [];
        if(typeof this._listeners[type] != "undefined") {
            this._listeners[type].push({scope:scope, callback:callback, args:args});
        } else {
            this._listeners[type] = [{scope:scope, callback:callback, args:args}];
        }
    };

    Tapdaq.prototype.once = function (event, callback, scope) {
        var _this = this;
        scope = scope || _this;
        (function(event){
            var h = function(){
                _this.off(event, h, scope);
                callback.apply(this, arguments);
            };
            _this.on(event, h, scope);
        })(event);
    };

    Tapdaq.prototype.off = function(type, callback, scope){
        scope = scope || this;
        if(typeof this._listeners[type] != "undefined") {
            var numOfCallbacks = this._listeners[type].length;
            var newArray = [];
            for(var i=0; i<numOfCallbacks; i++) {
                var listener = this._listeners[type][i];
                if(listener.scope == scope && listener.callback == callback) {

                } else {
                    newArray.push(listener);
                }
            }
            this._listeners[type] = newArray;
        }
    };

    Tapdaq.prototype.getHash = function(){
        return "";
    };

    /**
     * Init SDK
     * @param {object} options
     */
    Tapdaq.prototype.init = function (options) {
        this.enabledPlacements = typeof options.enabledPlacements  !== 'undefined' ? options.enabledPlacements : [];        
        this.enabledAds = [];
        var _this = this;
        this.enabledPlacements.forEach(function(placement, i){
            var tags = typeof placement.tags !== "undefined" ? placement.tags : [];
            if(tags.length === 0){
                tags.push("default");
            }
            _this.enabledPlacements[i].tags = tags;
            var adType = typeof placement.adType !== "undefined" ? placement.adType : Ad.AdTypes.INTERSTITIAL;
            var position = typeof placement.position !== "undefined" ? placement.position : Ad.AdBannerPositions.BOTTOM; // for Banners
            tags.forEach(function(tag){
                var ad = new Ad(adType, tag, position);
                _this.enabledAds.push(ad);
            });
        });

        return new Promise(function (resolve, reject) {
            EventsBus.once(Tapdaq.events.didInitialise, function(e){
                _this._dispatchEvent(Tapdaq.events.didInitialise, e.data, _this);
                resolve(e);
            }, _this);
            // call init method to initialize SDK
            exec(
                function(result){
                    if(result && result.event) {
                        EventsBus.dispatchEvent(result.event, result.eventData);
                    }else{
                       // console.warn("Invalid response in Tapdaq.init callback", result);
                    }
                },
                function (error) {
                    reject(error);
                },
                "Tapdaq",
                "init",
                [options]
            );
        });
    };


    /**
     * Start mediation debug activity SDK
     * @param {object} options
     */
    Tapdaq.prototype.showDebugPanel = function(){
        exec(
            function(resp){
                console.log(resp)
            },
            function (error) {
                console.error(error);
            },
            "Tapdaq",
            "showDebugPanel",
            null
        );
    };
    
	/**
    * @param {string} adType
	* @returns {function} forTag|forPosition
	**/
	Tapdaq.prototype.createAd = function(adType){
		/**
		* @returns {Promise} promise for loaded Ad
        **/		
		var forTag = function(tag){
			return new Promise(function(resolve, reject){
                var ad = new Ad(adType, tag);
                resolve(ad);
            });
		};	
		var forPosition = function(position){
            return new Promise(function(resolve, reject){
                if(adType === Ad.AdTypes.BANNER){
                    var ad = new Ad(adType, position);
                    resolve(ad);
                }else{
                    reject("method forSize can be called only for " + Ad.AdTypes.BANNER);
                }
            });

		};	
        
        var forDefaultTag =  function(){
            return new Promise(function(resolve, reject){
                 forTag.call(_this, null).then(function(data){
                    resolve(data);
                 });  
            });                
        }   
        
        var withOptions =  function(options){
            return new Promise(function(resolve, reject){
                if(adType === Ad.AdTypes.MORE_APPS){
                    var ad = new MoreAppsAd(adType, options);
                    resolve(ad);                   
                }else{
                    reject("method withOptions can be called only for " + Ad.AdTypes.MORE_APPS);
                }
            });                
        }     
        
        var _this = this;
      	
		return {
			forTag: forTag,
            forPosition: forPosition,
            forDefaultTag: forDefaultTag,
            withOptions: withOptions,
            then: function(){
                var promise;
                if(adType === Ad.AdTypes.MORE_APPS){
                    promise = withOptions(null);
                }else{
                    promise = forDefaultTag();
                }
                return promise.then.apply(promise, [].slice.call(arguments));
            }       
		};
	};
	
		/**
    * @param {string} adType
	* @param {string} tagOrPosition	- position is for banners
    * @returns {Ad}
	**/
	Tapdaq.prototype.showAd = function(adType, tagOrPosition){		
		var ad;
        var hashKey = adType + "-" + tagOrPosition;
        if(loadedAds[hashKey] !== undefined){
            ad = loadedAds[hashKey];
        }else{
            ad = new Ad(adType, tagOrPosition);
        }
		ad.show();
        return ad;
	};

    /**
     * @param {string} adType
     * @param {string} tagOrPositionOrContainer	- tag|position is for banners
     * @param {string} sizeOrOptions - size for banners| options for nativeAd
     * @returns {Ad}
     **/
    Tapdaq.prototype.loadAd = function(adType, tagOrPosition, sizeOrOptions){
        var ad, 
        hashKey,
        size;
        
        var nativeAdTypes = Object.keys(NativeAd.AdTypes).map(function(key){
            return NativeAd.AdTypes[key];
        });
        
        if(nativeAdTypes.indexOf(adType) !== -1){
            var container = sizeOrOptions && sizeOrOptions.container !== undefined ? sizeOrOptions.container : null;
            var clickElement = sizeOrOptions && sizeOrOptions.clickElement !== undefined ? sizeOrOptions.clickElement : null;
            var options = {
                adType: Ad.AdTypes.NATIVE_AD,
                nativeAdType: adType,
                tag: tagOrPosition,
                container: container,
                clickAreaElement: clickElement
            };
            ad = new NativeAd(options);            
        }else if(adType == Ad.AdTypes.MORE_APPS){
            ad = new MoreAppsAd(adType, tagOrPosition || sizeOrOptions);
        }else{
            ad = new Ad(adType, tagOrPosition);
            size = sizeOrOptions;
        }
        hashKey = ad.getHash();
        loadedAds[hashKey] = ad;
        var _this = this;
        Object.keys(Ad.events).forEach(function(eventName){
            EventsBus.off(eventName, handleAdEvent, ad, _this);
            EventsBus.on(eventName, handleAdEvent, ad, _this);
        });
        ad.load(size);
        return ad;
    };


	Tapdaq.prototype.hideBanner = function(tagOrPosition){
		var ad = new Ad(Ad.AdTypes.BANNER, tagOrPosition);
		ad.hide();
	};


    /**
     *
     * @param string adType
     * @param string tag
     * @returns {Promise}
     */
    Tapdaq.prototype.isReady = function(adType, tag){
        var ad = new Ad(adType, tag);
        return ad.isReady();
    };

	Tapdaq.prototype.createNativeAd = NativeAd.create;

    module.exports = new Tapdaq();

})();