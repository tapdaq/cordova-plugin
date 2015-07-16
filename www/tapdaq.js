
var exec = require('cordova/exec');

var Tapdaq = {};

Tapdaq.setOptions = function(options) {

  exec(null, null, "CDVTapdaq", "setOptions", [options]);

};

Tapdaq.init = function(appId, clientKey) {

  exec(null, null, "CDVTapdaq", "init", [
    appId,
    clientKey
  ]);

};

Tapdaq.showInterstitial = function() {

  exec(null, null, "CDVTapdaq", "showInterstitial", []);

};

module.exports = Tapdaq;