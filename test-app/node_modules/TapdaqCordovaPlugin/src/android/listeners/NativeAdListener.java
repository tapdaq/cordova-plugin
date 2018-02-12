package com.tapdaq.cordovasdk.listeners;

import android.app.Activity;

import com.tapdaq.cordovasdk.TapdaqHelper;
import com.tapdaq.sdk.CreativeType;
import com.tapdaq.sdk.TMNativeAd;
import com.tapdaq.sdk.Tapdaq;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.LOG;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by a.itsekson on 17.02.2017.
 */
public class NativeAdListener extends AdListener{

    private Activity context;

    private Map<String, TMNativeAd> loadedAds = null;

    public NativeAdListener(String type, String tag, Activity context, CallbackContext callbackContext)
    {
        super(type, tag, callbackContext);
        this.context = context;
        loadedAds = new HashMap<String, TMNativeAd>();
    }

    /**
     *
     * @param String id
     * @return TMNativeAd
     */
    public TMNativeAd findAdByID(String id)
    {
        TMNativeAd ad = null;
        if(loadedAds.containsKey(id)){
            ad = loadedAds.get(id);
        }
        return ad;
    }

    @Override
    public void didLoad()
    {
        CreativeType creativeType = TapdaqHelper.GetCreativeTypesFromString(type).get(0);
        LOG.d(TAG, "Fetching Native ad");

        TMNativeAd nativeAd = Tapdaq.getInstance().getNativeAdvert(context, creativeType, tag, this);
        loadedAds.put(nativeAd.getID(), nativeAd);
        JSONObject adData = convertToJSON(nativeAd);
        dispatchEvent("didLoad", createEventResult("", adData));
    }

    private JSONObject convertToJSON(TMNativeAd nativeAd)
    {
        JSONObject json = new JSONObject();
        try {
            json.put("appName", nativeAd.getAppName());
            json.put("description", nativeAd.getDescription());
            json.put("developerName", nativeAd.getDeveloperName());
            json.put("ageRating", nativeAd.getAgeRating());
            json.put("appSize", nativeAd.getAppSize());
            json.put("averageReview", nativeAd.getAverageReview());
            json.put("totalReviews", nativeAd.getTotalReviews());
            json.put("category", nativeAd.getCategory());
            json.put("appVersion", nativeAd.getAppVersion());
            json.put("price", nativeAd.getPrice());
            json.put("currency", nativeAd.getCurrency());
            json.put("iconUrl", nativeAd.getIconUrl());
            json.put("title", nativeAd.getTitle());
            json.put("imageUrl", nativeAd.getImageUrl());
            json.put("uniqueId", nativeAd.getID());
        } catch (JSONException e) {
            LOG.e(TAG, e.getMessage(), e);
        }
        return json;
    }
}
