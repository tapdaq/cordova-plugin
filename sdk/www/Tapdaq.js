"use strict";

var exec = require("cordova/exec");

var adNetworks = {
  AdMob: "admob",
  FacebookAN: "facebook"
};

var logLevel = {
  Disabled: "DISABLED",
  Info: "INFO",
  Warning: "WARNING",
  Error: "ERROR",
  Debug: "DEBUG"
}

var status = {
  FALSE: 0,
  TRUE: 1,
  UNKNOWN: 2
};

var adMobContentRating = {
  G: "G",
  PG: "PG",
  T: "T",
  MA: "MA"
}

var adUnits = {
  StaticInterstitial: "static_interstitial",
  VideoInterstitial: "video_interstitial",
  RewardedVideo: "rewarded_video_interstitial",
  Banner: "banner"
};

var bannerSizes = {
  Standard: "standard",
  Large: "large",
  Medium: "medium",
  Full: "full",
  Leaderboard: "leaderboard",
  Smart: "smart",
  Custom: "custom"
};

var bannerPositions = {
  Top: "top",
  Bottom: "bottom",
  Custom: "custom"
};

var optsOnlyShowAdEvents = [
  "willDisplay",
  "didClick",
  "didClose",
  "didValidateReward",
  "didFailToReward",
  "didRefresh",
  "didFailToRefresh"
];

var callPlugin = function (success, failure, method, args) {
  exec(success, failure, "Tapdaq", method, args);
};

var handleResponse = function (result, opts, callback) {
  var eventName = result.eventName;
  if (opts && typeof opts[eventName] === "function") {
    if (result.error) {
      opts[eventName](result.error, result.response);
    } else {
      opts[eventName](result.response);
    }
  }

  if (callback &&
    typeof callback === "function" &&
    optsOnlyShowAdEvents.indexOf(eventName) === -1) {
    callback(result.error, result.response);
  }
};

var adConfig = function (adUnit, placementTag) {
  return {
    adUnit: adUnit,
    placementTag: placementTag
  };
}

var callAd = function (method, adUnit, placementTag, opts, callback) {
  var config = adConfig(adUnit, placementTag);

  callPlugin(function (success) {
    handleResponse(success, opts, callback);
  }, function (failure) {
    handleResponse(failure, opts, callback);
  }, method, [config]);
};

var bannerConfig = function (method, placementTag, sizeOrPosition, callback) {
  var config = adConfig(adUnits.Banner, placementTag);

  if (method === "load") {
    var size = sizeOrPosition;
    if (typeof size === "string") {
      config.bannerSize = size;
    } else {
      config.bannerSize = "custom";
      config.bannerWidth = parseFloat(size.width);
      config.bannerHeight = parseFloat(size.height);
    }
  } else {
    var position = sizeOrPosition;
    if (typeof position === "string") {
      config.bannerPosition = position;
    } else {
      config.bannerPosition = "custom";
      config.bannerX = position.x;
      config.bannerY = position.y;
    }
  }

  return config;
}

var callBanner = function (method, placementTag, sizeOrPosition, opts, callback) {
  var config = bannerConfig(method, placementTag, sizeOrPosition, callback);

  callPlugin(function (success) {
    handleResponse(success, opts, callback);
  }, function (failure) {
    handleResponse(failure, opts, callback);
  }, method, [config]);
};

var loadAd = function (adUnit, placementTag, opts, callback) {
  callAd("load", adUnit, placementTag, opts, callback);
};

var showAd = function (adUnit, placementTag, opts, callback) {
  callAd("show", adUnit, placementTag, opts, callback);
};

var isReady = function (adUnit, placementTag, callback) {
  var config = adConfig(adUnit, placementTag);
  callPlugin(callback, null, "isReady", [config]);
};

var getFrequencyCapError = function (adUnit, placementTag, callback) {
  var config = adConfig(adUnit, placementTag);
  callPlugin(callback, null, "getFrequencyCapError", [config]);
};

var handleGetterSetter = function (property, value) {
  // Getter
  if (typeof value === "function") {
    var callback = value;
    callPlugin(callback, null, property, []);
  }

  // Setter
  callPlugin(null, null, property, [value]);
};

