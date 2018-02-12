cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-tapdaq.Tapdaq",
    "file": "plugins/cordova-plugin-tapdaq/www/Tapdaq.js",
    "pluginId": "cordova-plugin-tapdaq",
    "clobbers": [
      "cordova.plugins.Tapdaq"
    ]
  },
  {
    "id": "cordova-plugin-tapdaq.ads.Ad",
    "file": "plugins/cordova-plugin-tapdaq/www/ads/Ad.js",
    "pluginId": "cordova-plugin-tapdaq"
  },
  {
    "id": "cordova-plugin-tapdaq.ads.MoreAppsAd",
    "file": "plugins/cordova-plugin-tapdaq/www/ads/MoreAppsAd.js",
    "pluginId": "cordova-plugin-tapdaq"
  },
  {
    "id": "cordova-plugin-tapdaq.ads.NativeAd",
    "file": "plugins/cordova-plugin-tapdaq/www/ads/NativeAd.js",
    "pluginId": "cordova-plugin-tapdaq"
  },
  {
    "id": "cordova-plugin-tapdaq.EventsBus",
    "file": "plugins/cordova-plugin-tapdaq/www/EventsBus.js",
    "pluginId": "cordova-plugin-tapdaq"
  },
  {
    "id": "cordova-plugin-tapdaq.vendor.promise",
    "file": "plugins/cordova-plugin-tapdaq/www/vendor/promise.js",
    "pluginId": "cordova-plugin-tapdaq"
  },
  {
    "id": "cordova-plugin-tapdaq.Promise",
    "file": "plugins/cordova-plugin-tapdaq/www/promise.js",
    "pluginId": "cordova-plugin-tapdaq"
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-tapdaq": "5.10.0"
};
// BOTTOM OF METADATA
});