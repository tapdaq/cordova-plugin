package com.tapdaq.cordovasdk;

import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.widget.FrameLayout;
import android.view.WindowManager;
import android.widget.PopupWindow;

import com.tapdaq.cordovasdk.listeners.AdListener;
import com.tapdaq.cordovasdk.listeners.NativeAdListener;
import com.tapdaq.cordovasdk.enums.*;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;


import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.tapdaq.sdk.CreativeType;
import com.tapdaq.sdk.TMBannerAdView;
import com.tapdaq.sdk.Tapdaq;
import com.tapdaq.sdk.TapdaqConfig;
import com.tapdaq.sdk.ads.TapdaqPlacement;
import com.tapdaq.sdk.helpers.TLog;
import com.tapdaq.sdk.helpers.TMDevice;
import com.tapdaq.sdk.TMNativeAd;
import com.tapdaq.sdk.helpers.TLogLevel;
import com.tapdaq.sdk.listeners.TMAdListener;
import com.tapdaq.sdk.listeners.TMInitListener;
import com.tapdaq.sdk.moreapps.TMMoreAppsListener;
import com.tapdaq.sdk.model.TMAdSize;
import com.tapdaq.sdk.common.*;
import com.tapdaq.sdk.adnetworks.*;
import com.tapdaq.sdk.moreapps.TMMoreAppsConfig;

import java.lang.ClassNotFoundException;
import java.lang.Exception;
import java.lang.Override;
import java.lang.Runnable;
import java.lang.StringBuilder;
import java.lang.Throwable;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.HashMap;


/**
 * This class echoes a string called from JavaScript.
 */
public class CDVTapdaq extends CordovaPlugin {
  
    public enum AdBannerSize {
        STANDARD,
        LARGE,
        MEDIUM_RECT,
        FULL,
        LEADERBOARD,
        SMART
    }

    public enum AdBannerPosition {
        TOP,
        BOTTOM
    }

    static boolean debugging = false;
    static boolean autoReload = false;
    static String TAG = "Tapdaq Cordova Plugin";

    static TMBannerAdView bannerAdView;
    static PopupWindow popupWindow;
    
    static String bannerType = "";

    static List<CreativeType> enabledCreativeTypes = new ArrayList<CreativeType>();

    static List<String> availableAdTypes = new ArrayList<String>(Arrays.asList(AdType.names()));
    static List<String> supportedBannerSizes = new ArrayList<String>(Arrays.asList(new String[]{AdBannerSize.STANDARD.name(), AdBannerSize.LARGE.name(), AdBannerSize.MEDIUM_RECT.name(), AdBannerSize.FULL.name(), AdBannerSize.LEADERBOARD.name(), AdBannerSize.SMART.name()}));

    static Map<String, NativeAdListener> nativeAdListeners = null;

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        Tapdaq.getInstance().onPause(this.cordova.getActivity());
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        Tapdaq.getInstance().onResume(this.cordova.getActivity());
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        if(debugging){
            TLog.setLoggingLevel(TLogLevel.DEBUG);
        }else{
            TLog.setLoggingLevel(TLogLevel.ERROR);
        }
        if(nativeAdListeners == null){
            nativeAdListeners = new HashMap<String, NativeAdListener>();
        }
        if (action.equals("init")) {
            this.init(args.getJSONObject(0), callbackContext);
            return true;
        }else  if (action.equals("load")) {
            this.load(args.getJSONObject(0), callbackContext);
            return true;
        }else if (action.equals("show")) {
            this.show(args.getJSONObject(0), callbackContext);
            return true;
        }else if (action.equals("hide")) {
            this.hide(args.getJSONObject(0), callbackContext);
            return true;
        }else if (action.equals("triggerNativeAdClick")) {
            this.triggerNativeAdClick(args.getJSONObject(0), callbackContext);
            return true;
        }else if (action.equals("isReady")) {
            this.isReady(args.getJSONObject(0), callbackContext);
            return true;
        }else if (action.equals("showDebugPanel")) {
            if(!debugging){
                Log.i(TAG, "DEBUG Mode is disabled, set debugMode option to 'true' to enable it");
                return true;
            }
            Tapdaq.getInstance().startTestActivity(cordova.getActivity());
            return true;
        }else if (action.equals("triggerNativeAdImpression")) {
            this.triggerNativeAdImpression(args.getJSONObject(0), callbackContext);
            return true;
        }

