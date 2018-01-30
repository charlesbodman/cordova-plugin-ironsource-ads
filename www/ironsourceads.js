
var IronSourceAds = (function () {

    var initialized = false;

    return {

        /**
         * Returns the state of initialization
         */
        isInitialized: function isInitialized() {
            return initialized;
        },


        /**
         * Sets the user id, used for Offerwall ad units or using
         * server-to-server callbacks to reward your users with our rewarded ad units
         * @param {String} - user id
         */
        setDynamicUserId: function setUserId(params) {

            params = defaults(params, {});

            if (params.hasOwnProperty('userId') === false) {
                throw new Error("IronSourceAds::setUserId - missing userId IronSourceAds.setUserId({userId:'example'})");
            }

            callPlugin('setDynamicUserId', [params.userId], params.onSuccess, params.onFailure);
        },


        /**
         * Validate Integration
         * @param {Function} params.onSuccess - optional on success callback
         * @param {Function} params.onFailure - optional on failure callback
         */
        validateIntegration: function validateIntegration(params) {

            params = defaults(params, {});

            callPlugin('validateIntegration', [], params.onSuccess, params.onFailure);

        },



        /**
         * Initializes iron source
         * @param {Function} params.onSuccess - optional on success callback
         */
        init: function init(params) {

            params = defaults(params, { userId: '' });

            if (params.hasOwnProperty('appKey') === false) {
                throw new Error('IronSourceAds::init - appKey is required');
            }

            callPlugin('init', [params.appKey, params.userId], function () {

                initialized = true;

                if (isFunction(params.onSuccess)) {
                    params.onSuccess();
                }

            }, params.onFailure);

        },



        /**
         * Shows rewarded video
         * @param {String} params.placement - optional placement name
         * @param {Function} params.onSuccess - optional on success callback
         * @param {Function} param.onFailure - optional on failure callback
         */
        showRewardedVideo: function showRewardedVideo(params) {

            params = defaults(params, { placement: 'DefaultRewardedVideo' });

            callPlugin('showRewardedVideo', [params.placement], params.onSuccess, params.onFailure);

        },


        /**
         * Checks if rewarded video is available
         * @param {Function} params.onSuccess - function to call the result to
         */
        hasRewardedVideo: function hasRewardedVideo(params) {

            params = defaults(params, {});

            if (isFunction(params.onSuccess) === false) {
                throw new Error('IronSourceAdsPlugin::hasRewardedVideo expects onSuccess');
            }

            callPlugin('hasRewardedVideo', [], params.onSuccess, params.onFailure);

        },


        /**
         * Shows banner if avaialble
         * @param {string} params.placement
         * @param {string} params.position
         * @param {Function} params.onSuccess
         */
        loadBanner: function showBanner(params) {

            params = defaults(params, { placement: 'DefaultBanner', position: 'bottom', size: 'standard' });

            callPlugin('loadBanner', [params.placement, params.size, params.position], params.onSuccess, params.onFailure);

        },


        /**
         * Shows banner if avaialble
         * @param {string} params.placement
         * @param {string} params.position
         * @param {Function} params.onSuccess
         */
        showBanner: function showBanner(params) {

            params = defaults(params, { placement: 'DefaultBanner', position: 'bottom', size: 'standard' });

            callPlugin('showBanner', [params.placement, params.size, params.position], params.onSuccess, params.onFailure);

        },

        /**
         * Hide banner
         * @param {Function} [params.onSuccess]
         * @param {Function} [params.onFailure]
         */
        hideBanner: function hideBanner(params) {

            params = defaults(params, {});

            callPlugin('hideBanner', [], params.onSuccess, params.onFailure);

        },


        /**
         * Checks if offerwall is available
         * @param {Function} params.onSuccess - function to call the result to
         */
        hasOfferwall: function hasOfferwall(params) {

            params = defaults(params, {});

            callPlugin('hasOfferwall', [], params.onSuccess, params.onFailure);
        },


        /**
         * Shows the offerwall if available
         * @param {Function} params.onSuccess
         */
        showOfferwall: function showOfferwall(params) {

            params = defaults(params, { placement: 'DefaultOfferWall' });

            callPlugin('showOfferwall', [params.placement], params.onSuccess, params.onFailure);

        },


        /**
         * Loads interstitial
         */
        loadInterstitial: function loadInterstitial(params) {

            params = defaults(params, {});

            callPlugin('loadInterstitial', [], params.onSuccess, params.onFailure);

        },


        /**
         * Show interstitial
         */
        showInterstitial: function showInterstitial(params) {

            params = defaults(params, { placement: 'DefaultInterstitial' });

            callPlugin('showInterstitial', [params.placement], params.onSuccess, params.onFailure);

        },


        /**
         * Checks to see if interstitial is loaded
         * @param {Function} params.onSuccess
         */
        hasInterstitial: function isInterstitialReady(params) {

            params = defaults(params, {});

            callPlugin('hasInterstitial', [], params.onSuccess, params.onFailure);

        },

        /**
         * Checks if rewarded video is capped for placement.
         * This should be used before showing the state of the button for rewarded video.
         * User may have capped their usage
         */
        isRewardedVideoCappedForPlacement: function isRewardedVideoCappedForPlacement(params) {

            params = defaults(params, { placement: 'DefaultRewardedVideo' });

            callPlugin('isRewardedVideoCappedForPlacement', [], params.onSuccess, params.onFailure);

        }

    }
})();



/**
* Helper function to call cordova plugin
* @param {String} name - function name to call
* @param {Array} params - optional params
* @param {Function} onSuccess - optional on sucess function
* @param {Function} onFailure - optional on failure functioin
*/
function callPlugin(name, params, onSuccess, onFailure) {
    cordova.exec(function callPluginSuccess(result) {

        if (isFunction(onSuccess)) {
            onSuccess(result);
        }
    }, function callPluginFailure(error) {
        if (isFunction(onFailure)) {
            onFailure(error)
        }
    }, 'IronSourceAdsPlugin', name, params);
}


/**
* Helper function to check if a function is a function
* @param {Object} functionToCheck - function to check if is function
*/
function isFunction(functionToCheck) {
    var getType = {};
    var isFunction = functionToCheck && getType.toString.call(functionToCheck) === '[object Function]';
    return isFunction === true;
}



/**
* Helper function to do a shallow defaults (merge). Does not create a new object, simply extends it
* @param {Object} o - object to extend
* @param {Object} defaultObject - defaults to extend o with
*/
function defaults(o, defaultObject) {

    if (typeof o === 'undefined') {
        return defaults({}, defaultObject);
    }

    for (var j in defaultObject) {
        if (defaultObject.hasOwnProperty(j) && o.hasOwnProperty(j) === false) {
            o[j] = defaultObject[j];
        }
    }

    return o;
}



if (typeof module !== undefined && module.exports) {
    module.exports = IronSourceAds;
}
