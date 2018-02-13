package com.tapdaq.cordovasdk;

import android.view.Gravity;
import android.graphics.Color;
import android.view.WindowManager;
import android.widget.PopupWindow;

import com.tapdaq.sdk.CreativeType;
import com.tapdaq.sdk.common.TMBannerAdSizes;
import com.tapdaq.sdk.model.TMAdSize;
import com.tapdaq.sdk.moreapps.TMMoreAppsConfig;
import com.tapdaq.sdk.helpers.TLog;

import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class TapdaqHelper {

    private static boolean IsTypeOf(String obj, List<String> typeStrings) {
        for(String typeString: typeStrings)
            if(typeString.equalsIgnoreCase(obj))
                return true;

        return false;
    }

    public static List<CreativeType> GetCreativeTypesFromString(String type) {

        if (IsTypeOf(type, Arrays.asList("TDAdTypeInterstitial", "AdTypeInterstitial"))) {
            return Arrays.asList(CreativeType.INTERSTITIAL_LANDSCAPE, CreativeType.INTERSTITIAL_PORTRAIT);
        }
        if (IsTypeOf(type, Arrays.asList("TDAdTypeVideo", "AdTypeVideo"))) {
            return Arrays.asList(CreativeType.VIDEO_INTERSTITIAL);
        }
        if (IsTypeOf(type, Arrays.asList("TDAdTypeRewardedVideo", "AdTypeRewardedVideo"))) {
            return Arrays.asList(CreativeType.REWARDED_VIDEO_INTERSTITIAL);
        }
        if (IsTypeOf(type, Arrays.asList("TDAdTypeBanner", "AdTypeBanner"))) {
            return Arrays.asList(CreativeType.BANNER);
        }

        if (IsTypeOf(type, Arrays.asList("TDAdTypeMoreApps", "AdTypeMoreApps"))) {
            return Arrays.asList(CreativeType.SQUARE_MEDIUM);
        }
        // 1x1
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x1Large", "TDAdType1x1Large"))) {
            return Arrays.asList(CreativeType.SQUARE_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x1Medium", "TDAdType1x1Medium"))) {
            return Arrays.asList(CreativeType.SQUARE_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x1Small", "TDAdType1x1Small"))) {
            return Arrays.asList(CreativeType.SQUARE_SMALL);
        }
        // 1x2
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x2Large", "TDAdType1x2Large"))) {
            return Arrays.asList(CreativeType.NEWSFEED_TALL_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x2Medium", "TDAdType1x2Medium"))) {
            return Arrays.asList(CreativeType.NEWSFEED_TALL_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x2Small", "TDAdType1x2Small"))) {
            return Arrays.asList(CreativeType.NEWSFEED_TALL_SMALL);
        }
        // 2x1
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x1Large", "TDAdType2x1Large"))) {
            return Arrays.asList(CreativeType.NEWSFEED_WIDE_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x1Medium", "TDAdType2x1Medium"))) {
            return Arrays.asList(CreativeType.NEWSFEED_WIDE_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x1Small", "TDAdType2x1Small"))) {
            return Arrays.asList(CreativeType.NEWSFEED_WIDE_SMALL);
        }
        // 2x3
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x3Large", "TDAdType2x3Large"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_TALL_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x3Medium", "TDAdType2x3Medium"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_TALL_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType2x3Small", "TDAdType2x3Small"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_TALL_SMALL);
        }
        // 3x2
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType3x2Large", "TDAdType3x2Large"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_WIDE_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType3x2Medium", "TDAdType3x2Medium"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_WIDE_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType3x2Small", "TDAdType3x2Small"))) {
            return Arrays.asList(CreativeType.FULLSCREEN_WIDE_SMALL);
        }
        // 1x5
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x5Large", "TDAdType1x5Large"))) {
            return Arrays.asList(CreativeType.STRIP_TALL_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x5Medium", "TDAdType1x5Medium"))) {
            return Arrays.asList(CreativeType.STRIP_TALL_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType1x5Small", "TDAdType1x5Small"))) {
            return Arrays.asList(CreativeType.STRIP_TALL_SMALL);
        }
        // 5x1
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType5x1Large", "TDAdType5x1Large"))) {
            return Arrays.asList(CreativeType.STRIP_WIDE_LARGE);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType5x1Medium", "TDAdType5x1Medium"))) {
            return Arrays.asList(CreativeType.STRIP_WIDE_MEDIUM);
        }
        if (IsTypeOf(type, Arrays.asList("TDNativeAdType5x1Small", "TDAdType5x1Small"))) {
            return Arrays.asList(CreativeType.STRIP_WIDE_SMALL);
        }
        // default:
        return Arrays.asList(CreativeType.SQUARE_LARGE);
    }

    public static TMAdSize GetBannerSizeFromTypeString(String bannerAdType) {

        TMAdSize bannerAdSizes;

        if (bannerAdType.equalsIgnoreCase("LARGE")) {
            bannerAdSizes = TMBannerAdSizes.LARGE;
        }
        else if (bannerAdType.equalsIgnoreCase("MEDIUM_RECT")) {
            bannerAdSizes = TMBannerAdSizes.MEDIUM_RECT;
        }
        else if (bannerAdType.equalsIgnoreCase("FULL")) {
            bannerAdSizes = TMBannerAdSizes.FULL;
        }
        else if (bannerAdType.equalsIgnoreCase("LEADERBOARD")) {
            bannerAdSizes = TMBannerAdSizes.LEADERBOARD;
        }
        else if (bannerAdType.equalsIgnoreCase("SMART")) {
            bannerAdSizes = TMBannerAdSizes.SMART;
        }
        else {
            bannerAdSizes = TMBannerAdSizes.STANDARD;
        }

        return bannerAdSizes;
    }

    public static int GetBannerGravityFromString(String position) {
        if(position.equalsIgnoreCase("top")) {
            return Gravity.TOP | Gravity.CENTER_HORIZONTAL;
        }

        return Gravity.BOTTOM | Gravity.CENTER_HORIZONTAL;
    }
    
     public static TMMoreAppsConfig createMoreAppsConfigFromJSON(JSONObject json) {
        TMMoreAppsConfig config = new TMMoreAppsConfig();

        try {            
            TLog.debug(json.toString());
            if (json.has("placementTagPrefix"))
                config.setPlacementPrefix(json.getString("placementTagPrefix"));
            if (json.has("headerText"))
                config.setHeaderText(json.getString("headerText"));
            if (json.has("installedButtonText"))
                config.setInstalledButtonText("installedButtonText");
            if (json.has("headerTextColor")) {
                String hex = json.getString("headerTextColor");
                config.setHeaderTextColor(Color.parseColor(hex));
            }
            if (json.has("headerColor")) {
                String hex = json.getString("headerColor");
                config.setHeaderColor(Color.parseColor(hex));
            }
            if (json.has("headerCloseButtonColor")) {
                String hex = json.getString("headerCloseButtonColor");
                config.setHeaderCloseButtonColor(Color.parseColor(hex));
            }
            if (json.has("backgroundColor")) {
                String hex = json.getString("backgroundColor");
                config.setBackgroundColor(Color.parseColor(hex));
            }
            if (json.has("appNameColor")) {
                String hex = json.getString("appNameColor");
                config.setAppNameColor(Color.parseColor(hex));
            }
            if (json.has("appButtonColor")) {
                String hex = json.getString("appButtonColor");
                config.setAppButtonColor(Color.parseColor(hex));
            }
            if (json.has("appButtonTextColor")) {
                String hex = json.getString("appButtonTextColor");
                config.setAppButtonTextColor(Color.parseColor(hex));
            }
            if (json.has("installedAppButtonColor")) {
                String hex = json.getString("installedAppButtonColor");
                config.setInstalledAppButtonColor(Color.parseColor(hex));
            }
            if (json.has("installedAppButtonTextColor")) {
                String hex = json.getString("installedAppButtonTextColor");
                config.setInstalledAppButtonTextColor(Color.parseColor(hex));
            }

        } catch (JSONException e) {
            TLog.error(e);
        }


        return config;
    }

    public static void setPopUpWindowLayoutType(PopupWindow popupWindow, int layoutType) {
        try {
            Method method = PopupWindow.class.getDeclaredMethod("setWindowLayoutType", int.class);
            method.setAccessible(true);
            method.invoke(popupWindow, layoutType);
        } catch (NoSuchMethodException exception) {
            TLog.warning(String.format("Unable to set popUpWindow window layout type: %s",
                    exception.getLocalizedMessage()));
        } catch (IllegalAccessException exception) {
            TLog.warning(String.format("Unable to set popUpWindow window layout type: %s",
                    exception.getLocalizedMessage()));
        } catch (InvocationTargetException exception) {
            TLog.debug(String.format("Unable to set popUpWindow window layout type: %s",
                    exception.getLocalizedMessage()));
        }
    }

}