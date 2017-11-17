package com.charlesbodman.cordova.plugin.ironsource;

import android.util.Log;
import android.text.TextUtils;
import android.os.AsyncTask;
import android.view.Gravity;
import android.view.ViewGroup.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.ironsource.adapters.supersonicads.SupersonicConfig;
import com.ironsource.mediationsdk.IronSource;
import com.ironsource.mediationsdk.IronSourceBannerLayout;
import com.ironsource.mediationsdk.EBannerSize;
import com.ironsource.mediationsdk.integration.IntegrationHelper;
import com.ironsource.mediationsdk.logger.IronSourceError;
import com.ironsource.mediationsdk.model.Placement;
import com.ironsource.mediationsdk.sdk.InterstitialListener;
import com.ironsource.mediationsdk.sdk.OfferwallListener;
import com.ironsource.mediationsdk.sdk.RewardedVideoListener;
import com.ironsource.mediationsdk.sdk.BannerListener;

public class IronSourceAdsPlugin extends CordovaPlugin
        implements RewardedVideoListener, OfferwallListener, InterstitialListener {

    private final String FALLBACK_USER_ID = "userId";

    private static final String TAG = "[IronSourceAdsPlugin]";

    private static final String EVENT_INTERSTITIAL_LOADED = "interstitialLoaded";
    private static final String EVENT_INTERSTITIAL_SHOWN = "interstitialShown";
    private static final String EVENT_INTERSTITIAL_SHOW_FAILED = "interstitialShowFailed";
    private static final String EVENT_INTERSTITIAL_CLICKED = "interstitialClicked";
    private static final String EVENT_INTERSTITIAL_CLOSED = "interstitialClosed";
    private static final String EVENT_INTERSTITIAL_WILL_OPEN = "interstitialWillOpen";
    private static final String EVENT_INTERSTITIAL_FAILED_TO_LOAD = "interstitialFailedToLoad";

    private static final String EVENT_OFFERWALL_CLOSED = "offerwallClosed";
    private static final String EVENT_OFFERWALL_CREDIT_FAILED = "offerwallCreditFailed";
    private static final String EVENT_OFFERWALL_CREDITED = "offerwallCreditReceived";
    private static final String EVENT_OFFERWALL_SHOW_FAILED = "offerwallShowFailed";
    private static final String EVENT_OFFERWALL_SHOWN = "offerwallShown";
    private static final String EVENT_OFFERWALL_AVAILABILITY_CHANGED = "offerwallAvailabilityChanged";

    private static final String EVENT_REWARDED_VIDEO_FAILED = "rewardedVideoFailed";
    private static final String EVENT_REWARDED_VIDEO_REWARDED = "rewardedVideoRewardReceived";
    private static final String EVENT_REWARDED_VIDEO_ENDED = "rewardedVideoEnded";
    private static final String EVENT_REWARDED_VIDEO_STARTED = "rewardedVideoStarted";
    private static final String EVENT_REWARDED_VIDEO_AVAILABILITY_CHANGED = "rewardedVideoAvailabilityChanged";
    private static final String EVENT_REWARDED_VIDEO_CLOSED = "rewardedVideoClosed";
    private static final String EVENT_REWARDED_VIDEO_OPENED = "rewardedVideoOpened";

    private static final String EVENT_BANNER_DID_LOAD = "bannerDidLoad";
    private static final String EVENT_BANNER_FAILED_TO_LOAD = "bannerFailedToLoad";
    private static final String EVENT_BANNER_DID_CLICK = "bannerDidClick";
    private static final String EVENT_BANNER_WILL_PRESENT_SCREEN = "bannerWillPresentScreen";
    private static final String EVENT_BANNER_DID_DISMISS_SCREEN = "bannerDidDismissScreen";
    private static final String EVENT_BANNER_WILL_LEAVE_APPLICATION = "bannerWillLeaveApplication";

    private IronSourceBannerLayout mIronSourceBannerLayout;

    private RelativeLayout bannerContainerLayout;

    private CordovaWebView cordovaWebView;

    private FrameLayout parentLayout;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {

        if (action.equals("init")) {
            this.initAction(args, callbackContext);
            return true;
        }

        else if (action.equals("setDynamicUserId")) {
            this.setDynamicUserIdAction(args, callbackContext);
            return true;
        }

        else if (action.equals("validateIntegration")) {
            this.validateIntegrationAction(args, callbackContext);
            return true;
        }

        else if (action.equals("showRewardedVideo")) {
            this.showRewardedVideoAction(args, callbackContext);
            return true;
        }

        else if (action.equals("hasRewardedVideo")) {
            this.hasRewardedVideoAction(args, callbackContext);
            return true;
        }

        else if (action.equals("isRewardedVideoCappedForPlacement")) {
            this.isRewardedVideoCappedForPlacementAction(args, callbackContext);
            return true;
        }

        else if (action.equals("showBanner")) {
            this.showBannerAction(args, callbackContext);
            return true;
        }

        else if (action.equals("hideBanner")) {
            this.hideBannerAction(args, callbackContext);
            return true;
        }

        else if (action.equals("hasOfferwall")) {
            this.hasOfferwallAction(args, callbackContext);
            return true;
        }

        else if (action.equals("showOfferwall")) {
            this.showOfferwallAction(args, callbackContext);
            return true;
        }

        else if (action.equals("loadInterstitial")) {
            this.loadInterstitialAction(args, callbackContext);
            return true;
        }

        else if (action.equals("hasInterstitial")) {
            this.hasInterstitialAction(args, callbackContext);
            return true;
        }

        else if (action.equals("showInterstitial")) {
            this.showInterstitialAction(args, callbackContext);
            return true;
        }

        return false;
    }

    /**--------------------------------------------------------------- */

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        cordovaWebView = webView;
        super.initialize(cordova, webView);
    }

    @Override
    public void onPause(boolean multitasking) {
        super.onPause(multitasking);
        IronSource.onPause(this.cordova.getActivity());
    }

    @Override
    public void onResume(boolean multitasking) {
        super.onResume(multitasking);
        IronSource.onResume(this.cordova.getActivity());
    }

    /**----------------------- UTILS --------------------------- */

    private JSONObject createErrorJSON(IronSourceError ironSourceError) {
        JSONObject data = new JSONObject();
        JSONObject errorData = new JSONObject();
        try {
            errorData.put("code", ironSourceError.getErrorCode());
            errorData.put("message", ironSourceError.getErrorMessage());
            data.put("error", errorData);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return data;
    }

    private void emitWindowEvent(final String event) {
        final CordovaWebView view = this.webView;
        this.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                view.loadUrl(String.format("javascript:cordova.fireWindowEvent('%s');", event));
            }
        });
    }

    private void emitWindowEvent(final String event, final JSONObject data) {
        final CordovaWebView view = this.webView;
        this.cordova.getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                view.loadUrl(String.format("javascript:cordova.fireWindowEvent('%s', %s);", event, data.toString()));
            }
        });
    }

    /**----------------------- INITIALIZATION  --------------------------- */

    /**
     * Intilization action
     * Initializes IronSource
     */
    private void initAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final String appKey = args.getString(0);
        final String providedUserId = args.getString(1);

        final IronSourceAdsPlugin self = this;

        // getting advertiser id should be done on a background thread
        AsyncTask<Void, Void, String> task = new AsyncTask<Void, Void, String>() {

            @Override
            protected String doInBackground(Void... params) {
                return IronSource.getAdvertiserId(self.cordova.getActivity());
            }

            @Override
            protected void onPostExecute(String advertisingId) {

                String userId = providedUserId;

                if (TextUtils.isEmpty(userId)) {
                    userId = advertisingId;
                }

                if (TextUtils.isEmpty(userId)) {
                    userId = FALLBACK_USER_ID;
                }

                // we're using an advertisingId as the 'userId'
                init(appKey, userId);
                callbackContext.success();

            }
        };

        task.execute();
    }

    /**
     * Initializes IronSource
     * @todo Provide
     */
    private void init(String appKey, String userId) {

        // Be sure to set a listener to each product that is being initiated
        // set the IronSource rewarded video listener
        IronSource.setRewardedVideoListener(this);

        // set the IronSource offerwall listener
        IronSource.setOfferwallListener(this);

        // set the IronSource interstitial listener;
        IronSource.setInterstitialListener(this);

        // set client side callbacks for the offerwall
        SupersonicConfig.getConfigObj().setClientSideCallbacks(true);

        // Set user id
        IronSource.setUserId(userId);

        // init the IronSource SDK
        IronSource.init(this.cordova.getActivity(), appKey);
    }

    /**----------------------- SET DYNAMIC USER ID --------------------------- */

    private void setDynamicUserIdAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final String userId = args.getString(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                IronSource.setDynamicUserId(userId);
                callbackContext.success();
            }
        });
    }

    /**----------------------- VALIDATION INTEGRATION --------------------------- */

    /**
     * Validates integration action
     */
    private void validateIntegrationAction(JSONArray args, final CallbackContext callbackContext) {
        final IronSourceAdsPlugin self = this;
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                IntegrationHelper.validateIntegration(self.cordova.getActivity());
                callbackContext.success();
            }
        });
    }

    /**----------------------- REWARDED VIDEO --------------------------- */

    private void showRewardedVideoAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final String placementName = args.getString(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {

                IronSource.showRewardedVideo(placementName);
                callbackContext.success();
            }
        });
    }

    private void hasRewardedVideoAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                boolean available = IronSource.isRewardedVideoAvailable();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, available));
            }
        });
    }

    private void isRewardedVideoCappedForPlacementAction(JSONArray args, final CallbackContext callbackContext)
            throws JSONException {

        final String placementName = args.getString(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                boolean capped = IronSource.isRewardedVideoPlacementCapped(placementName);
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, capped));
            }
        });
    }

    @Override
    public void onRewardedVideoAdOpened() {
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_OPENED);
    }

    @Override
    public void onRewardedVideoAdClosed() {
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_CLOSED);
    }

    @Override
    public void onRewardedVideoAvailabilityChanged(boolean available) {
        JSONObject data = new JSONObject();
        try {
            data.put("available", available);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_AVAILABILITY_CHANGED, data);
    }

    @Override
    public void onRewardedVideoAdStarted() {
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_STARTED);
    }

    @Override
    public void onRewardedVideoAdEnded() {
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_ENDED);
    }

    @Override
    public void onRewardedVideoAdRewarded(Placement placement) {

        String rewardName = placement.getRewardName();
        int rewardAmount = placement.getRewardAmount();

        JSONObject placementData = new JSONObject();
        try {
            placementData.put("name", placement.getPlacementName());
            placementData.put("reward", placement.getRewardName());
            placementData.put("amount", placement.getRewardAmount());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        JSONObject data = new JSONObject();

        try {
            data.put("placement", placementData);
        } catch (JSONException e) {
            e.printStackTrace();
        }

        this.emitWindowEvent(EVENT_REWARDED_VIDEO_REWARDED, data);
    }

    @Override
    public void onRewardedVideoAdShowFailed(IronSourceError ironSourceError) {
        this.emitWindowEvent(EVENT_REWARDED_VIDEO_FAILED, createErrorJSON(ironSourceError));
    }

    @Override
    public void onRewardedVideoAdClicked(Placement placement) {

    }

    /**----------------------- INTERSTITIAL --------------------------- */

    private void hasInterstitialAction(JSONArray args, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                boolean ready = IronSource.isInterstitialReady();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, ready));
            }
        });
    }

    private void loadInterstitialAction(JSONArray args, final CallbackContext callbackContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                IronSource.loadInterstitial();
                callbackContext.success();
            }
        });
    }

    private void showInterstitialAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final String placementName = args.getString(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                IronSource.showInterstitial(placementName);
                callbackContext.success();
            }
        });
    }

    @Override
    public void onInterstitialAdReady() {
        this.emitWindowEvent(EVENT_INTERSTITIAL_LOADED);
    }

    @Override
    public void onInterstitialAdLoadFailed(IronSourceError ironSourceError) {
        this.emitWindowEvent(EVENT_INTERSTITIAL_FAILED_TO_LOAD, createErrorJSON(ironSourceError));
    }

    @Override
    public void onInterstitialAdOpened() {
        this.emitWindowEvent(EVENT_INTERSTITIAL_WILL_OPEN, new JSONObject());
    }

    @Override
    public void onInterstitialAdClosed() {
        this.emitWindowEvent(EVENT_INTERSTITIAL_CLOSED, new JSONObject());
    }

    @Override
    public void onInterstitialAdShowSucceeded() {
        this.emitWindowEvent(EVENT_INTERSTITIAL_SHOWN, new JSONObject());
    }

    @Override
    public void onInterstitialAdShowFailed(IronSourceError ironSourceError) {
        this.emitWindowEvent(EVENT_INTERSTITIAL_SHOW_FAILED, createErrorJSON(ironSourceError));
    }

    @Override
    public void onInterstitialAdClicked() {
        this.emitWindowEvent(EVENT_INTERSTITIAL_CLICKED, new JSONObject());
    }

    /**----------------------- OFFERWALL --------------------------- */

    private void showOfferwallAction(JSONArray args, final CallbackContext callbackContext) throws JSONException {

        final String placementName = args.getString(0);

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                IronSource.showOfferwall(placementName);
                callbackContext.success();
            }
        });
    }

    private void hasOfferwallAction(JSONArray args, final CallbackContext callbackContext) {

        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                boolean available = IronSource.isOfferwallAvailable();
                callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, available));
            }
        });

    }

    @Override
    public void onOfferwallAvailable(boolean available) {
        JSONObject data = new JSONObject();
        try {
            data.put("available", available);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        this.emitWindowEvent(EVENT_OFFERWALL_AVAILABILITY_CHANGED, data);
    }

    @Override
    public void onOfferwallOpened() {
        this.emitWindowEvent(EVENT_OFFERWALL_SHOWN, new JSONObject());
    }

    @Override
    public void onOfferwallShowFailed(IronSourceError ironSourceError) {
        this.emitWindowEvent(EVENT_OFFERWALL_SHOW_FAILED, createErrorJSON(ironSourceError));
    }

    @Override
    public boolean onOfferwallAdCredited(int credits, int totalCredits, boolean totalCreditsFlag) {

        JSONObject data = new JSONObject();

        try {
            data.put("credits", credits);
            data.put("totalCredits", totalCredits);
            data.put("totalCreditsFlag", totalCreditsFlag);

        } catch (JSONException e) {
            e.printStackTrace();
        }

        this.emitWindowEvent(EVENT_OFFERWALL_CREDITED, data);

        return true;
    }

    @Override
    public void onGetOfferwallCreditsFailed(IronSourceError ironSourceError) {
        this.emitWindowEvent(EVENT_OFFERWALL_CREDIT_FAILED, createErrorJSON(ironSourceError));
    }

    @Override
    public void onOfferwallClosed() {
        this.emitWindowEvent(EVENT_OFFERWALL_CLOSED);
    }

    /**----------------------- BANNER --------------------------- */

    private void showBannerAction(JSONArray args, final CallbackContext callbackContext) {

        final IronSourceAdsPlugin self = this;

        cordova.getActivity().runOnUiThread(new Runnable() {

            public void run() {

                hideBannerView();

                // choose banner size
                EBannerSize size = EBannerSize.BANNER;

                // instantiate IronSourceBanner object, using the IronSource.createBanner API
                mIronSourceBannerLayout = IronSource.createBanner(self.cordova.getActivity(), size);

                // layout
                parentLayout = (FrameLayout) cordovaWebView.getView().getParent();

                bannerContainerLayout = new RelativeLayout(self.cordova.getActivity());

                RelativeLayout.LayoutParams bannerContainerLayoutParams = new RelativeLayout.LayoutParams(
                        LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);

                bannerContainerLayout.setGravity(Gravity.BOTTOM);

                // layout params
                RelativeLayout.LayoutParams layoutParams = new RelativeLayout.LayoutParams(
                        RelativeLayout.LayoutParams.WRAP_CONTENT, RelativeLayout.LayoutParams.WRAP_CONTENT);

                layoutParams.addRule(RelativeLayout.CENTER_HORIZONTAL);

                bannerContainerLayout.addView(mIronSourceBannerLayout, layoutParams);

                parentLayout.addView(bannerContainerLayout, bannerContainerLayoutParams);

                if (mIronSourceBannerLayout != null) {

                    mIronSourceBannerLayout.setBannerListener(new BannerListener() {

                        @Override
                        public void onBannerAdLoaded() {
                            self.emitWindowEvent(EVENT_BANNER_DID_LOAD);
                        }

                        @Override
                        public void onBannerAdLoadFailed(IronSourceError ironSourceError) {
                            self.emitWindowEvent(EVENT_BANNER_FAILED_TO_LOAD, createErrorJSON(ironSourceError));

                        }

                        @Override
                        public void onBannerAdClicked() {
                            self.emitWindowEvent(EVENT_BANNER_DID_CLICK);
                        }

                        @Override
                        public void onBannerAdScreenPresented() {
                            self.emitWindowEvent(EVENT_BANNER_WILL_PRESENT_SCREEN);
                        }

                        @Override
                        public void onBannerAdScreenDismissed() {
                            self.emitWindowEvent(EVENT_BANNER_DID_DISMISS_SCREEN);
                        }

                        @Override
                        public void onBannerAdLeftApplication() {
                            self.emitWindowEvent(EVENT_BANNER_WILL_LEAVE_APPLICATION);
                        }
                    });
                }

                IronSource.loadBanner(mIronSourceBannerLayout);

                callbackContext.success();
            }
        });

    }


    private void hideBannerView(){
        if (mIronSourceBannerLayout != null) {

            IronSource.destroyBanner(mIronSourceBannerLayout);
            if(parentLayout != null && bannerContainerLayout != null)
            {
                bannerContainerLayout.removeView(mIronSourceBannerLayout);
                parentLayout.removeView(bannerContainerLayout);
                bannerContainerLayout = null;
                parentLayout = null;
            }
            mIronSourceBannerLayout = null;
        }
    }

    /**
     * Destroys IronSource Banner and removes it from the container
     */
    private void hideBannerAction(JSONArray args, final CallbackContext callbackContext) {

        cordova.getActivity().runOnUiThread(new Runnable() {

            public void run() {
                hideBannerView();
                callbackContext.success();
            }
        });
    };

}
