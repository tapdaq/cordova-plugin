
var exec = require('cordova/exec');

var tapdaqNative = {
  service: "CDVTapdaq",
  setOptions: "setOptions",
  init: "init",
  resultEvent: "event",
  resultMessage: "message"
};

var eventCallbacks = {
  willDisplayInterstitial: "willDisplayInterstitial",
  didDisplayInterstitial: "didDisplayInterstitial",
  didFailToDisplayInterstitial: "didFailToDisplayInterstitial",
  didCloseInterstitial: "didCloseInterstitial",
  didClickInterstitial: "didClickInterstitial",
  didFailToFetchInterstitialsFromServer: "didFailToFetchInterstitialsFromServer",
  hasNoInterstitialsAvailable: "hasNoInterstitialsAvailable",
  hasInterstitialsAvailableForOrientation: "hasInterstitialsAvailableForOrientation"
};

var that = null;

var handleDelegates = function(result) {
  var event = result[tapdaqNative.resultEvent];

  if (event === eventCallbacks.willDisplayInterstitial &&
      that.willDisplayInterstitial) {
        that.willDisplayInterstitial();
  }

  if (event === eventCallbacks.didDisplayInterstitial &&
      that.didDisplayInterstitial) {
        that.didDisplayInterstitial();
  }

  if (event === eventCallbacks.didFailToDisplayInterstitial &&
      that.didFailToDisplayInterstitial) {
        that.didFailToDisplayInterstitial();
  }

  if (event === eventCallbacks.didCloseInterstitial &&
      that.didCloseInterstitial) {
        that.didCloseInterstitial();
  }

  if (event === eventCallbacks.didCloseInterstitial &&
      that.didCloseInterstitial) {
        that.didCloseInterstitial();
  }

  if (event === eventCallbacks.didClickInterstitial &&
      that.didClickInterstitial) {
        that.didClickInterstitial();
  }

  if (event === eventCallbacks.didFailToFetchInterstitialsFromServer &&
      that.didFailToFetchInterstitialsFromServer) {
        that.didFailToFetchInterstitialsFromServer();
  }

  if (event === eventCallbacks.hasNoInterstitialsAvailable &&
      that.hasNoInterstitialsAvailable) {
        that.hasNoInterstitialsAvailable();
  }

  if (event === eventCallbacks.hasInterstitialsAvailableForOrientation &&
      that.hasInterstitialsAvailableForOrientation) {
        var orientation = result[tapdaqNative.resultMessage]['orientation'];
        that.hasInterstitialsAvailableForOrientation(orientation);
  }

};

var Tapdaq = {

  setOptions: function(options) {
    exec(null, null, tapdaqNative.service, tapdaqNative.setOptions, [options]);
  },

  init: function(appId, clientKey) {
    that = this;
    exec(handleDelegates, null, tapdaqNative.service, tapdaqNative.init, [
      appId,
      clientKey
    ]);
  },

  showInterstitial: function() {
    exec(null, null, tapdaqNative.service, tapdaqNative.showInterstitial, []);
  },

  willDisplayInterstitial: null,
  didDisplayInterstitial: null,
  didFailToDisplayInterstitial: null,
  didCloseInterstitial: null,
  didClickInterstitial: null,
  didFailToFetchInterstitialsFromServer: null,
  hasNoInterstitialsAvailable: null,
  hasInterstitialsAvailableForOrientation: null

};

module.exports = Tapdaq;
