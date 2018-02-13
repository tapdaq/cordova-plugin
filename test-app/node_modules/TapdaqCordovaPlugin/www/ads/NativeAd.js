(function(){
    'use strict';

    var EventsBus = require("cordova-plugin-tapdaq.EventsBus");
    var Ad = require("cordova-plugin-tapdaq.ads.Ad");
    var Promise = require("cordova-plugin-tapdaq.Promise");
    var exec = require("cordova/exec");


    var NativeAd = function (options) {

        var defaultOptions = {
            adType: null,
            tag: "default",
            container: null,
            closeBtnElement: null,
            clickAreaElement: null
        };
        options = options || {};
        options = Object.assign(defaultOptions, options);

        // create container if its empty
        if(!options.container instanceof HTMLElement){
            var el = document.createElement("div");
            el.setAttribute("id", "td_native_ad_" + (new Date()).getTime());
            el.setAttribute("style", "width: 100%;height: 100%; position: absolute;top:0;left:0");
            document.body.appendChild(el);
            options.container = el;
        }
        if(!options.clickAreaElement instanceof HTMLElement){
            options.clickAreaElement = options.container;
        }
        var _this = this;
        /**
         *
         * @private
         */
        var triggerClick = function(){
            exec(
                function (data) {
                    if(data && data.event) {
                        EventsBus.dispatchEvent(data.event, data.eventData);
                    }else{
                        reject("Invalid response");
                    }
                },
                function (error) {
                    reject(error);
                },
                "Tapdaq",
                "triggerNativeAdClick",
                [{adType: _this._getOptions().nativeAdType, tag: _this._getOptions().tag, id: _this._loadedAdData.uniqueId}]
            );
        };
        this._triggerClick = triggerClick;       
        this._getOptions = function(){
            return options;
        };
        this._isLoaded = false;
        this._loadedAdData = {};

        // EventsBus.bridgeEventsHandler.registerHandler(this, [
        //     NativeAd.events.didClick,
        //     NativeAd.events.didLoad,
        //     NativeAd.events.didClose,
        //     NativeAd.events.willDisplay,
        //     NativeAd.events.didDisplay,
        //     NativeAd.events.didFailToLoad
        // ]);

        this.on(NativeAd.events.didLoad, function(event){
            _this._isLoaded = true;
            _this._loadedAdData = event.data;
        });
        this.on(NativeAd.events.didClick, function(event){
            _this._getOptions().container.style.display = "none";
        });
    };


    NativeAd.htmlClasses = {
        appName: "tapdaq-ad-app-name",
        ageRating: "tapdaq-ad-age-rating",
        appSize: "tapdaq-ad-app-size",
        appVersion: "tapdaq-ad-app-version",
        averageReview: "tapdaq-ad-average-review",
        category: "tapdaq-ad-category",
        currency: "tapdaq-ad-currency",
        description: "tapdaq-ad-description",
        developerName: "tapdaq-ad-developer-name",
        price: "tapdaq-ad-price",
        title: "tapdaq-ad-title",
        totalReviews: "tapdaq-ad-total-reviews",
        iconUrl: "tapdaq-ad-icon",
        imageUrl: "tapdaq-ad-image",
        uniqueId: "tapdaq-ad-unique-id",
        clickButton: "tapdaq-click-btn"
    };

    NativeAd.events = {
        didClose: "didClose",
        didClick: "didClick",
        willDisplay: "willDisplay",
        didDisplay: "didDisplay",
        didLoad: "didLoad",
        didFailToLoad: "didFailToLoad"
    };
    NativeAd.AdTypes = {
        // 1x1
        AdType1x1Large: "NativeAdType1x1Large",
        AdType1x1Medium: "NativeAdType1x1Medium",
        AdType1x1Small: "NativeAdType1x1Small",
        // 1x2
        AdType1x2Large: "NativeAdType1x2Large",
        AdType1x2Medium: "NativeAdType1x2Medium",
        AdType1x2Small: "NativeAdType1x2Small",

        //2x1
        AdType2x1Large: "NativeAdType2x1Large",
        AdType2x1Medium: "NativeAdType2x1Medium",
        AdType2x1Small: "NativeAdType2x1Small",

        // 2x3
        AdType2x3Large: "NativeAdType2x3Large",
        AdType2x3Medium: "NativeAdType2x3Medium",
        AdType2x3Small: "NativeAdType2x3Small",

        // 3x2
        AdType3x2Large: "NativeAdType3x2Large",
        AdType3x2Medium: "NativeAdType3x2Medium",
        AdType3x2Small: "NativeAdType3x2Small",

        //
        AdType1x5Large: "NativeAdType1x5Large",
        AdType1x5Medium: "NativeAdType1x5Medium",
        AdType1x5Small: "NativeAdType1x5Small",

        // 5x1
        AdType5x1Large: "NativeAdType5x1Large",
        AdType5x1Medium: "NativeAdType5x1Medium",
        AdType5x1Small: "NativeAdType5x1Small"
    };

    /**
     * Factory for creating NativeAd
     * @param adType
     * @returns {Object}
     */
    NativeAd.create = function(adType){
        var options = {};
        options.adType = Ad.AdTypes.NATIVE_AD;
        options.nativeAdType = adType;

        return {
            forTag: function(tag){
                options.tag = tag;
                return {
                    /**
                     *
                     * @param {HTMLElement} containerElement
                     * @param {HTMLElement} clickElement
                     * @returns {Promise}
                     */
                    withContainer: function(containerElement, clickElement){
                        clickElement = clickElement || null;
                        options.container = containerElement;
                        options.clickAreaElement = clickElement;
                        
                        return new Promise(function(resolve, reject){
                            var ad = new NativeAd(options)
                            resolve(ad);
                        });                       
                    }
                };
            }
        };

    };


    NativeAd.prototype.on = function(type, callback){
        EventsBus.off(type, callback, this);
        EventsBus.on(type, callback, this);
    };
    NativeAd.prototype.once = function(type, callback){
        EventsBus.once(type, callback, this);
    };
    NativeAd.prototype.off = function(type, callback){
        EventsBus.off(type, callback, this);
    };

    NativeAd.prototype.getHash = function(){
        return this.getNativeType() + "-" + this.getTag();
    };

    /**
     *
     * @returns {string}
     */
    NativeAd.prototype.getType = function(){
        return this._getOptions().adType;
    };
    
    /**
     *
     * @returns {string}
     */
    NativeAd.prototype.getNativeType = function(){
        return this._getOptions().nativeAdType;
    };

    /**
     *
     * @returns {string}
     */
    NativeAd.prototype.getTag = function(){
        return this._getOptions().tag;
    };

    /**
     *
     * @returns {Promise}
     */
    NativeAd.prototype.load = function(){
        var _this = this;
        _this._isLoaded = false;
        return new Promise(function(resolve, reject){
            _this.once(NativeAd.events.didLoad, function(data){
                resolve(data);
            });

            exec(
                function (data) {
                    if(data && data.event) {
                        EventsBus.dispatchEvent(data.event, data.eventData);
                    }else{
                        reject("Invalid response");
                    }
                },
                function (error) {
                    reject(error);
                },
                "Tapdaq",
                "load",
                [{adType: _this._getOptions().nativeAdType, tag: _this._getOptions().tag}]
            );
        });
    };

    /**
     *
     * @returns {Promise}
     */
    NativeAd.prototype.show = function(){
        var container = this._getOptions().container;
        var _this = this;
        var fillContainerWithData = function(data){
            if(typeof data["uniqueId"] !== 'undefined'){
                _this._getOptions().container.setAttribute("data-id", data["uniqueId"]);
            }
            for(var name in data){                
                if(data.hasOwnProperty(name)){
                    var val = data[name];
                    if(typeof NativeAd.htmlClasses[name] !== 'undefined'){
                        var className = NativeAd.htmlClasses[name];
                        var el = _this._getOptions().container.querySelector("." + className);
                        if(el instanceof HTMLImageElement){
                            el.setAttribute("src",val);
                        }else if(el instanceof HTMLElement){
                            el.textContent = val;
                        }
                    }
                }
            }
        };
        
        var attachClickHandler = function(){
            var clickElement = _this._getOptions().container.querySelectorAll("." + NativeAd.htmlClasses.clickButton) || _this._getOptions().clickAreaElement;
            var elements = [];
            if(clickElement instanceof NodeList){
                elements = [].slice.call(clickElement);
            }else{
                elements.push(clickElement);
            }
            
            elements.forEach(function(el){
                if(el instanceof HTMLElement){
                    if(el.dataset['clickAttached'] === undefined){
                        el.addEventListener("click", function(e){
                            _this._triggerClick(this);
                            EventsBus.dispatchEvent(NativeAd.events.didClick, {});            
                        });
                        el.dataset['clickAttached'] = true;
                    }
                }
            });
        };
        
           /**
         *
         * @private
         */
        var triggerImpression = function(){
            exec(
                function (data) {
                    if(data && data.event) {
                        EventsBus.dispatchEvent(data.event, data.eventData);
                    }else{
                        reject("Invalid response");
                    }
                },
                function (error) {
                    reject(error);
                },
                "Tapdaq",
                "triggerNativeAdImpression",
                [{adType: _this._getOptions().nativeAdType, tag: _this._getOptions().tag, id: _this._loadedAdData.uniqueId}]
            );
        };
        var _show = function(){
            fillContainerWithData(_this._loadedAdData);
            attachClickHandler();
            container.style.display = "block";
            triggerImpression(_this);
        };

        if(!this._isLoaded){
            return this.load().then(function(){
                _show.call(_this);
            });
        }else{
            return new Promise(function(resolve, reject){
                _show.call(_this);
                resolve();
            });
        }
    };

    /**
     *
     * @returns {Promise}
     */
    NativeAd.prototype.hide = function() {
        this._getOptions().container.style.display = "none";
        EventsBus.dispatchEvent(NativeAd.events.didClose, {adType: this._getOptions().nativeAdType, tag: this._getOptions().tag})
    };
    
     /**
     *
     * @returns {Promise}
     */
   NativeAd.prototype.isReady = function(){
       var _this = this;
       return new Promise(function(resolve, reject) {
           var options = {
               adType: _this._getOptions().nativeAdType,
               tag: _this._getOptions().tag
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

    

    module.exports = NativeAd;
})();