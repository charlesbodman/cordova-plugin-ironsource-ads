# IronSource Ads Cordova Plugin
# <img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/ironsource_logo.png?raw=true" width="500"  />

<p align="left">
<img src="https://img.shields.io/badge/State-In%20Development-yellowgreen.svg?style=flat-square">
<img src="https://img.shields.io/badge/IronSource%20Framework%20Version-6.7.0-blue.svg?style=flat-square">
</p>

--------

## Table of Contents

- [State of Development](#state-of-development)
- [Install](#install)
- [Usage](#usage)
- [Official IronSource Documentation](http://developers.ironsrc.com/)


## State of Development
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Rewarded%20Video%20Support&style=flat-square">
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Offerwall%20Support&style=flat-square">
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Interstitial%20Support&style=flat-square">
- [ ] <img src="https://img.shields.io/badge/-In%20Development-yellow.svg?label=Banner%20Support&style=flat-square">

-------- 

## Install

```bash
cordova plugin add cordova-plugin-ironsource-ads
```

-------- 
## Usage

- [Initialize](#initialize)


All methods support optional `onSuccess` and `onFailure` parameters

### Initialize
```javascript
IronSourceAds.init({
    appKey: appKey
};
```

### Validate Integration
Once you have finished your integration, call the following function and confirm that everything in your integration is marked as **VERIFIED**:

```javascript
IronSourceAds.validateIntegration();
```



**Check xcode / android studio debugger for validation output**
<img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/integration_helper.png"/>


#
