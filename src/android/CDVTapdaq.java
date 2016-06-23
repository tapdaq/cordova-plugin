package com.tapdaq.cordova;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;
import android.content.Context;
import android.content.res.Configuration;

import java.util.Map;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ArrayList;

import com.tapdaq.sdk.*;

/**
* This class echoes a string called from JavaScript.
*/
public class CDVTapdaq extends CordovaPlugin {

  private static final String ACTION_SET_OPTIONS = "setOptions";
  private static final String ACTION_INIT = "init";
  private static final String ACTION_SHOW_INTERSTITIAL = "showInterstitial";

  private static final String CONFIG_TEST_MODE = "testMode";
  private static final String CONFIG_ORIENTATION = "orientation";
  private static final String CONFIG_TRACK_INSTALLS_ONLY = "trackInstallsOnly";

  private static final String CONFIG_ORIENTATION_UNIVERSAL = "universal";
  private static final String CONFIG_ORIENTATION_PORTRAIT = "portrait";
  private static final String CONFIG_ORIENTATION_LANDSCAPE = "landscape";

  private static final String RESULT_EVENT_KEY = "event";
  private static final String RESULT_WILL_DISPLAY_INTERSTITIAL = "willDisplayInterstitial";
  private static final String RESULT_DID_DISPLAY_INTERSTITIAL = "didDisplayInterstitial";
  private static final String RESULT_DID_FAIL_TO_DISPLAY_INTERSTITIAL = "didFailToDisplayInterstitial";
  private static final String RESULT_DID_CLOSE_INTERSTITIAL = "didCloseInterstitial";
  private static final String RESULT_DID_CLICK_INTERSTITIAL = "didClickInterstitial";
  private static final String RESULT_DID_FAIL_TO_REACH_SERVER = "didFailToFetchInterstitialsFromServer";
  private static final String RESULT_HAS_NO_INTERSTITIALS_AVAILABLE = "hasNoInterstitialsAvailable";
  private static final String RESULT_HAS_INTERSTITIALS_AVAILABLE = "hasInterstitialsAvailableForOrientation";

  private static final String RESULT_EVENT_MESSAGE = "message";
  private static final String RESULT_EVENT_MESSAGE_ORIENTATION = "orientation";

  private boolean testMode;
  private String orientation;
  private boolean trackInstallsOnly;

  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

    boolean shouldExecute = false;

    if (action.equals(ACTION_SET_OPTIONS) && !args.isNull(0)) {

      JSONObject jsonMessage = args.getJSONObject(0);
      Map<String, Object> messageMap = this.getMapFromJSONObject(jsonMessage);

      handleSetOptions(messageMap, callbackContext);
      shouldExecute = true;

    } else if (action.equals(ACTION_INIT) && !args.isNull(0) && !args.isNull(1)) {

      String appId = args.getString(0);
      String clientKey = args.getString(1);

      handleInit(appId, clientKey, callbackContext);
      shouldExecute = true;

    } else if (action.equals(ACTION_SHOW_INTERSTITIAL)) {

      handleShowInterstitial(callbackContext);
      shouldExecute = true;

    }

