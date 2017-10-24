document.addEventListener('deviceready', function onDeviceReady() {



        //App keys
        var IOS_KEY = "685af35d";
        var ANDROID_KEY = "685b2ce5";

        //Get app key based on platform
        const appKey = cordova.platformId === 'ios' ? IOS_KEY : ANDROID_KEY;

        /**
         * Initialize Iron Source Ads
         */
        IronSourceAds.init({


            appKey: appKey,

            userId: 'foo', // optional

            onSuccess: function () {

                /**
                 * Validate Integration
                 */
                IronSourceAds.validateIntegration();


                /**
                 * Set user Id (optional)
                 */
                IronSourceAds.setDynamicUserId({ userId: '' });





                /***************** INTERSTITIALS ******************* */

                //Intersitials require you to load them before you can use them

                /**
                 * Load Interstitial
                 */
                IronSourceAds.loadInterstitial();

                /**
                 * Check if interstitial is ready
                 */
                IronSourceAds.hasInterstitial({
                    onSuccess: function (available) {
                        if (available) {
                            //Show Interstitial
                            IronSourceAds.showInterstitial();
                        }
                    }
                })



                /******************** OFFERWALL ******************* */

                IronSourceAds.hasOfferwall({
                    onSuccess: function (available) {
                        if (available) {
                            //Show offerwall
                            IronSourceAds.showOfferwall();
                        }
                    }
                })



                /******************** REWARDED VIDEO ******************* */

                IronSourceAds.hasRewardedVideo({
                    onSuccess: function (available) {
                        if (available) {
                            //Show offerwall
                            IronSourceAds.showRewardedVideo();
                        }
                    }
                })




                /**
                 * ********************* EVENTS ***********************************
                 */


                //Rewarded Video
                window.addEventListener("rewardedVideoFailed", function () { console.log("rewardedVideoFailed"); });
                window.addEventListener("rewardedVideoRewardReceived", function (event) { console.log("rewardedVideoRewardReceived", event); });
                window.addEventListener("rewardedVideoEnded", function () { console.log("rewardedVideoEnded") });
                window.addEventListener("rewardedVideoStarted", function () { console.log("rewardedVideoStarted") });
                window.addEventListener("rewardedVideoAvailabilityChanged", function (event) { console.log("rewardedVideoAvailabilityChanged", event.available) });
                window.addEventListener("rewardedVideoClosed", function () { console.log("rewardedVideoClosed") });
                window.addEventListener("rewardedVideoOpened", function () { console.log("rewardedVideoOpened") });

                //Interstitial
                window.addEventListener("interstitialLoaded", function () { console.log("interstitialLoaded") });
                window.addEventListener("interstitialShown", function () { console.log("interstitialShown") });
                window.addEventListener("interstitialShowFailed", function () { console.log("interstitialShowFailed") });
                window.addEventListener("interstitialClicked", function () { console.log("interstitialClicked") });
                window.addEventListener("interstitialClosed", function () { console.log("interstitialClosed") });
                window.addEventListener("interstitialWillOpen", function () { console.log("interstitialWillOpen") });
                window.addEventListener("interstitialFailedToLoad", function () { console.log("interstitialFailedToLoad") });

                //Offerwall
                window.addEventListener("offerwallClosed", function () { console.log("offerwallClosed") })
                window.addEventListener("offerwallCreditFailed", function () { console.log("offerwallCreditFailed") })
                window.addEventListener("offerwallCreditReceived", function (event) { console.log("offerwallCreditReceived", event) })
                window.addEventListener("offerwallShowFailed", function () { console.log("offerwallShowFailed") })
                window.addEventListener("offerwallShown", function () { console.log("offerwallShown") })
                window.addEventListener("offerwallAvailabilityChanged", function (event) { console.log("offerwallAvailabilityChanged", event.available) })

                //Banner
                window.addEventListener("bannerDidLoad", function () { console.log("bannerDidLoad") });
                window.addEventListener("bannerFailedToLoad", function () { console.log("bannerFailedToLoad") });
                window.addEventListener("bannerDidClick", function () { console.log("bannerDidClick") });
                window.addEventListener("bannerWillPresentScreen", function () { console.log("bannerWillPresentScreen") });
                window.addEventListener("bannerDidDismissScreen", function () { console.log("bannerDidDismissScreen") });
                window.addEventListener("bannerWillLeaveApplication", function () { console.log("bannerWillLeaveApplication") });

            }
        });

    });
