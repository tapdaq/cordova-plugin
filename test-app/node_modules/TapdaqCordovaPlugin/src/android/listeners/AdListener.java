package com.tapdaq.cordovasdk.listeners;

import com.tapdaq.sdk.common.TMAdError;
import com.tapdaq.sdk.listeners.TMAdListener;
import com.tapdaq.sdk.moreapps.TMMoreAppsListener;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.apache.cordova.LOG;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.Override;
import java.util.Iterator;
import java.util.Map;
import java.util.HashMap;

public class AdListener extends TMAdListener {

    static String TAG = "Tapdaq Cordova Plugin";

    protected String type = "";
    protected String tag = null;
    protected CallbackContext callbackContext = null;
        
    private class MoreAppsListener extends TMMoreAppsListener{
        private AdListener adListener = null;
        MoreAppsListener(AdListener adListener){
            this.adListener = adListener;
        }
        
        @Override
        public void didClose() {
            this.adListener.didClose();
        }

        @Override
        public void didFailToLoad(TMAdError error) {
            this.adListener.didFailToLoad(error);
        }

        @Override
        public void willDisplay() {
            this.adListener.willDisplay();
        }

        @Override
        public void didDisplay() {
            this.adListener.didDisplay();
        }

        @Override
        public void didLoad() {
            this.adListener.didLoad();
        }
    }

    public AdListener(String type, String tag, CallbackContext callbackContext)
    {
        this.tag = tag;
        this.type = type;
        this.callbackContext = callbackContext;        
    }

    protected void dispatchEvent(String eventName){
        dispatchEvent(eventName, null);
    }
    
    public TMMoreAppsListener createMoreAppsListener(){
        return new MoreAppsListener(this);
    }

    protected void dispatchEvent(String eventName, JSONObject eventData)
    {
        if(eventData == null){
            eventData = new JSONObject();
        }
        LOG.d(TAG, "dispatchEvent: " + eventName + ", with data: " + eventData.toString());
        try {
            JSONObject res = new JSONObject();
            res.put("event", eventName);
            res.put("eventData", eventData);
            PluginResult result = new PluginResult(PluginResult.Status.OK, res);
            result.setKeepCallback(true);
            callbackContext.sendPluginResult(result);
        }catch (JSONException e){
            LOG.e(TAG, e.getMessage(), e);
            callbackContext.error("dispatch event "+eventName+" error");
        }
    }

    protected JSONObject createEventResult()
    {
        return createEventResult("", null);
    }

    protected JSONObject createEventResult(String message)
    {
        return createEventResult(message, null);
    }

    protected JSONObject createEventResult(String message, JSONObject customFields)
    {
        JSONObject eventData = null;
        try {
            eventData = new JSONObject();
            eventData.put("adType", type);
            eventData.put("message", message);
            if (type != "AdTypeBanner" && tag != null) {
                eventData.put("tag", tag);
            }
            if(customFields != null){
                Iterator<String> iter = customFields.keys();
                while (iter.hasNext()) {
                    String key = (String)iter.next();
                    String value = customFields.getString(key);
                    eventData.put(key, value);
                }
            }
        }catch (JSONException e){
            LOG.e(TAG, e.getMessage(), e);
        }
        return eventData;
    }
    
    protected JSONObject createEventResult(Map<Object, Object> customFields)
    {
        JSONObject eventData = this.createEventResult();
        for (Map.Entry<Object, Object> entry : customFields.entrySet())
        {            
            try{
                String key = (String)entry.getKey();
                String value = this.castToString(entry.getValue());
               eventData.put((String)entry.getKey(), value);
            }catch(Exception ex){
                LOG.e(TAG, ex.getMessage(), ex);
            }
            
        }                        
        return eventData;
    }

    private String castToString(Object input){
        String value = null;
        try{
            value = (String)input;                                  
        }catch(ClassCastException e){            
        }

        // try to cast to Integer
        if(value == null){
            Integer intValue = null;
            try{
                intValue = (Integer)input;                                  
            }catch(ClassCastException e){            
            }
            if(intValue != null){
                value = String.valueOf(intValue);
            }
        }

        // try to cast to Float
        if(value == null){
            Float floatValue = null;
            try{
                floatValue = (Float)input;                                  
            }catch(ClassCastException e){            
            }
            if(floatValue != null){
                value = String.valueOf(floatValue);
            }
        }

        // try to cast to Float
        if(value == null){
            Boolean boolValue = null;
            try{
                boolValue = (Boolean)input;                                  
            }catch(ClassCastException e){            
            }
            if(boolValue != null){
                value = String.valueOf(boolValue);
            }
        }

        return value;
    }

    @Override
    public void didClose()
    {
        dispatchEvent("didClose", createEventResult());
    }

    @Override
    public void didFailToLoad(TMAdError error)
    {
        dispatchEvent("didFailToLoad", createEventResult(error.getErrorMessage()));
    }

    @Override
    public void didClick()
    {
        dispatchEvent("didClick", createEventResult());
    }

    @Override
    public void willDisplay()
    {
        dispatchEvent("willDisplay", createEventResult());
    }

    @Override
    public void didDisplay()
    {
        dispatchEvent("didDisplay", createEventResult());
    }

    @Override
    public void didLoad()
    {
        dispatchEvent("didLoad", createEventResult("LOADED"));
    }
	
	//TMRewardAdListenerBase
    @Override
    public void didRewardFail(TMAdError error) {
		dispatchEvent("didRewardFail", createEventResult(error.getErrorMessage()));
    }

    @Override
    public void onUserDeclined()
    {
        dispatchEvent("onUserDeclined", createEventResult());
    }

    @Override
     public void didVerify(String location, String reward, int value, boolean rewardValid, Map<Object, Object> customData) {    
        customData.put("location", location);
        customData.put("rewardName", reward);
        customData.put("rewardAmount", value);
        customData.put("rewardValid", rewardValid);
        dispatchEvent("didVerify", createEventResult(customData));
    }

    @Override
    public void didEngagement()
    {
        dispatchEvent("didEngagement", createEventResult());
    }

  
    @Override
    public void didComplete()
    {
        dispatchEvent("didComplete", createEventResult());
    }
    
    @Override
    public void didCustomEvent(Map<Object, Object> eventData) {
      dispatchEvent("didCustomEvent", createEventResult(eventData));
    }

}
