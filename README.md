# IronSource Ads Cordova Plugin
# <img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/ironsource_logo.png?raw=true" width="500"  />

<p align="left">
<img src="https://img.shields.io/badge/State-In%20Development-yellowgreen.svg?style=flat-square">
<img src="https://img.shields.io/badge/IronSource%20Framework%20Version-6.7.0-blue.svg?style=flat-square">
</p>

--------

## Table of Contents

- [Install](#install)
- [Usage](#usage)
- [Official IronSource Documentation](http://developers.ironsrc.com/)
- [
## Install

```bash
cordova plugin add cordova-plugin-ironsource-ads
```


## Usage
All methods support optional `onSuccess` and `onFailure` parameters

### Initialize
```javascript
IronSourceAds.init({
    appKey: appKey
};
```

### Validate Integration
Integration Helper Function
Once you have finished your integration, call the following function and confirm that everything in your integration is marked as **VERIFIED**:

```javascript
IronSourceAds.validateIntegration();
```

**Check xcode / android studio debugger for validation output**
<img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/integration_helper.png"/>
