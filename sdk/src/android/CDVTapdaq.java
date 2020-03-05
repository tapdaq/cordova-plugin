package com.tapdaq.cordovasdk;

import android.app.Activity;

import com.google.android.gms.common.util.Strings;
import com.google.gson.Gson;
import com.tapdaq.sdk.STATUS;
import com.tapdaq.sdk.TDBanner;
import com.tapdaq.sdk.Tapdaq;
import com.tapdaq.sdk.TapdaqConfig;
import com.tapdaq.sdk.adnetworks.TMMediationNetworks;
import com.tapdaq.sdk.common.TMAdError;
import com.tapdaq.sdk.helpers.TLog;
import com.tapdaq.sdk.helpers.TLogLevel;
import com.tapdaq.sdk.listeners.TMAdListener;
import com.tapdaq.sdk.listeners.TMInitListener;
import com.tapdaq.sdk.model.rewards.TDReward;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CDVTapdaq extends CordovaPlugin {

    private static final String ACTION_INIT = "init";
    private static final String ACTION_LAUNCH_DEBUGGER = "launchDebugger";
    private static final String ACTION_LOAD_AD = "load";
    private static final String ACTION_IS_AD_READY = "isReady";
    private static final String ACTION_SHOW_AD = "show";
    private static final String ACTION_HIDE_AD = "hide";
    private static final String ACTION_DESTROY_AD = "destroy";
    private static final String ACTION_USER_SUBJECT_TO_GDPR_STATUS = "userSubjectToGDPRStatus";
    private static final String ACTION_SET_USER_SUBJECT_TO_GDPR = "setUserSubjectToGDPR";
    private static final String ACTION_CONSENT_STATUS = "consentStatus";
    private static final String ACTION_SET_CONSENT = "setConsent";
    private static final String ACTION_AGE_RESTRICTED_USER_STATUS = "ageRestrictedUserStatus";
    private static final String ACTION_SET_AGE_RESTRICTED_USER = "setAgeRestrictedUser";
    private static final String ACTION_FORWARD_USERID = "forwardUserId";
    private static final String ACTION_SET_FORWARD_USERID = "setForwardUserId";
    private static final String ACTION_USER_ID = "userId";
    private static final String ACTION_SET_USER_ID = "setUserId";
    private static final String ACTION_REWARD_ID = "rewardId";
    private static final String ACTION_SET_LOG_LEVEL = "setLogLevel";

    private static final String CDV_CONFIG_KEY_ANDROID = "android";
    private static final String CDV_CONFIG_KEY_APP_ID = "appId";
    private static final String CDV_CONFIG_KEY_CLIENT_KEY = "clientKey";
    private static final String CDV_CONFIG_KEY_TEST_DEVICES = "testDevices";

    private static final String CDV_CONFIG_KEY_PLUGIN_VERSION = "pluginVersion";
    private static final String CDV_CONFIG_KEY_USER_ID = "userId";
    private static final String CDV_CONFIG_KEY_FORWARD_USER_ID = "forwardUserId";
    private static final String CDV_CONFIG_KEY_LOG_LEVEL = "logLevel";
    private static final String CDV_CONFIG_KEY_USER_SUBJECT_TO_GDPR = "userSubjectToGDPR";
    private static final String CDV_CONFIG_KEY_CONSENT_GIVEN = "isConsentGiven";
    private static final String CDV_CONFIG_KEY_AGE_RESTRICTED_USER = "isAgeRestrictedUser";
    private static final String CDV_CONFIG_KEY_ADMOB_CONTENT_RATING = "adMobContentRating";

    private static final String CDV_AD_UNIT_INTERSTITIAL = "static_interstitial";
    private static final String CDV_AD_UNIT_VIDEO = "video_interstitial";
    private static final String CDV_AD_UNIT_REWARDED_VIDEO = "rewarded_video_interstitial";
    private static final String CDV_AD_UNIT_BANNER = "banner";

    private static final String CDV_OPTS_AD_UNIT = "adUnit";
    private static final String CDV_OPTS_PLACEMENT_TAG = "placementTag";

    private static final String CDV_OPTS_BANNER_SIZE = "bannerSize";
    private static final String CDV_OPTS_BANNER_WIDTH = "bannerWidth";
    private static final String CDV_OPTS_BANNER_HEIGHT = "bannerHeight";

    private static final String CDV_OPTS_BANNER_POSITION = "bannerPosition";
    private static final String CDV_OPTS_BANNER_X = "bannerX";
    private static final String CDV_OPTS_BANNER_Y = "bannerY";

    private static final String CDV_BANNER_SIZE_CUSTOM = "custom";
    private static final String CDV_BANNER_POSITION_CUSTOM = "custom";

    private static final String CDV_TEST_DEVICES_KEY_NETWORK = "network";
    private static final String CDV_TEST_DEVICES_KEY_DEVICES = "devices";

    private Tapdaq tapdaq;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        this.tapdaq = Tapdaq.getInstance();
    }

    @Override
    public boolean execute(final String action,
                           final JSONArray args,
                           final CallbackContext callbackContext) throws JSONException {
        switch (action) {
            case ACTION_INIT:
                return initAction(args, callbackContext);
            case ACTION_LAUNCH_DEBUGGER:
                return launchDebuggerAction();
            case ACTION_LOAD_AD:
                return loadAdAction(args, callbackContext);
            case ACTION_IS_AD_READY:
                return isAdReadyAction(args, callbackContext);
            case ACTION_SHOW_AD:
                return showAdAction(args, callbackContext);
            case ACTION_HIDE_AD:
                return hideAdAction(args, callbackContext);
            case ACTION_DESTROY_AD:
                return destroyAdAction(args, callbackContext);
            case ACTION_USER_SUBJECT_TO_GDPR_STATUS:
                return userSubjectToGDPRStatusAction(callbackContext);
            case ACTION_SET_USER_SUBJECT_TO_GDPR:
                return setUserSubjectToGDPRAction(args, callbackContext);
            case ACTION_CONSENT_STATUS:
                return consentStatusAction(callbackContext);
            case ACTION_SET_CONSENT:
                return setConsentAction(args, callbackContext);
            case ACTION_AGE_RESTRICTED_USER_STATUS:
                return ageRestrictedUserStatusAction(callbackContext);
            case ACTION_SET_AGE_RESTRICTED_USER:
                return setAgeRestrictedUserAction(args, callbackContext);
            case ACTION_FORWARD_USERID:
                return forwardUserIdAction(callbackContext);
            case ACTION_SET_FORWARD_USERID:
                return setForwardUserIdAction(args, callbackContext);
            case ACTION_USER_ID:
                return userIdAction(callbackContext);
            case ACTION_SET_USER_ID:
                return setUserIdAction(args, callbackContext);
            case ACTION_REWARD_ID:
                return rewardIdAction(args, callbackContext);
            case ACTION_SET_LOG_LEVEL:
                return setLogLevelAction(args, callbackContext);
        }
        return false;
    }

    private boolean initAction(final JSONArray args,
                               final CallbackContext callbackContext) throws JSONException {
        final JSONObject options = args.getJSONObject(0);

        if (!options.has(CDV_CONFIG_KEY_ANDROID)) {
            callbackContext.error("android config has not been provided");
            return true;
        }

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                try {
                    TapdaqConfig config = generateConfigGivenOptions(options);

                    CDVTDErrorDeSer util = new CDVTDErrorDeSer(new Gson());
                    CDVTapdaqInitListener initListener = new CDVTapdaqInitListener(callbackContext, util);

                    JSONObject androidOptions = options.getJSONObject(CDV_CONFIG_KEY_ANDROID);

                    String appId = "";
                    if (androidOptions.has(CDV_CONFIG_KEY_APP_ID)
                             && androidOptions.get(CDV_CONFIG_KEY_APP_ID) instanceof String) {
                        appId = androidOptions.getString(CDV_CONFIG_KEY_APP_ID);
                    }

                    String clientKey = "";
                    if (androidOptions.has(CDV_CONFIG_KEY_CLIENT_KEY)
                             && androidOptions.get(CDV_CONFIG_KEY_CLIENT_KEY) instanceof String) {
                        clientKey = androidOptions.getString(CDV_CONFIG_KEY_CLIENT_KEY);
                    }

                    tapdaq.initialize(cordova.getActivity(), appId, clientKey, config, initListener);
                } catch (JSONException e) {
                    callbackContext.error(e.getMessage());
                }
            }
        });

        return true;
    }

    private boolean launchDebuggerAction() {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                tapdaq.startTestActivity(cordova.getActivity());
            }
        });

        return true;
    }

    private boolean loadAdAction(final JSONArray args,
                                 final CallbackContext callbackContext) throws JSONException {
        JSONObject options = args.getJSONObject(0);

        String adUnitStr = options.optString(CDV_OPTS_AD_UNIT, "");
        String placementTagStr = options.optString(CDV_OPTS_PLACEMENT_TAG, "");

        CDVTDErrorDeSer util = new CDVTDErrorDeSer(new Gson());
        CDVTapdaqAdListener listener = new CDVTapdaqAdListener(adUnitStr, placementTagStr, callbackContext, util);

        Activity activity = this.cordova.getActivity();

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                switch (adUnitStr) {
                    case CDV_AD_UNIT_INTERSTITIAL:
                        tapdaq.loadInterstitial(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_VIDEO:
                        tapdaq.loadVideo(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_REWARDED_VIDEO:
                        tapdaq.loadRewardedVideo(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_BANNER:
                    {
                        String bannerSizeStr = options.optString(CDV_OPTS_BANNER_SIZE, "");

                        if (bannerSizeStr.equalsIgnoreCase(CDV_BANNER_SIZE_CUSTOM)) {
                            int bannerWidth = options.optInt(CDV_OPTS_BANNER_WIDTH);
                            int bannerHeight = options.optInt(CDV_OPTS_BANNER_HEIGHT);
                            TDBanner.Load(activity, placementTagStr, bannerWidth, bannerHeight, listener);
                        } else {
                            TDBanner.Load(activity, placementTagStr, convertBannerSize(bannerSizeStr), listener);
                        }
                        break;
                    }
                }
            }
        });

        return true;
    }

    private boolean isAdReadyAction(final JSONArray args,
                                    final CallbackContext callbackContext) throws JSONException {
        JSONObject options = args.getJSONObject(0);

        String adUnitStr = options.optString(CDV_OPTS_AD_UNIT, "");
        String placementTagStr = options.optString(CDV_OPTS_PLACEMENT_TAG, "");

        Activity activity = this.cordova.getActivity();

        boolean isReady = false;
        switch (adUnitStr) {
            case CDV_AD_UNIT_INTERSTITIAL:
                isReady = tapdaq.isInterstitialReady(activity, placementTagStr);
                break;
            case CDV_AD_UNIT_VIDEO:
                isReady = tapdaq.isVideoReady(activity, placementTagStr);
                break;
            case CDV_AD_UNIT_REWARDED_VIDEO:
                isReady = tapdaq.isRewardedVideoReady(activity, placementTagStr);
                break;
            case CDV_AD_UNIT_BANNER:
                isReady = TDBanner.IsReady(placementTagStr);
                break;
        }

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, isReady);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);

        return true;
    }

    private boolean showAdAction(final JSONArray args,
                                 final CallbackContext callbackContext) throws JSONException {
        JSONObject options = args.getJSONObject(0);

        String adUnitStr = options.optString(CDV_OPTS_AD_UNIT, "");
        String placementTagStr = options.optString(CDV_OPTS_PLACEMENT_TAG, "");

        CDVTDErrorDeSer util = new CDVTDErrorDeSer(new Gson());
        CDVTapdaqAdListener listener = new CDVTapdaqAdListener(adUnitStr, placementTagStr, callbackContext, util);

        Activity activity = this.cordova.getActivity();

        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                switch (adUnitStr) {
                    case CDV_AD_UNIT_INTERSTITIAL:
                        tapdaq.showInterstitial(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_VIDEO:
                        tapdaq.showVideo(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_REWARDED_VIDEO:
                        tapdaq.showRewardedVideo(activity, placementTagStr, listener);
                        break;
                    case CDV_AD_UNIT_BANNER: {
                        String bannerPositionStr = options.optString(CDV_OPTS_BANNER_POSITION, "");

                        if (bannerPositionStr.equalsIgnoreCase(CDV_BANNER_POSITION_CUSTOM)) {
                            int bannerX = options.optInt(CDV_OPTS_BANNER_X);
                            int bannerY = options.optInt(CDV_OPTS_BANNER_Y);
                            TDBanner.Show(activity, placementTagStr, bannerX, bannerY);
                        } else {
                            TDBanner.Show(activity, placementTagStr, bannerPositionStr);
                        }
                    } break;
                }
            }
        });

        return true;
    }

    private boolean hideAdAction(final JSONArray args,
                                 final CallbackContext callbackContext) throws JSONException {
        JSONObject options = args.getJSONObject(0);

        String placementTagStr = options.optString(CDV_OPTS_PLACEMENT_TAG, "");

        Activity activity = this.cordova.getActivity();
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                TDBanner.Hide(activity, placementTagStr);
            }
        });

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);

        return true;
    }

    private boolean destroyAdAction(final JSONArray args,
                                    final CallbackContext callbackContext) throws JSONException {
        JSONObject options = args.getJSONObject(0);

        String placementTagStr = options.optString(CDV_OPTS_PLACEMENT_TAG, "");
        Activity activity = this.cordova.getActivity();
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run()
            {
                TDBanner.Destroy(activity, placementTagStr);
            }
        });

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);

        return true;
    }

    private boolean userSubjectToGDPRStatusAction(final CallbackContext callbackContext) {
        Activity activity = this.cordova.getActivity();
        STATUS userSubjectToGDPRStatus = tapdaq.isUserSubjectToGDPR(activity);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, userSubjectToGDPRStatus.getValue());
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setUserSubjectToGDPRAction(final JSONArray args,
                                               final CallbackContext callbackContext) throws JSONException {
        int statusInt = args.getInt(0);
        STATUS status = STATUS.valueOf(statusInt);

        Activity activity = this.cordova.getActivity();
        tapdaq.setUserSubjectToGDPR(activity, status);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);

        return true;
    }

    private boolean consentStatusAction(final CallbackContext callbackContext) {
        Activity activity = this.cordova.getActivity();
        boolean isConsentGiven = tapdaq.isConsentGiven(activity);
        STATUS consentStatus =  (isConsentGiven) ? STATUS.TRUE : STATUS.FALSE;

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, consentStatus.getValue());
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setConsentAction(final JSONArray args,
                                     final CallbackContext callbackContext) throws JSONException {
        int statusInt = args.getInt(0);
        boolean isConsentGiven = statusInt == STATUS.TRUE.getValue();

        Activity activity = this.cordova.getActivity();
        tapdaq.setContentGiven(activity, isConsentGiven);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean ageRestrictedUserStatusAction(final CallbackContext callbackContext) {
        Activity activity = this.cordova.getActivity();
        boolean isAgeRestrictedUser = tapdaq.isAgeRestrictedUser(activity);
        STATUS ageRestrictedUserStatus = (isAgeRestrictedUser) ? STATUS.TRUE : STATUS.FALSE;

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, ageRestrictedUserStatus.getValue());
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setAgeRestrictedUserAction(final JSONArray args,
                                               final CallbackContext callbackContext) throws JSONException {
        int statusInt = args.getInt(0);
        boolean isAgeRestrictedUser = statusInt == STATUS.TRUE.getValue();

        Activity activity = this.cordova.getActivity();
        tapdaq.setIsAgeRestrictedUser(activity, isAgeRestrictedUser);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean adMobContentRatingAction(final CallbackContext callbackContext) {
        String adMobContentRating = tapdaq.config().getAdMobContentRating();
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, adMobContentRating);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setAdMobContentRatingAction(final JSONArray args,
                                                   final CallbackContext callbackContext) throws JSONException {
        String adMobContentRating = args.getString(0);

        tapdaq.config().setAdMobContentRating(adMobContentRating);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean forwardUserIdAction(final CallbackContext callbackContext) {
        boolean forwardUser = tapdaq.config().shouldForwardUserId();
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, forwardUser);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setForwardUserIdAction(final JSONArray args,
                                        final CallbackContext callbackContext) throws JSONException {
        boolean forwardUserId = args.getBoolean(0);

        tapdaq.config().setForwardUserId(forwardUserId);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean userIdAction(final CallbackContext callbackContext) {
        String userId = tapdaq.config().getUserId();
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, userId);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setUserIdAction(final JSONArray args,
                                    final CallbackContext callbackContext) throws JSONException {
        String userId = args.getString(0);

        Activity activity = this.cordova.getActivity();
        tapdaq.setUserId(activity, userId);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean rewardIdAction(final JSONArray args,
                                   final CallbackContext callbackContext) throws JSONException {
        String placementTag = args.getString(0);

        Activity activity = this.cordova.getActivity();
        String rewardId = tapdaq.getRewardId(activity, placementTag);

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, rewardId);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private boolean setLogLevelAction(final JSONArray args,
                                      final CallbackContext callbackContext) throws JSONException {
        String logLevelStr = args.getString(0);
        TLog.setLoggingLevel(TLogLevel.valueOf(logLevelStr.toUpperCase()));

        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        pluginResult.setKeepCallback(true);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private TapdaqConfig generateConfigGivenOptions(final JSONObject options) throws JSONException {
        TapdaqConfig config = tapdaq.config();

        // Plugin version

        String pluginVersion = options.optString(CDV_CONFIG_KEY_PLUGIN_VERSION);
        if (!Strings.isEmptyOrWhitespace(pluginVersion)) {
            config.setPluginVersion(pluginVersion);
        }

        // Log level

        String logLevelStr = options.optString(CDV_CONFIG_KEY_LOG_LEVEL, TLogLevel.DISABLED.toString());
        if (!Strings.isEmptyOrWhitespace(logLevelStr)) {
            TLogLevel logLevel = TLogLevel.valueOf(logLevelStr.toUpperCase());
            TLog.setLoggingLevel(logLevel);
        }

        // User ID

        String userId = options.optString(CDV_CONFIG_KEY_USER_ID);
        if (!Strings.isEmptyOrWhitespace(userId)) {
            config.setUserId(userId);
        }

        // Forward User ID

        boolean forwardUserId = options.optBoolean(CDV_CONFIG_KEY_FORWARD_USER_ID);
        config.setForwardUserId(forwardUserId);

        // User Subject to GDPR

        if (options.has(CDV_CONFIG_KEY_USER_SUBJECT_TO_GDPR)) {
            int userSubjectToGDPRStatusInt =
                    options.optInt(CDV_CONFIG_KEY_USER_SUBJECT_TO_GDPR, STATUS.UNKNOWN.getValue());
            STATUS userSubjectToGDPRStatus = STATUS.valueOf(userSubjectToGDPRStatusInt);
            config.setUserSubjectToGDPR(userSubjectToGDPRStatus);
        }

        // Consent

        if (options.has(CDV_CONFIG_KEY_CONSENT_GIVEN)) {
            int consentGivenStatusInt =
                    options.optInt(CDV_CONFIG_KEY_CONSENT_GIVEN, STATUS.UNKNOWN.getValue());
            STATUS consentStatus = STATUS.valueOf(consentGivenStatusInt);
            config.setConsentStatus(consentStatus);
        }

        // Age Restricted User

        if (options.has(CDV_CONFIG_KEY_AGE_RESTRICTED_USER)) {
            int ageRestrictedUserInt =
                    options.optInt(CDV_CONFIG_KEY_AGE_RESTRICTED_USER, STATUS.UNKNOWN.getValue());
            STATUS ageRestrictedUserStatus = STATUS.valueOf(ageRestrictedUserInt);
            config.setAgeRestrictedUserStatus(ageRestrictedUserStatus);
        }

        // AdMob Content Rating

        String admobContentRating = options.optString(CDV_CONFIG_KEY_ADMOB_CONTENT_RATING);
        if (!Strings.isEmptyOrWhitespace(admobContentRating)) {
            config.setAdMobContentRating(admobContentRating);
        }

        // Test devices
        config = generateTestDevices(options, config);

        return config;
    }

    /**
     * Network names will be passed in as lowercase - fortunately the Android SDK is NOT case sensitive
     * @param options
     * @return
     */
    private TapdaqConfig generateTestDevices(final JSONObject options,
                                             final TapdaqConfig config) throws JSONException {

        if (!options.has(CDV_CONFIG_KEY_ANDROID)) {
            return config;
        }

        JSONObject androidOptions = options.getJSONObject(CDV_CONFIG_KEY_ANDROID);

        JSONArray testDevicesArray = androidOptions.optJSONArray(CDV_CONFIG_KEY_TEST_DEVICES);
        if (testDevicesArray == null) {
            return config;
        }

        for (int i = 0; i < testDevicesArray.length(); i++) {
            JSONObject testDevicesEntry = testDevicesArray.getJSONObject(i);

            String networkString = testDevicesEntry.optString(CDV_TEST_DEVICES_KEY_NETWORK);
            if (Strings.isEmptyOrWhitespace(networkString)) {
                continue;
            }

            int network = TMMediationNetworks.getID(networkString);

            List<String> devices = new ArrayList<>();
            JSONArray testDevicesJSONArray = testDevicesEntry.optJSONArray(CDV_TEST_DEVICES_KEY_DEVICES);

            if (testDevicesJSONArray != null) {
                for (int j = 0; j < testDevicesArray.length(); j++) {
                    String device = testDevicesArray.optString(j);
                    if (Strings.isEmptyOrWhitespace(device)) {
                        continue;
                    }

                    devices.add(device);
                }
            }

            config.registerTestDevices(network, devices);
        }

        return config;
    }

    private String convertBannerSize(String value) {
        if(value.equalsIgnoreCase("standard")) {
            return TDBanner.BANNER_STANDARD;
        } else if(value.equalsIgnoreCase("medium")) {
            return TDBanner.BANNER_MEDIUM_RECT;
        } else if(value.equalsIgnoreCase("large")) {
            return TDBanner.BANNER_LARGE;
        } else if(value.equalsIgnoreCase("full")) {
            return TDBanner.BANNER_FULL;
        } else if(value.equalsIgnoreCase("leaderboard")) {
            return TDBanner.BANNER_LEADERBOARD;
        } else if(value.equalsIgnoreCase("smart")) {
            return TDBanner.BANNER_SMART;
        }
        return TDBanner.BANNER_STANDARD;
    }
    private class CDVTapdaqInitListener extends TMInitListener {

        private static final String CDV_CALLBACK_DID_INITIALISE = "didInitialise";
        private static final String CDV_CALLBACK_DID_FAIL_TO_INITIALISE = "didFailToInitialise";

        private static final String CDV_CALLBACK_KEY_EVENT_NAME = "eventName";
        private static final String CDV_CALLBACK_KEY_ERROR = "error";

        private CallbackContext callbackContext;
        private CDVTDErrorDeSer deserializer;

        private CDVTapdaqInitListener(final CallbackContext callbackContext,
                                      final CDVTDErrorDeSer deserializer) {
            this.callbackContext = callbackContext;
            this.deserializer = deserializer;
        }

        public void didInitialise() {
            super.didInitialise();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_INITIALISE);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didFailToInitialise(TMAdError error) {
            super.didFailToInitialise(error);
            Map<String, Object> map =
                    mapGivenErrorEvent(error, CDV_CALLBACK_DID_FAIL_TO_INITIALISE);
            sendErrorCallbackGivenMap(map);
        }

        private Map<String, Object> mapGivenErrorEvent(final TMAdError adError,
                                                       final String eventName) {
            Map<String, Object> map = mapGivenEvent(eventName);
            Map<String, Object> errorMap = deserializer.mapFromAdError(adError);
            map.put(CDV_CALLBACK_KEY_ERROR, errorMap);
            return map;
        }

        private Map<String, Object> mapGivenEvent(final String eventName) {
            Map<String, Object> map = new HashMap<>();
            map.put(CDV_CALLBACK_KEY_EVENT_NAME, eventName);
            return map;
        }

        private void sendSuccessCallbackGivenMap(final Map<String, Object> map) {
            JSONObject jsonResponse;
            try {
                jsonResponse = deserializer.jsonObjectFromMap(map);
            } catch (Exception e) {
                // TODO log this as an error?
                jsonResponse = new JSONObject();
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonResponse);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }

        private void sendErrorCallbackGivenMap(final Map<String, Object> map) {
            JSONObject jsonError;
            try {
                jsonError = deserializer.jsonObjectFromMap(map);
            } catch (Exception e) {
                // TODO log this as an error?
                jsonError = new JSONObject();
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, jsonError);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }

    }

    private class CDVTapdaqAdListener extends TMAdListener {

        private static final String CDV_CALLBACK_DID_LOAD = "didLoad";
        private static final String CDV_CALLBACK_DID_FAIL_TO_LOAD = "didFailToLoad";
        private static final String CDV_CALLBACK_WILL_DISPLAY = "willDisplay";
        private static final String CDV_CALLBACK_DID_DISPLAY = "didDisplay";
        private static final String CDV_CALLBACK_DID_FAIL_TO_DISPLAY = "didFailToDisplay";
        private static final String CDV_CALLBACK_DID_CLICK = "didClick";
        private static final String CDV_CALLBACK_DID_CLOSE = "didClose";
        private static final String CDV_CALLBACK_DID_VALIDATE_REWARD = "didValidateReward";
        private static final String CDV_CALLBACK_DID_REFRESH = "didRefresh";
        private static final String CDV_CALLBACK_DID_FAIL_TO_REFRESH = "didFailToRefresh";

        private static final String CDV_CALLBACK_KEY_ERROR = "error";
        private static final String CDV_CALLBACK_KEY_RESPONSE = "response";
        private static final String CDV_CALLBACK_KEY_EVENT_NAME = "eventName";
        private static final String CDV_CALLBACK_KEY_AD_UNIT = "adUnit";
        private static final String CDV_CALLBACK_KEY_PLACEMENT_TAG = "placementTag";
        private static final String CDV_CALLBACK_KEY_REWARD = "reward";

        private static final String CDV_REWARD_KEY_EVENT_ID = "eventId";
        private static final String CDV_REWARD_KEY_NAME = "name";
        private static final String CDV_REWARD_KEY_VALUE = "value";
        private static final String CDV_REWARD_KEY_TAG = "placementTag";
        private static final String CDV_REWARD_KEY_IS_VALID = "isValid";
        private static final String CDV_REWARD_KEY_CUSTOM_JSON = "customJSON";

        private String adUnit;
        private String placementTag;
        private CallbackContext callbackContext;
        private CDVTDErrorDeSer deserializer;

        private CDVTapdaqAdListener(final String adUnit,
                                    final String placementTag,
                                    final CallbackContext callbackContext,
                                    final CDVTDErrorDeSer deserializer) {
            this.adUnit = adUnit;
            this.placementTag = placementTag;
            this.callbackContext = callbackContext;
            this.deserializer = deserializer;
        }

        @Override
        public void didLoad() {
            super.didLoad();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_LOAD, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didFailToLoad(TMAdError error) {
            super.didFailToLoad(error);

            Map<String, Object> map =
                    mapGivenErrorEvent(error, CDV_CALLBACK_DID_FAIL_TO_LOAD, adUnit, placementTag);
            sendErrorCallbackGivenMap(map);
        }

        @Override
        public void willDisplay() {
            super.willDisplay();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_WILL_DISPLAY, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didDisplay() {
            super.didDisplay();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_DISPLAY, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didFailToDisplay(TMAdError error) {
            super.didFailToDisplay(error);

            Map<String, Object> map =
                    mapGivenErrorEvent(error, CDV_CALLBACK_DID_FAIL_TO_DISPLAY, adUnit, placementTag);
            sendErrorCallbackGivenMap(map);
        }

        @Override
        public void didClick() {
            super.didClick();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_CLICK, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didClose() {
            super.didClose();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_CLOSE, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didVerify(TDReward reward) {
            super.didVerify(reward);

            Map<String, Object> map =
                    mapGivenEventAndReward(CDV_CALLBACK_DID_VALIDATE_REWARD, adUnit, placementTag, reward);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didRefresh() {
            super.didRefresh();

            Map<String, Object> map = mapGivenEvent(CDV_CALLBACK_DID_REFRESH, adUnit, placementTag);
            sendSuccessCallbackGivenMap(map);
        }

        @Override
        public void didFailToRefresh(TMAdError error) {
            super.didFailToRefresh(error);

            Map<String, Object> map =
                    mapGivenErrorEvent(error, CDV_CALLBACK_DID_FAIL_TO_REFRESH, adUnit, placementTag);
            sendErrorCallbackGivenMap(map);
        }

        private void sendSuccessCallbackGivenMap(final Map<String, Object> map) {
            JSONObject jsonResponse;
            try {
                jsonResponse = deserializer.jsonObjectFromMap(map);
            } catch (Exception e) {
                // TODO log this as an error?
                jsonResponse = new JSONObject();
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, jsonResponse);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }

        private void sendErrorCallbackGivenMap(final Map<String, Object> map) {
            JSONObject jsonError;
            try {
                jsonError = deserializer.jsonObjectFromMap(map);
            } catch (Exception e) {
                // TODO log this as an error?
                jsonError = new JSONObject();
            }

            PluginResult pluginResult = new PluginResult(PluginResult.Status.ERROR, jsonError);
            pluginResult.setKeepCallback(true);
            callbackContext.sendPluginResult(pluginResult);
        }

        private Map<String, Object> mapGivenEventAndReward(final String eventName,
                                                           final String adUnit,
                                                           final String placementTag,
                                                           final TDReward reward) {
            Map<String, Object> rewardMap = new HashMap<>();
            rewardMap.put(CDV_REWARD_KEY_EVENT_ID, reward.getEventId());
            rewardMap.put(CDV_REWARD_KEY_NAME, reward.getName());
            rewardMap.put(CDV_REWARD_KEY_VALUE, reward.getValue());
            rewardMap.put(CDV_REWARD_KEY_TAG, reward.getTag());
            rewardMap.put(CDV_REWARD_KEY_IS_VALID, reward.isValid());
            rewardMap.put(CDV_REWARD_KEY_CUSTOM_JSON, reward.getCustom_json());

            Map<String, Object> map = mapGivenEvent(eventName, adUnit, placementTag);
            if (map.containsKey(CDV_CALLBACK_KEY_RESPONSE)) {
                Map<String, Object> responseMap = (Map<String, Object>) map.get(CDV_CALLBACK_KEY_RESPONSE);
                if (responseMap != null) {
                    responseMap.put(CDV_CALLBACK_KEY_REWARD, rewardMap);
                }
            }

            return map;
        }

        private Map<String, Object> mapGivenErrorEvent(final TMAdError adError,
                                                       final String eventName,
                                                       final String adUnit,
                                                       final String placementTag) {
            Map<String, Object> map = mapGivenEvent(eventName, adUnit, placementTag);
            Map<String, Object> errorMap = deserializer.mapFromAdError(adError);
            map.put(CDV_CALLBACK_KEY_ERROR, errorMap);
            return map;
        }

        private Map<String, Object> mapGivenEvent(final String eventName,
                                                  final String adUnit,
                                                  final String placementTag) {
            Map<String, Object> responseMap = new HashMap<>();
            responseMap.put(CDV_CALLBACK_KEY_AD_UNIT, adUnit);
            responseMap.put(CDV_CALLBACK_KEY_PLACEMENT_TAG, placementTag);


            Map<String, Object> map = new HashMap<>();
            map.put(CDV_CALLBACK_KEY_EVENT_NAME, eventName);
            map.put(CDV_CALLBACK_KEY_RESPONSE, responseMap);
            return map;
        }

    }

    private class CDVTDErrorDeSer {

        private static final String ERROR_KEY_CODE = "code";
        private static final String ERROR_KEY_MESSAGE = "message";
        private static final String ERROR_KEY_SUB_ERRORS = "subErrors";

        private Gson gson;

        private CDVTDErrorDeSer(final Gson gson) {
            this.gson = gson;
        }

        private JSONObject jsonObjectFromMap(final Map<String, Object> map) throws JSONException {
            String jsonString = gson.toJson(map);
            return new JSONObject(jsonString);
        }

        private Map<String, Object> mapFromAdError(final TMAdError error) {
            Map<String, Object> errorMap = new HashMap<>();
            errorMap.put(ERROR_KEY_CODE, error.getErrorCode());
            errorMap.put(ERROR_KEY_MESSAGE, error.getErrorMessage());

            Map<String, List<TMAdError>> subErrors = error.getSubErrors();

            Map<String, List<Object>> subErrorsMap = new HashMap<>();
            for (Map.Entry<String, List<TMAdError>> mapEntry : subErrors.entrySet()) {
                List<Object> errorMapList = new ArrayList<>();
                for (TMAdError subError : mapEntry.getValue()) {
                    Map<String, Object> subErrorMap = mapFromAdError(subError);
                    errorMapList.add(subErrorMap);
                }
                subErrorsMap.put(mapEntry.getKey(), errorMapList);
            }
            if (subErrorsMap.size() > 0) {
                errorMap.put(ERROR_KEY_SUB_ERRORS, subErrorsMap);
            }

            return errorMap;
        }
    }

}
