#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import <IronSource/IronSource.h>

@interface IronSourceAdsPlugin : CDVPlugin <ISRewardedVideoDelegate, ISBannerDelegate, ISOfferwallDelegate, ISInterstitialDelegate>

@property(nonatomic, strong) ISBannerView *bannerView;
@property(nonatomic) bool loadingBanner;
@property(nonatomic) NSString *bannerPosition;
@property(nonatomic) UIViewController *bannerController;

- (void)init:(CDVInvokedUrlCommand *)command;

- (void)setDynamicUserId:(CDVInvokedUrlCommand *)command;

- (void)validateIntegration:(CDVInvokedUrlCommand *)command;

- (void)showRewardedVideo:(CDVInvokedUrlCommand *)command;

- (void)hasRewardedVideo:(CDVInvokedUrlCommand *)command;

- (void)loadBanner:(CDVInvokedUrlCommand *)command;

- (void)showBanner:(CDVInvokedUrlCommand *)command;

- (void)hideBanner:(CDVInvokedUrlCommand *)command;

- (void)showOfferwall:(CDVInvokedUrlCommand *)command;

- (void)hasOfferwall:(CDVInvokedUrlCommand *)command;

- (void)loadInterstitial:(CDVInvokedUrlCommand *)command;

- (void)hasInterstitial:(CDVInvokedUrlCommand *)command;

- (void)showInterstitial:(CDVInvokedUrlCommand *)command;

@end