    return shouldExecute;

  }

  private void handleSetOptions(Map<String, Object> options, CallbackContext callbackContext) {


    if (options.get(CONFIG_TEST_MODE) != null) {
      this.testMode = (Boolean) options.get(CONFIG_TEST_MODE);
    } else {
      this.testMode = false;
    }

    if (options.get(CONFIG_ORIENTATION) != null) {
      this.orientation = (String) options.get(CONFIG_ORIENTATION);
    } else {
      this.orientation = "";
    }

    if (options.get(CONFIG_TRACK_INSTALLS_ONLY) != null) {
      this.trackInstallsOnly = (Boolean) options.get(CONFIG_TRACK_INSTALLS_ONLY);
    } else {
      this.trackInstallsOnly = false;
    }

    PluginResult pr = new PluginResult(PluginResult.Status.OK);
    callbackContext.sendPluginResult(pr);

  }

  private void handleInit(String applicationId, String clientKey, CallbackContext callbackContext) {

    List<CreativeType> creativesTypesEnabled = new ArrayList<CreativeType>();

    Tapdaq.tapdaq().initializeWithConfiguration()
      .withTestAdvertsEnabled(this.testMode)
      .initialize(applicationId,
                  clientKey,
                  this.cordova.getActivity(),
                  new CDVTapdaqCallbacks(this.cordova.getActivity(), callbackContext));

    PluginResult pr = new PluginResult(PluginResult.Status.OK);
    pr.setKeepCallback(true);
    callbackContext.sendPluginResult(pr);

  }

  private void handleShowInterstitial(CallbackContext callbackContext) {

    Tapdaq.tapdaq().displayInterstitial(this.cordova.getActivity());

    PluginResult pr = new PluginResult(PluginResult.Status.OK);
    callbackContext.sendPluginResult(pr);

  }

  private Map<String, Object> getMapFromJSONObject(JSONObject object) throws JSONException {

    Map<String, Object> map = new HashMap<String, Object>();
    Iterator<?> i = object.keys();

    while (i.hasNext()) {
      String key = (String) i.next();
      map.put(key, object.get(key));
    }

    return map;

  }

  public class CDVTapdaqCallbacks extends TapdaqCallbacks {

    private final Context context;
    private CallbackContext callbackContext;

    public CDVTapdaqCallbacks(final Context context, CallbackContext callbackContext) {
      this.context = context;
      this.callbackContext = callbackContext;
    }

    @Override
    public void willDisplayInterstitial() {

      sendEvent(RESULT_WILL_DISPLAY_INTERSTITIAL);

    }

    @Override
    public void didDisplayInterstitial() {

      sendEvent(RESULT_DID_DISPLAY_INTERSTITIAL);

    }

    @Override
    public void didFailToDisplayInterstitial() {

      sendEvent(RESULT_DID_FAIL_TO_DISPLAY_INTERSTITIAL);

    }

    @Override
    public void didCloseInterstitial() {

      sendEvent(RESULT_DID_CLOSE_INTERSTITIAL);

    }

    @Override
    public void didClickInterstitial() {

      sendEvent(RESULT_DID_CLICK_INTERSTITIAL);

    }

    @Override
    public void didFailToReachServer() {

      sendEvent(RESULT_DID_FAIL_TO_REACH_SERVER);

    }

    @Override
    public void hasNoLandscapeInterstitialAvailable() {

      if (!isPortrait()) {
        sendEvent(RESULT_HAS_NO_INTERSTITIALS_AVAILABLE);
      }

    }

    @Override
    public void hasNoPortraitInterstitialAvailable() {

      if (isPortrait()) {
        sendEvent(RESULT_HAS_NO_INTERSTITIALS_AVAILABLE);
      }

    }

    @Override
    public void hasPortraitInterstitialAvailable() {

      hasInterstitialsAvailableForOrientation("portrait");

    }

    @Override
    public void hasLandscapeInterstitialAvailable() {

      hasInterstitialsAvailableForOrientation("landscape");

    }

    private void hasInterstitialsAvailableForOrientation(String orientation) {

      Map<String, Object> map = new HashMap<String, Object>();
      map.put(RESULT_EVENT_MESSAGE_ORIENTATION, orientation);

      sendEventWithMessage(RESULT_HAS_INTERSTITIALS_AVAILABLE, map);

    }

    private void sendEvent(String eventValue) {

      sendEventWithMessage(eventValue, null);

    }

    private void sendEventWithMessage(String eventValue, Map<String, Object> message) {

      Map<String, Object> map = new HashMap<String, Object>();
      map.put(RESULT_EVENT_KEY, eventValue);

      if (message != null) {
        map.put(RESULT_EVENT_MESSAGE, message);
      }

      JSONObject jsonResponse = new JSONObject(map);

      PluginResult pr = new PluginResult(PluginResult.Status.OK, jsonResponse);
      pr.setKeepCallback(true);
      this.callbackContext.sendPluginResult(pr);

    }

    private boolean isPortrait() {

      boolean isPortrait = true;

      int orientation = this.context.getResources().getConfiguration().orientation;
      if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
        isPortrait = false;
      }

      return isPortrait;

    }

  }

}
