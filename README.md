# IronSource Ads Cordova Plugin
# <img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/ironsource_logo.png?raw=true" width="500"  />

<p align="left">
<img src="https://img.shields.io/badge/State-In%20Development-yellowgreen.svg?style=flat-square">
<img src="https://img.shields.io/badge/IronSource%20Framework%20Version-6.7.3-blue.svg?style=flat-square">
</p>

--------

## Table of Contents

- [State of Development](#state-of-development)
- [Install](#install)
- [API](#api)
- [Adding Additional AD Network SDKs](#adding-additional-sdks)
- [Official IronSource Documentation](http://developers.ironsrc.com/)


## State of Development
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Rewarded%20Video%20Support&style=flat-square">
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Offerwall%20Support&style=flat-square">
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=Interstitial%20Support&style=flat-square">
- [ ] <img src="https://img.shields.io/badge/-In%20Development-yellow.svg?label=Banner%20Support&style=flat-square">
- [x] <img src="https://img.shields.io/badge/-Complete-brightgreen.svg?label=IOS%20Banner%20Support&style=flat-square">
- [ ] <img src="https://img.shields.io/badge/-In%20Development-yellow.svg?label=Andorid%20Banner%20Support&style=flat-square">


--------

## Install

```bash
cordova plugin add cordova-plugin-ironsource-ads
```

--------
## API

- [Initialization](#initialization)
- [Validate Integration](#validate-integration)
- [Set Dynamic User ID](#set-dynamic-user-id)
- [Rewarded Videos](#rewarded-videos)
  - [Has Rewarded Video](#has-rewarded-video)
  - [Show Rewarded Video](#show-rewarded-video)
  - [Rewarded Video Events](#rewarded-video-events)
- [Interstitials](#interstitials)
  - [Has Interstitial](#has-interstitial)
  - [Load Interstitial](#load-interstitial)
  - [Show Interstitial](#show-interstitial)
  - [Interstitial Events](#interstitial-events)
- [Offerwalls](#offerwalls)
  - [Has Offerwall](#has-offerwall)
  - [Show Offerwall](#show-offerwall)
  - [Offerwall Events](#offerwall-events)
- [Banners](#banners)
  - [Show Banner](#show-banner)
  - [Hide Banner](#hide-banner)
  - [Banner Events](#banner-events)

All methods support optional `onSuccess` and `onFailure` parameters

### Initialization
```javascript
IronSourceAds.init({
    appKey: appKey
});
```

### Validate Integration
Once you have finished your integration, call the following function and confirm you have integrated the ad networks you want are marked **VERIFIED**:

*If they are not marked verified, look at the [Adding Additional AD Network SDKs](#adding-additional-sdks) section for help or the [Official IronSource Documentation](http://developers.ironsrc.com/)*


```javascript
IronSourceAds.validateIntegration();
```


**Check xcode / android studio debugger for validation output**
<img src="https://github.com/charlesbodman/cordova-plugin-ironsource-ads/blob/master/images/integration_helper.png"/>

***
### Set Dynamic User ID
> The Dynamic UserID is a parameter that can be changed throughout the session and will be received in the server-to-server ad > rewarded callbacks. This parameter helps verify AdRewarded transactions and must be set before calling ShowRV.
```javascript
IronSourceAds.setDynamicUserId({userId:'example'});
```
***
### Rewarded Videos

#### Has Rewarded Video

```javascript
IronSourceAds.hasRewardedVideo({
    onSuccess: function (available) {

    }
});
```

#### Show Rewarded Video
```javascript
IronSourceAds.showRewardedVideo();
```

**Show Rewarded Video (With options)**
```javascript
IronSourceAds.showRewardedVideo({
    placement: "placementName", // Optional
    onSuccess: function () { }, // Optional
    onFailure: function (error) { } //Optional
});
```

#### Rewarded Video Events


**Rewarded Video Availabilty Changed**
```javascript
window.addEventListener("rewardedVideoAvailabilityChanged", function(event){

    var available = event.available;

});
```
**Rewarded Video Rewarded**
```javascript
window.addEventListener("rewardedVideoRewardReceived", function(event){

    var placement = event.placement;
    var placementName = placement.placementName;
    var rewardAmount = placement.rewardAmount;
    var rewardName = placement.rewardName;

});
```
**Rewarded Video Started**
```javascript
window.addEventListener("rewardedVideoStarted", function(){

});
```
**Rewarded Video Ended**
```javascript
window.addEventListener("rewardedVideoEnded", function(){

});
```
**Rewarded Video Opened**
```javascript
window.addEventListener("rewardedVideoOpened", function(){

});
```
**Rewarded Video Closed**
```javascript
window.addEventListener("rewardedVideoClosed", function(){

});
```
**Rewarded Video Failed**
```javascript
window.addEventListener("rewardedVideoFailed", function(){

});
```
***
### Interstitials

#### Has Interstitial
```javascript
IronSourceAds.hasInterstitial({
    onSuccess: function (available) {

    }
});
```
#### Load Interstitial
_Must be called before `showInterstitial`
```javascript
IronSourceAds.loadInterstitial();
```

***
#### Show Interstitial
```javascript
IronSourceAds.showInterstitial();
```

**Show Interstitial Video (With options)**
```javascript
IronSourceAds.showInterstitial({
    placement: "placementName", // Optional
    onSuccess: function () { }, // Optional
    onFailure: function (error) { } // Optional
});
```
***
#### Interstitial Events

**Interstitial Loaded**
```javascript
window.addEventListener("interstitialLoaded", function(){

});
```
**Interstitial Shown**
```javascript
window.addEventListener("interstitialShown", function(){

});
```
**Interstitial Show Failed**
```javascript
window.addEventListener("interstitialShowFailed", function(){

});
```
**Interstitial Clicked**
```javascript
window.addEventListener("interstitialClicked", function(){

});
```
**Interstitial Closed**
```javascript
window.addEventListener("interstitialClosed", function(){

});
```
**Interstitial Will Open**
```javascript
window.addEventListener("interstitialWillOpen", function(){

});
```
**Interstitial Failed To Load**
```javascript
window.addEventListener("interstitialFailedToLoad", function(){

});
```
***

### Offerwalls

#### Has Offerwall

```javascript
IronSourceAds.hasOfferwall({
    onSuccess: function (available) {

    }
});
```

#### Show Offerwall
```javascript
IronSourceAds.showOfferwall();
```

**Show Offerwall (With options)**
```javascript
IronSourceAds.showOfferwall({
    placement: "placementName", // Optional
    onSuccess: function () { }, // Optional
    onFailure: function (error) { } // Optional
});
```

#### Offerwall Events

**Offerwall Availability Changed**
```javascript
window.addEventListener("offerwallAvailabilityChanged", function(event){
  var available = event.available;
});
```

**Offerwall Shown**
```javascript
window.addEventListener("offerwallShown", function(){

});
```
**Offerwall Credit Recieved**
```javascript
window.addEventListener("offerwallCreditReceived", function(event){

  var credits = event.credits; // The number of credits the user has earned since //the last (void)didReceiveOfferwallCredits:
  var totalCredits = event.totalCredits; //The total number of credits ever earned by the user

});
```
**Offerwall Credit Failed**
```javascript
window.addEventListener("offerwallCreditFailed", function(){

});
```
**Offerwall Closed**
```javascript
window.addEventListener("offerwallClosed", function(){

});
```
**Offerwall Show Failed**
```javascript
window.addEventListener("offerwallShowFailed", function(){

});
```



### Banners

*Banner ads require Admob, Facebook, or InMobi integrated to work*

#### Show Banner
```javascript
IronSourceAds.showBanner();
```

**Show Banner (With options)**
```javascript
IronSourceAds.showBanner({
    placement: "placementName", // Optional
    size:"standard", // Optional ("standard","large","rectangle","tablet")
    position:"bottom", //Optional ("top", "bottom", "center"),
    onSuccess: function () { }, // Optional
    onFailure: function (error) { } // Optional
});
```

#### Hide Banner
```javascript
IronSourceAds.hideBanner();
```


#### Banner Events


**Banner Did Load**
```javascript
window.addEventListener("bannerDidLoad", function(event){

});
```

**Banner Failed to Load**
```javascript
window.addEventListener("bannerFailedToLoad", function(error){

});
```

**Banner Did Click**
```javascript
window.addEventListener("bannerDidClick");
```

**Banner Will Present Screen**
```javascript
window.addEventListener("bannerWillPresentScreen", function(){

});
```

**Banner Did Dismiss Screen**
```javascript
window.addEventListener("bannerDidDismissScreen", function(){

});
```
**Banner will leave application**
```javascript
window.addEventListener("bannerWillLeaveApplication", function(){

});
```



# Adding Additional SDKS
**By default, this plugin does not contain other ad providers sdks**

### Android

[Follow the integration guides here](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/#step-2)

Edit `src/android/ironsourceads.gradle` from this plugin and add the mediation adapters you need

*Example*
```java
cdvPluginPostBuildExtras.add({

  repositories {
    maven {
      url "https://dl.bintray.com/ironsource-mobile/android-sdk"
    }
  }

  repositories {
    maven {
      url "http://dl.bintray.com/ironsource-mobile/android-adapters"
    }
  }

  dependencies {
    compile 'com.ironsource.sdk:mediationsdk:6.7.3@jar'

    //Example
    compile 'com.ironsource.adapters:admobadapter:4.0.3@jar'
    compile 'com.ironsource.adapters:facebookadapter:4.0.2@jar'
    compile 'com.ironsource.adapters:unityadsadapter:4.0.1@jar'
  }
});

```

### IOS
**IOS requires manual downloading of Adapter & SDK**
[Download Adapters Here and follow the integration guides](http://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/#step-2)

*If you have any questions, create an issue, and I'll walk you through it. *

**Edit `plugin.xml` of this plugin**

```xml
   <platform name="ios">
        <config-file target="config.xml" parent="/*">
            <feature name="IronSourceAdsPlugin">
                <param name="ios-package" value="IronSourceAdsPlugin" />
            </feature>
        </config-file>
        <header-file src="src/ios/IronSourceAdsPlugin.h" />
        <source-file src="src/ios/IronSourceAdsPlugin.m" />
        <framework src="IronSourceSDK" type="podspec" spec="~> 6.7.3.1" />

        <!-- ADD MEDIATION FRAMEWORKS HERE -->
        <!-- Example -->
        <framework src="IronSourceFacebookAdapter" type="podspec" spec="~> 4.0.2.1" />
        <framework src="IronSourceAdMobAdapter" type="podspec" spec="~> 4.0.1.1" />
        <framework src="IronSourceUnityAdsAdapter" type="podspec" spec="~> 4.0.1.2" />
        <!-- Example -->

        <framework src="Foundation.framework" />
        <framework src="AVFoundation.framework" />
        <framework src="CoreMedia.framework" />
        <framework src="CoreVideo.framework" />
        <framework src="QuartzCore.framework" />
        <framework src="SystemConfiguration.framework" />
        <framework src="CoreGraphics.framework" />
        <framework src="CFNetwork.framework" />
        <framework src="MobileCoreServices.framework" />
        <framework src="libz.dylib" />
        <framework src="StoreKit.framework" />
        <framework src="AdSupport.framework" />
        <framework src="CoreLocation.framework" />
        <framework src="CoreTelephony.framework" />
        <framework src="Security.framework" />
    </platform>
```