        return false;
    }

    private void init(final JSONObject options, final CallbackContext callbackContext) {
		boolean isValid = validateInitOptions(options);
                if (!isValid) {
                    callbackContext.error("Invalid options are given");
                    return;
                }
                log("init SDK");
                JSONArray enabledTagsPlacements = null;
                try {
                    enabledTagsPlacements = options.getJSONArray("enabledPlacements");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }

                String debug  = null;
                try {
                    debug = options.getString("debugMode");
                } catch (JSONException ex) {
                    debug = "false";
                    error(ex.getMessage(), ex);
                }
                if(debug != null && debug.equals("true")){
                    debugging = true;
                }
                
                String autoReloadStr  = null;
                try {
                    autoReloadStr = options.getString("autoReload");
                } catch (JSONException ex) {
                    autoReloadStr = "false";
                    error(ex.getMessage(), ex);
                }
                if(autoReloadStr != null && autoReloadStr.equals("true")){
                    autoReload = true;
                }

                JSONObject androidOpts = null;
                String appId = null;
                String clientKey = null;
                JSONArray devicesByProvider = null;
                try {
                    androidOpts = options.getJSONObject("android");
                    appId = androidOpts.getString("appId");
                    clientKey = androidOpts.getString("clientKey");
                    devicesByProvider = androidOpts.getJSONArray("testDevices");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }


                Map<String, List<String>> devices = retrieveDevices(devicesByProvider);

                TapdaqConfig config = new TapdaqConfig(cordova.getActivity());
                List<TapdaqPlacement> enabledPlacements = new ArrayList<TapdaqPlacement>();

                for (int i = 0; i < enabledTagsPlacements.length(); i++) {
                    JSONObject jsonObject = null;
                    try {
                        jsonObject = enabledTagsPlacements.getJSONObject(i);
                    } catch (JSONException e) {
                        error(e.getMessage(), e);
                    }
                    if (jsonObject == null) {
                        continue;
                    }
                    String adType = null;
                    List<String> tagsList = new ArrayList<String>();
                    try {
                        adType = jsonObject.getString("adType");
                        JSONArray tags = jsonObject.getJSONArray("tags");
                        if (tags != null) {
                            for (int tagNum = 0; tagNum < tags.length(); tagNum++) {
                                tagsList.add(tags.getString(tagNum));
                            }
                        }
                    } catch (JSONException e) {
                        error(e.getMessage(), e);
                    }
                    if (adType != null) {
                        for (String tag : tagsList) {
                            log("Tag: " + tag + "    adType: " + adType);
                            enabledPlacements.add(TapdaqPlacement.createPlacement(TapdaqHelper.GetCreativeTypesFromString(adType), tag));
                        }
                    }
                }

                try {
                    
                    config.setAutoReloadAds(autoReload);
                    
                    List<String> adMobDevices = devices.get(TMMediationNetworks.AD_MOB_NAME); 
                    config.registerTestDevices(TMMediationNetworks.AD_MOB, adMobDevices);
                    
                    List<String> fbDevices = devices.get(TMMediationNetworks.FACEBOOK_NAME); 
                    config.registerTestDevices(TMMediationNetworks.FACEBOOK, fbDevices);
					
                    config.withPlacementTagSupport(enabledPlacements.toArray(new TapdaqPlacement[enabledPlacements.size()]));
                    Tapdaq.getInstance().initialize(cordova.getActivity(), appId, clientKey, config, new TMInitListener() {
                        @Override
                        public void didInitialise() {
                            dispatchEvent("didInitialise", new JSONObject(), callbackContext);
                        }
                    });
                } catch (Throwable ex) {
                    error(ex.getMessage(), ex);
                }
        /*cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                
            }
        });*/
    }
	
	
    private Map<String, List<String>> retrieveDevices(JSONArray input)
    {

        Map<String, List<String>> devices = new HashMap<String, List<String>>();
        if(input == null) {
            return devices;
        }

        for(int i = 0; i < input.length(); i++){
            JSONObject obj = null;
            try{
                obj = input.getJSONObject(i);
            } catch (JSONException ex) {
                error(ex.getMessage(), ex);
            }
            if(obj != null){
                String providerName = null;
                JSONArray devicesIds = null;
                try{
                    providerName = obj.getString("network");
                    devicesIds = obj.getJSONArray("devices");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }
                if(providerName == null || devicesIds == null){
                    continue;
                }
                List<String> devs = new ArrayList<String>();
                for(int j = 0; j < devicesIds.length(); j++){
                    try {
                        devs.add(devicesIds.getString(j));
                    }catch (JSONException e){
                        error(e.getMessage(), e);
                    }
                }
                devices.put(providerName, devs);
            }

        }        
        if(!devices.containsKey(TMMediationNetworks.AD_MOB_NAME)){
            devices.put(TMMediationNetworks.AD_MOB_NAME, new ArrayList<String>());
        }
        if(!devices.containsKey(TMMediationNetworks.FACEBOOK_NAME)){
            devices.put(TMMediationNetworks.FACEBOOK_NAME, new ArrayList<String>());
        }
        return devices;
    }

    private void load(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                boolean isValid = validateLoadOptions(options);
                if (!isValid) {
                    callbackContext.error("Invalid options are given");
                    return;
                }

                String adType = null;
                String tag = null;
                String size = null;

                try {
                    adType = options.getString("adType");
                    tag = options.getString("tag");
                    size = options.getString("size");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }
                
                JSONObject jsonConfig = null;
                try {
                    jsonConfig = options.getJSONObject("options");                    
                } catch (JSONException ex) {
                   
                }

                if (tag == null) {
                    tag = TapdaqPlacement.TDPTagDefault;
                }

                if (size == null) {
                    size = AdBannerSize.STANDARD.name();
                }

                log("load adType: " + adType + "; tag: " + tag);                
                AdType type = AdType.valueOf(adType);
				if(type == AdType.AdTypeBanner){
					tag = null;
				}
				TMAdListener listener = new AdListener(adType, tag, callbackContext);
                switch (type) {
                    case AdTypeInterstitial:
                        Tapdaq.getInstance().loadInterstitial(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeVideo:
                        Tapdaq.getInstance().loadVideo(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeRewardedVideo:
                        Tapdaq.getInstance().loadRewardedVideo(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeOfferwall:
                        Tapdaq.getInstance().loadOfferwall(cordova.getActivity(), listener);
                        break;
                    case AdTypeMoreApps:
                        TMMoreAppsConfig config;
                        if(jsonConfig != null){
                            config = TapdaqHelper.createMoreAppsConfigFromJSON(jsonConfig);
                        }else{
                            config = new TMMoreAppsConfig();
                        }
                        Tapdaq.getInstance().loadMoreApps(cordova.getActivity(), config, ((AdListener)listener).createMoreAppsListener());
                        break;
                    case AdTypeBanner:
                        loadBanner(size, listener);
                        break;
                    default:
                        listener = new NativeAdListener(adType, tag, cordova.getActivity(), callbackContext);
                        nativeAdListeners.put(adType + "_" + tag, (NativeAdListener) listener);
                        Tapdaq.getInstance().loadNativeAdvert(cordova.getActivity(), TapdaqHelper.GetCreativeTypesFromString(adType).get(0), tag, listener);
                }

            }
        });
    }


    private void show(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                boolean isValid = validateShowOptions(options);
                if (!isValid) {
                    callbackContext.error("Invalid options are given");
                    return;
                }

                String adType = null;
                String tag = null;
                String position = null;

                try {
                    adType = options.getString("adType");
                    tag = options.getString("tag");
                    position = options.getString("position");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }

                if (tag == null) {
                    tag = TapdaqPlacement.TDPTagDefault;
                }

                if (position == null) {
                    position = AdBannerPosition.BOTTOM.name();
                }

                log("show adType: " + adType + "; tag: " + tag + "; position: " + position);

                AdListener listener = new AdListener(adType, tag, callbackContext);
                AdType type = AdType.valueOf(adType);
                switch (type) {
                    case AdTypeInterstitial:
                        Tapdaq.getInstance().showInterstitial(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeVideo:
                        Tapdaq.getInstance().showVideo(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeRewardedVideo:
                        Tapdaq.getInstance().showRewardedVideo(cordova.getActivity(), tag, listener);
                        break;
                    case AdTypeOfferwall:
                        Tapdaq.getInstance().showOfferwall(cordova.getActivity(), listener);
                        break;
                     case AdTypeMoreApps:
                        Tapdaq.getInstance().showMoreApps(cordova.getActivity(), ((AdListener)listener).createMoreAppsListener());
                        break;
                    case AdTypeBanner:
                        showBanner(position, listener);
                        break;

                }
            }
        });
    }

    private void hide(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String adType = null;

                try{
                    adType = options.getString("adType");
                }catch (JSONException ex){
                }

                log("hide adType: " + adType);
                if (!adType.equals(AdType.AdTypeBanner.name())) {
                    callbackContext.error("Method hide available only for AdTypeBanner");
                    return;
                }

                hideBanner();
            }
        });
    }
    
    private void isReady(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String adType = null;
                String tag = null;

                try{
                    adType = options.getString("adType");
                }catch (JSONException ex){
                    String msg = "Tapdaq::isReady(): adType is required field";
                    error(msg);
                    callbackContext.error(msg);
                    return;
                }
                AdType type = AdType.valueOf(adType);
                
                try{
                    tag = options.getString("tag");
                }catch (JSONException ex){
                    if(type != AdType.AdTypeBanner && type != AdType.AdTypeOfferwall){
                        String msg = "Tapdaq::isReady(): tag is required field";
                        error(msg);
                        callbackContext.error(msg);
                        return;
                    }
                }
                
                if(adType != null){
                    Boolean res = false;                    
                    switch(type){
                        case AdTypeInterstitial : 
                            res = Tapdaq.getInstance().isInterstitialReady(cordova.getActivity(), tag);
                            break;
                        case AdTypeVideo : 
                            res = Tapdaq.getInstance().isVideoReady(cordova.getActivity(), tag);
                            break;
                        case AdTypeRewardedVideo : 
                            res = Tapdaq.getInstance().isRewardedVideoReady(cordova.getActivity(), tag);
                            break;  
                        case AdTypeOfferwall : 
                            res = Tapdaq.getInstance().isOfferwallReady(cordova.getActivity());
                            break;  
                        case AdTypeMoreApps : 
                            res = Tapdaq.getInstance().isMoreAppsReady(cordova.getActivity());
                            break; 
                        case AdTypeBanner : 
                            res = bannerAdView != null && bannerAdView.isReady();
                            break;  							
                        default: 
                            if(AdType.isNativeAd(type)){
                                res = Tapdaq.getInstance().isNativeAdvertReady(cordova.getActivity(), TapdaqHelper.GetCreativeTypesFromString(adType).get(0), tag);
                            }else{
                                callbackContext.error("Invalid adType is given: " + adType);
                                return;
                            }
                            break;
                    
                    }
                    
                    PluginResult result = new PluginResult(PluginResult.Status.OK, res);
                    result.setKeepCallback(true);
                    callbackContext.sendPluginResult(result);
                }
            }
        });
    }

    private void triggerNativeAdClick(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String adType = null;
                String tag = null;
                String id = null;

                try{
                    adType = options.getString("adType");
                    tag = options.getString("tag");
                    id = options.getString("id");
                }catch (JSONException ex){
                    error(ex.getMessage(), ex);
                }

                if(adType == null){
                    error("adType is required field");
                    return;
                }
                if(id == null){
                    error("id is required field");
                    return;
                }
                if(tag == null){
                    error("tag is required field");
                    return;
                }

                log("triggerNativeAdClick adType: " + adType + ", tag: " + tag + ", id:" + id);

                NativeAdListener listener = null;
                if(nativeAdListeners.containsKey(adType + "_" + tag)){
                    listener = nativeAdListeners.get(adType + "_" + tag);
                }
                if(listener != null){
                    TMNativeAd ad = listener.findAdByID(id);
                    if(ad != null){
                        ad.triggerClick(cordova.getActivity());
                        dispatchEvent("didClick", createEventResult(adType, tag, new JSONObject()), callbackContext);
                        log("native ad click is triggered for id: " + id);
                    }
                }
            }
        });
    }

    private void triggerNativeAdImpression(final JSONObject options, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {
            @Override
            public void run() {
                String adType = null;
                String tag = null;
                String id = null;

                try {
                    adType = options.getString("adType");
                    tag = options.getString("tag");
                    id = options.getString("id");
                } catch (JSONException ex) {
                    error(ex.getMessage(), ex);
                }

                if (adType == null) {
                    error("adType is required field");
                    return;
                }
                if (id == null) {
                    error("id is required field");
                    return;
                }
                if (tag == null) {
                    error("tag is required field");
                    return;
                }

                log("triggerNativeAdImpression adType: " + adType + ", tag: " + tag + ", id:" + id);

                NativeAdListener listener = null;
                if (nativeAdListeners.containsKey(adType + "_" + tag)) {
                    listener = nativeAdListeners.get(adType + "_" + tag);
                }
                if (listener != null) {
                    TMNativeAd ad = listener.findAdByID(id);
                    if (ad != null) {
                        dispatchEvent("willDisplay", createEventResult(adType, tag, new JSONObject()), callbackContext);
                        ad.triggerDisplay(cordova.getActivity());
                        dispatchEvent("didDisplay", createEventResult(adType, tag, new JSONObject()), callbackContext);
                        log("native ad impression is triggered for id: " + id);
                    }
                }
            }
        });
    }

    private void createBanner(TMAdSize size)
    {
        bannerAdView = new TMBannerAdView(cordova.getActivity());    
        createPopupWindow(size);    
    }

     private void createPopupWindow(TMAdSize size) {
        float scale = TMDevice.getDeviceScaleAsFloat(cordova.getActivity());
        float width = TMDevice.getWidth(cordova.getActivity());

        log("Creating PopupWindow with size : : " + size.width + "," + size.height + " and scale = " + scale + " and width = " + width);

        float intWidth = size.width == 0 ? width : size.width * scale;
        popupWindow = new PopupWindow(bannerAdView, (int)intWidth, (int)(size.height * scale));

        // Copy system UI visibility flags set on Unity player window to newly created PopUpWindow.
        int visibilityFlags = cordova.getActivity().getWindow().getAttributes().flags;
        popupWindow.getContentView().setSystemUiVisibility(visibilityFlags);

        // Workaround to prevent ad views from losing visibility on activity changes for certain
        // devices (eg. Huawei devices).
        TapdaqHelper.setPopUpWindowLayoutType(popupWindow,
                WindowManager.LayoutParams.TYPE_APPLICATION_SUB_PANEL);
    }

    /**
     * Show banner
     * @param String position
     */
    private void showBanner(final String position, TMAdListener listener) {
        if(bannerAdView == null){
            loadBanner(bannerType, listener);
        }
       
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                bannerAdView.setVisibility(View.VISIBLE);
                if (!popupWindow.isShowing()) {
                    popupWindow.showAtLocation(
                            cordova.getActivity().getWindow().getDecorView().getRootView(),
                            TapdaqHelper.GetBannerGravityFromString(position),
                            0, 0);
                }
            }
        });
    }

    private void hideBanner () {
        if(bannerAdView == null){
            return;
        }
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                bannerAdView.setVisibility(View.GONE);
                bannerAdView.destroy(cordova.getActivity());
                bannerAdView = null;
                popupWindow.dismiss();             
            }
        });
    }

    private void loadBanner(TMAdListener listener){
        loadBanner("", listener);
    }

    private void loadBanner (String bannerAdType, TMAdListener listener) {

        log("load banner: " + bannerAdType);
        bannerType = bannerAdType;
        TMAdSize bannerAdSizes = TapdaqHelper.GetBannerSizeFromTypeString(bannerAdType);
        if (bannerAdView == null) {
            createBanner(bannerAdSizes);            
        }        
        bannerAdView.load(cordova.getActivity(), bannerAdSizes, listener);
    }

    private void dispatchEvent(String eventName, JSONObject eventData, CallbackContext callbackContext)
    {
        log("dispatchEvent: " + eventName + ", with data: " + eventData.toString());
        try {
            JSONObject res = new JSONObject();
            res.put("event", eventName);
            res.put("eventData", eventData);
            PluginResult result = new PluginResult(PluginResult.Status.OK, res);
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);
        }catch (JSONException e){
            error(e.getMessage(), e);
            callbackContext.error("dispatch event "+eventName+" error");
        }
    }


    protected JSONObject createEventResult(String type, String tag, JSONObject customFields)
    {
        JSONObject eventData = null;
        try {
            eventData = new JSONObject();
            eventData.put("adType", type);
            eventData.put("message", "");
            if (tag != null) {
                eventData.put("tag", tag);
            }
            if(customFields != null){
                Iterator<String> iter = customFields.keys();
                while (iter.hasNext()) {
                    String key = iter.next();
                    String value = customFields.getString(key);
                    eventData.put(key, value);
                }
            }
        }catch (JSONException e){
            error(e.getMessage(), e);
        }
        return eventData;
    }

    private boolean validateInitOptions(JSONObject options)
    {
        JSONObject androidOpts = null;
        JSONArray enabledPlacements = null;
        String appId = null;
        String clientKey = null;
        try{
            androidOpts = options.getJSONObject("android");
            appId = androidOpts.getString("appId");
            clientKey = androidOpts.getString("clientKey");
        }catch (JSONException ex){
        }
        if(androidOpts == null){
            error("options should contain 'android' option");
            return false;
        }

        if(appId == null){
            error("appId is a required field in options");
            return false;
        }

        if(clientKey == null){
            error("clientkey is a required field in options");
            return false;
        }

        try{
            enabledPlacements = options.getJSONArray("enabledPlacements");
        }catch (JSONException ex){
        }
        if(enabledPlacements == null){
            error("options should contain 'enabledPlacements' option");
            return false;
        }
        return true;

    }

    private boolean validateLoadOptions(JSONObject options)
    {
        String adType = null;

        try{
            adType = options.getString("adType");
        }catch (JSONException ex){
        }
        if(adType == null){
            error("options should contain 'adType' option");
            return false;
        }

        if(!availableAdTypes.contains(adType)){
            error("adType has invalid value : '"+adType+"', should be in the list: " + join(", ", availableAdTypes));
            return false;
        }

        return true;

    }

    private boolean validateShowOptions(JSONObject options)
    {
        String adType = null;
        String tag = null;

        try{
            adType = options.getString("adType");
            tag = options.getString("tag");
        }catch (JSONException ex){
        }
        if(adType == null){
            error("options should contain 'adType' option");
            return false;
        }

        if(tag == null){
            error("tag is a required field in options");
            return false;
        }

        if(!availableAdTypes.contains(adType)){
            error("adType has invalid value : '"+adType+"', should be in the list: " + join(", ", availableAdTypes));
            return false;
        }

        return true;

    }

    private String join(String separator, List<String> list)
    {
        StringBuilder builder = new StringBuilder();
        for(int i = 0; i< list.size(); i++){
            builder.append(list.get(i));
            if(i < list.size()-1){
                builder.append(separator);
            }
        }
        return builder.toString();
    }

    private void log(String data)
    {
        if(debugging) {
            Log.i(TAG, data);
        }
    }

    private void error(String data)
    {
        Log.e(TAG, data);
    }

    private void error(String message, Throwable ex)
    {
        Log.e(TAG, message, ex);
    }

}
