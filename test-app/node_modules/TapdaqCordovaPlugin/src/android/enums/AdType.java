package com.tapdaq.cordovasdk.enums;

 public enum AdType {
	AdTypeInterstitial,
	AdTypeBanner,
	AdTypeVideo,
	AdTypeRewardedVideo,
	AdTypeOfferwall,     
	AdTypeMoreApps,   
	 // 1x1
	NativeAdType1x1Large,
	NativeAdType1x1Medium,
	NativeAdType1x1Small,
	// 1x2
	NativeAdType1x2Large,
	NativeAdType1x2Medium,
	NativeAdType1x2Small,

	//2x1
	NativeAdType2x1Large,
	NativeAdType2x1Medium,
	NativeAdType2x1Small,

	// 2x3
	NativeAdType2x3Large,
	NativeAdType2x3Medium,
	NativeAdType2x3Small,

	// 3x2
	NativeAdType3x2Large,
	NativeAdType3x2Medium,
	NativeAdType3x2Small,

	//
	NativeAdType1x5Large,
	NativeAdType1x5Medium,
	NativeAdType1x5Small,
	// 5x1
	NativeAdType5x1Large,
	NativeAdType5x1Medium,
	NativeAdType5x1Small;
	
	public static String[] names() {
		AdType[] states = values();
		String[] names = new String[states.length];
		for (int i = 0; i < states.length; i++) {
			names[i] = states[i].name();
		}
		return names;
	}
	
	public static boolean isNativeAd(AdType type) {
		AdType[] states = values();
		boolean res = false;
		for (int i = 0; i < states.length; i++) {
			if(type == states[i]){
				res = true;
				break;
			}
		}
		return res;
	}
}