var tapdaqExport = {
  LogLevel: logLevel,
  AdNetwork: adNetworks,
  Status: status,
  AdMobContentRating: adMobContentRating,
  AdUnit: adUnits,
  BannerSize: bannerSizes,
  BannerPosition: bannerPositions,

  init: function (config, opts, callback) {
    config = config || {}; // defaults to empty config
    config.pluginVersion = "Cordova_4.4.2"; // add plugin version
    exec(function (success) {
      handleResponse(success, opts, callback);
    }, function (failure) {
      handleResponse(failure, opts, callback);
    }, "Tapdaq", "init", [config]);
  },

  launchDebugger: function () {
    exec(null, null, "Tapdaq", "launchDebugger", []);
  },

  loadInterstitial: function (placementTag, opts, callback) {
    loadAd(adUnits.StaticInterstitial, placementTag, opts, callback);
  },

  loadVideo: function (placementTag, opts, callback) {
    loadAd(adUnits.VideoInterstitial, placementTag, opts, callback);
  },

  loadRewardedVideo: function (placementTag, opts, callback) {
    loadAd(adUnits.RewardedVideo, placementTag, opts, callback);
  },

  loadBanner: function (placementTag, size, opts, callback) {
    callBanner("load", placementTag, size, opts, callback);
  },

  showInterstitial: function (placementTag, opts, callback) {
    showAd(adUnits.StaticInterstitial, placementTag, opts, callback);
  },

  showVideo: function (placementTag, opts, callback) {
    showAd(adUnits.VideoInterstitial, placementTag, opts, callback);
  },

  showRewardedVideo: function (placementTag, opts, callback) {
    showAd(adUnits.RewardedVideo, placementTag, opts, callback);
  },

  showBanner: function (placementTag, position, opts, callback) {
    callBanner("show", placementTag, position, opts, callback);
  },

  isInterstitialReady: function (placementTag, callback) {
    isReady(adUnits.StaticInterstitial, placementTag, callback);
  },

  isVideoReady: function (placementTag, callback) {
    isReady(adUnits.VideoInterstitial, placementTag, callback);
  },

  isRewardedVideoReady: function (placementTag, callback) {
    isReady(adUnits.RewardedVideo, placementTag, callback);
  },

  isBannerReady: function (placementTag, callback) {
    isReady(adUnits.Banner, placementTag, callback);
  },

  getInterstitialFrequencyError: function (placementTag, callback) {
    getFrequencyCapError(adUnits.StaticInterstitial, placementTag, callback);
  },

  getVideoFrequencyError: function (placementTag, callback) {
    getFrequencyCapError(adUnits.VideoInterstitial, placementTag, callback);
  },

  getRewardedVideoFrequencyError: function (placementTag, callback) {
    getFrequencyCapError(adUnits.RewardedVideo, placementTag, callback);
  },

  hideBanner: function (placementTag, callback) {
    var config = adConfig(adUnits.Banner, placementTag);
    callPlugin(callback, null, "hide", [config]);
  },

  destroyBanner: function (placementTag, callback) {
    var config = adConfig(adUnits.Banner, placementTag);
    callPlugin(callback, null, "destroy", [config]);
  },

  userSubjectToGDPRStatus: function (callback) {
    handleGetterSetter("userSubjectToGDPRStatus", callback);
  },

  setUserSubjectToGDPR: function (value) {
    handleGetterSetter("setUserSubjectToGDPR", value);
  },

  consentStatus: function (callback) {
    handleGetterSetter("consentStatus", callback);
  },

  setConsent: function (value) {
    handleGetterSetter("setConsent", value);
  },

  ageRestrictedUserStatus: function (callback) {
    handleGetterSetter("ageRestrictedUserStatus", callback);
  },

  setAgeRestrictedUser: function (value) {
    handleGetterSetter("setAgeRestrictedUser", value);
  },

  adMobContentRating: function (callback) {
    handleGetterSetter("adMobContentRating", callback);
  },

  setAdMobContentRating: function (value) {
    handleGetterSetter("setAdMobContentRating", value);
  },

  userSubjectToUSPrivacyStatus: function (callback) {
    handleGetterSetter("userSubjectToUSPrivacyStatus", callback);
  },

  setUserSubjectToUSPrivacy: function (value) {
    handleGetterSetter("setUserSubjectToUSPrivacy", value);
  },

  usPrivacyStatus: function (callback) {
    handleGetterSetter("usPrivacyStatus", callback);
  },

  setUSPrivacy: function (value) {
    handleGetterSetter("setUSPrivacy", value);
  },

  advertiserTracking: function (callback) {
    handleGetterSetter("advertiserTracking", callback);
  },

  setAdvertiserTracking: function (value) {
    handleGetterSetter("setAdvertiserTracking", value);
  },

  forwardUserId: function (callback) {
    handleGetterSetter("forwardUserId", callback);
  },

  setForwardUserId: function (value) {
    handleGetterSetter("setForwardUserId", value);
  },

  userId: function (callback) {
    handleGetterSetter("userId", callback);
  },

  setUserId: function (value) {
    handleGetterSetter("setUserId", value);
  },

  muted: function (callback) {
    handleGetterSetter("muted", callback);
  },

  setMuted: function (value) {
    handleGetterSetter("setMuted", value);
  },

  rewardId: function (placementTag, callback) {
    callPlugin(callback, null, "rewardId", [placementTag]);
  },

  setUserDataString: function (key, value) {
    callPlugin(null, null, "setUserDataString", [key, value]);
  },

  setUserDataBoolean: function (key, value) {
    callPlugin(null, null, "setUserDataBoolean", [key, value]);
  },

  setUserDataInteger: function (key, value) {
    callPlugin(null, null, "setUserDataInteger", [key, value]);
  },

  userDataString: function (key, callback) {
    callPlugin(callback, null, "userDataString", [key]);
  },

  userDataBoolean: function (key, callback) {
    callPlugin(callback, null, "userDataBoolean", [key]);
  },

  userDataInteger: function (key, callback) {
    callPlugin(callback, null, "userDataInteger", [key]);
  },

  allUserData: function (callback) {
    handleGetterSetter("allUserData", callback);
  },

  removeUserData: function (key) {
    handleGetterSetter("removeUserData", key);
  },

  networkStatuses: function (callback) {
    handleGetterSetter("networkStatuses", callback);
  },

  setLogLevel: function (value) {
    handleGetterSetter("setLogLevel", value);
  }
};

module.exports = tapdaqExport;