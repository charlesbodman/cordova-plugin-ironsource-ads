#import "IronSourceAdsPlugin.h"
#import <Cordova/CDVViewController.h>

static NSString *const EVENT_INTERSTITIAL_LOADED = @"interstitialLoaded";
static NSString *const EVENT_INTERSTITIAL_SHOWN = @"interstitialShown";
static NSString *const EVENT_INTERSTITIAL_SHOW_FAILED = @"interstitialShowFailed";
static NSString *const EVENT_INTERSTITIAL_CLICKED = @"interstitialClicked";
static NSString *const EVENT_INTERSTITIAL_CLOSED = @"interstitialClosed";
static NSString *const EVENT_INTERSTITIAL_WILL_OPEN = @"interstitialWillOpen";
static NSString *const EVENT_INTERSTITIAL_FAILED_TO_LOAD = @"interstitialFailedToLoad";

static NSString *const EVENT_OFFERWALL_CLOSED = @"offerwallClosed";
static NSString *const EVENT_OFFERWALL_CREDIT_FAILED = @"offerwallCreditFailed";
static NSString *const EVENT_OFFERWALL_CREDITED = @"offerwallCreditReceived";
static NSString *const EVENT_OFFERWALL_SHOW_FAILED = @"offerwallShowFailed";
static NSString *const EVENT_OFFERWALL_SHOWN = @"offerwallShown";
static NSString *const EVENT_OFFERWALL_AVAILABILITY_CHANGED = @"offerwallAvailabilityChanged";

static NSString *const EVENT_REWARDED_VIDEO_FAILED = @"rewardedVideoFailed";
static NSString *const EVENT_REWARDED_VIDEO_REWARDED = @"rewardedVideoRewardReceived";
static NSString *const EVENT_REWARDED_VIDEO_ENDED = @"rewardedVideoEnded";
static NSString *const EVENT_REWARDED_VIDEO_STARTED = @"rewardedVideoStarted";
static NSString *const EVENT_REWARDED_VIDEO_AVAILABILITY_CHANGED = @"rewardedVideoAvailabilityChanged";
static NSString *const EVENT_REWARDED_VIDEO_CLOSED = @"rewardedVideoClosed";
static NSString *const EVENT_REWARDED_VIDEO_OPENED = @"rewardedVideoOpened";

static NSString *const EVENT_BANNER_DID_LOAD = @"bannerDidLoad";
static NSString *const EVENT_BANNER_FAILED_TO_LOAD = @"bannerFailedToLoad";
static NSString *const EVENT_BANNER_DID_CLICK = @"bannerDidClick";
static NSString *const EVENT_BANNER_WILL_PRESENT_SCREEN = @"bannerWillPresentScreen";
static NSString *const EVENT_BANNER_DID_DISMISS_SCREEN = @"bannerDidDismissScreen";
static NSString *const EVENT_BANNER_WILL_LEAVE_APPLICATION = @"bannerWillLeaveApplication";


#define USERID @"demoapp"

@implementation IronSourceAdsPlugin

#pragma mark - CDVPlugin

    /**
     * Init
     * @params {CDVInvokedUrlCommand} command
     */
- (void)init:(CDVInvokedUrlCommand *)command
    {
        NSString *appKey = [command argumentAtIndex:0];
        NSString *userId = [command argumentAtIndex:1];

        [ISSupersonicAdsConfiguration configurations].useClientSideCallbacks = @(YES);

        [IronSource setRewardedVideoDelegate:self];
        [IronSource setOfferwallDelegate:self];
        [IronSource setBannerDelegate:self];
        [IronSource setInterstitialDelegate:self];

        if ([userId length] == 0)
        {
            userId = [IronSource advertiserId];
        }

        if ([userId length] == 0)
        {
            userId = USERID;
        }

        self.bannerController = [[UIViewController alloc] init];

        // After setting the delegates you can go ahead and initialize the SDK.
        [IronSource setUserId:userId];

        [IronSource initWithAppKey:appKey];

        self.loadingBanner = false;

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)setDynamicUserId:(CDVInvokedUrlCommand *)command
    {
        NSString *userId = [command argumentAtIndex:0];

        [IronSource setDynamicUserId:userId];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

    /**
     * Emit window event
     * @param {NString} - event name
     */
- (void)emitWindowEvent:(NSString *)event
    {
        NSString *js = [NSString stringWithFormat:@"cordova.fireWindowEvent('%@')", event];
        [self.commandDelegate evalJs:js];
    }

    /**
     * Emits window event with data
     * @param {NSString} - event name
     * @param {NSDictionary} - event data
     */
- (void)emitWindowEvent:(NSString *)event withData:(NSDictionary *)data
    {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:kNilOptions error:&error];

        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *js = [NSString stringWithFormat:@"cordova.fireWindowEvent('%@', %@)", event, jsonString];
        [self.commandDelegate evalJs:js];
    }

- (void)listSubviewsOfView:(UIView *)view {

    // Get the subviews of the view
    NSArray *subviews = [view subviews];

    // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE

    for (UIView *subview in subviews) {

        // Do what you want to do with the subview
        NSLog(@"%@", subview);

        // List the subviews of subview
        [self listSubviewsOfView:subview];
    }
}

    /**
     * Validates integration
     * @param {CDVInvokedUrlCommand} command
     */
- (void)validateIntegration:(CDVInvokedUrlCommand *)command
    {

        [ISIntegrationHelper validateIntegration];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

#pragma mark - Rewarded Video Delegate Functions


    /**
     * Checks for if rewarded video placement is capped
     */
- (void)isRewardedVideoCappedForPlacement:(CDVInvokedUrlCommand *)command
    {
        NSString *placement = [command argumentAtIndex:0];
        BOOL capped = [IronSource isRewardedVideoCappedForPlacement:placement];

        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:capped];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }


    /**
     * Show rewarded video
     */
- (void)showRewardedVideo:(CDVInvokedUrlCommand *)command
    {
        NSString *placement = [command argumentAtIndex:0];

        if( placement == nil || [placement length] == 0)
        {
            [IronSource showRewardedVideoWithViewController:self.viewController];
        }
        else
        {
            [IronSource showRewardedVideoWithViewController:self.viewController placement:placement];
        }


        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

    // This method lets you know whether or not there is a video
    // ready to be presented. It is only after this method is invoked
    // with 'hasAvailableAds' set to 'YES' that you can should 'showRV'.
- (void)rewardedVideoHasChangedAvailability:(BOOL)available
    {

        NSLog(@"rewardedVideoHasChangedAvailability: %s", available ? "true" : "false");
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"available" : @(available)
                               };

        [self emitWindowEvent:EVENT_REWARDED_VIDEO_AVAILABILITY_CHANGED withData:data];
    }

    // This method checks if rewarde video is available
- (void)hasRewardedVideo:(CDVInvokedUrlCommand *)command
    {

        BOOL available = [IronSource hasRewardedVideo];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

    // This method gets invoked after the user has been rewarded.
- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"placement" : @{
                                       @"name" : placementInfo.placementName,
                                       @"reward" : placementInfo.rewardName,
                                       @"amount" : placementInfo.rewardAmount
                                       }
                               };

        [self emitWindowEvent:EVENT_REWARDED_VIDEO_REWARDED withData:data];
    }

    // This method gets invoked when there is a problem playing the video.
    // If it does happen, check out 'error' for more information and consult
    // our knowledge center for help.
- (void)rewardedVideoDidFailToShowWithError:(NSError *)error
    {

        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };

        [self emitWindowEvent:EVENT_REWARDED_VIDEO_FAILED withData:data];
    }

    // This method gets invoked when we take control, but before
    // the video has started playing.
- (void)rewardedVideoDidOpen
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_REWARDED_VIDEO_OPENED];
    }

    // This method gets invoked when we return controlback to your hands.
    // We chose to notify you about rewards here and not in 'didReceiveRewardForPlacement'.
    // This is because reward can occur in the middle of the video.
- (void)rewardedVideoDidClose
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_REWARDED_VIDEO_CLOSED];
    }

    // This method gets invoked when the video has started playing.
- (void)rewardedVideoDidStart
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_REWARDED_VIDEO_STARTED];
    }

    // This method gets invoked when the video has stopped playing.
- (void)rewardedVideoDidEnd
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_REWARDED_VIDEO_ENDED];
    }

    //Invoked when the end user clicked on the RewardedVideo ad
- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo
    {

    }


- (void)loadBanner:(CDVInvokedUrlCommand *)command
{
    NSString *placement = [command argumentAtIndex:0];
    NSString *size = [command argumentAtIndex:1];
    NSString *position = [command argumentAtIndex:2];
    NSInteger adSize = IS_AD_SIZE_BANNER;

    // We call destroy banner before loading a new banner
    if (self.bannerView) {
        [self destroyBanner];
    }

    self.loadingBanner = true;

    if([size isEqualToString:@"large"])
    {
        adSize = IS_AD_SIZE_LARGE_BANNER;
    }
    else if([size isEqualToString:@"rectangle"])
    {
        adSize = IS_AD_SIZE_RECTANGLE_BANNER;
    }
    else if([size isEqualToString:@"tablet"])
    {
        adSize = IS_AD_SIZE_LARGE_BANNER;
    }

    self.bannerPosition = position;

    if( placement == nil || [placement length] == 0)
    {
        [IronSource loadBannerWithViewController:self.bannerController size:adSize];
    }
    else
    {
        [IronSource loadBannerWithViewController:self.bannerController size:adSize placement:placement];
    }

    // Send callback successfull
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

#pragma mark - Banner Delegate Functions

    // Show banner
- (void)showBanner:(CDVInvokedUrlCommand *)command
    {
        if(self.bannerView)
        {
            [self.viewController.view addSubview:self.bannerView];
            [self.viewController.view bringSubviewToFront:self.bannerView];
        }

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)hideBanner:(CDVInvokedUrlCommand *)command
    {
        if(self.bannerView)
        {
            [self.bannerView removeFromSuperview];
        }

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)destroyBanner
    {
        if (self.bannerView) {
            self.loadingBanner = false;
            [IronSource destroyBanner:self.bannerView];
            self.bannerView = nil;
        }
    }

    // Banner dismissed screen
- (void)bannerDidDismissScreen
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_BANNER_DID_DISMISS_SCREEN];
    }

    //
- (void)bannerDidFailToLoadWithError:(NSError *)error
    {

        self.loadingBanner = false;

        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };


        for (UIView *subUIView in self.bannerController.view.subviews ) {
            [subUIView removeFromSuperview];
        }

        [self listSubviewsOfView:self.bannerController.view];


        [self emitWindowEvent:EVENT_BANNER_FAILED_TO_LOAD withData:data];
    }

- (void)bannerDidLoad:(ISBannerView *)bannerView
    {
        if(self.loadingBanner == true){

        // We call destroy banner before loading a new banner
            if (self.bannerView) {
                [self destroyBanner];
            }

            self.bannerView = bannerView;

            CGFloat xOffset = .0f;
            CGFloat yOffset = .0f;

            CGFloat bannerHeight    = bannerView.frame.size.height;
            CGFloat bannerWidth     = bannerView.frame.size.width;

            UIScreen* mainScreen = [UIScreen mainScreen];

            CGFloat screenHeight = mainScreen.bounds.size.height;
            CGFloat screenWidth = mainScreen.bounds.size.width;

            if ([self.bannerPosition isEqualToString:@"top"])
            {
                yOffset = 0;
            }
            else if([self.bannerPosition isEqualToString:@"bottom"])
            {
                yOffset = screenHeight - bannerHeight;
            }
            else if([self.bannerPosition isEqualToString:@"center"])
            {
                yOffset = (screenHeight - bannerHeight) / 2;
            }

            xOffset = (screenWidth - bannerWidth) / 2;

            CGRect bannerRect = CGRectMake(xOffset, yOffset, bannerWidth, bannerHeight);

            bannerView.frame = bannerRect;

            self.loadingBanner = false;
            NSLog(@"%s", __PRETTY_FUNCTION__);
            [self emitWindowEvent:EVENT_BANNER_DID_LOAD];
        }
    }

- (void)bannerWillLeaveApplication
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_BANNER_WILL_LEAVE_APPLICATION];
    }

- (void)bannerWillPresentScreen
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_BANNER_WILL_PRESENT_SCREEN];
    }

- (void)didClickBanner
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_BANNER_DID_CLICK];
    }

#pragma mark - Offerwall Delegate Functions

    // This method checks if rewarde video is available
- (void)hasOfferwall:(CDVInvokedUrlCommand *)command
    {

        BOOL available = [IronSource hasOfferwall];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)showOfferwall:(CDVInvokedUrlCommand *)command
    {

        NSString *placement = [command argumentAtIndex:0];

        if( placement == nil || [placement length] == 0)
        {
            [IronSource showOfferwallWithViewController:self.viewController];
        }
        else
        {
            [IronSource showOfferwallWithViewController:self.viewController placement:placement];
        }

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error
    {

        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };

        [self emitWindowEvent:EVENT_OFFERWALL_CREDIT_FAILED withData:data];
    }

- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_OFFERWALL_CREDITED withData:creditInfo];
        return YES;
    }

- (void)offerwallDidClose
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_OFFERWALL_SHOW_FAILED];
    }

- (void)offerwallDidFailToShowWithError:(NSError *)error
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };

        [self emitWindowEvent:EVENT_OFFERWALL_CREDIT_FAILED withData:data];
    }

- (void)offerwallDidShow
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_OFFERWALL_SHOWN];
    }

- (void)offerwallHasChangedAvailability:(BOOL)available
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"available" : @(available)
                               };

        [self emitWindowEvent:EVENT_OFFERWALL_AVAILABILITY_CHANGED withData:data];
    }

#pragma mark - Intersitial Delegate Functions

- (void)hasInterstitial:(CDVInvokedUrlCommand *)command
    {

        BOOL available = [IronSource hasInterstitial];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:available];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)loadInterstitial:(CDVInvokedUrlCommand *)command
    {

        NSLog(@"%s", __PRETTY_FUNCTION__);
        [IronSource loadInterstitial];

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)showInterstitial:(CDVInvokedUrlCommand *)command
    {

        NSString *placement = [command argumentAtIndex:0];

        if( placement == nil || [placement length] == 0)
        {
            [IronSource showInterstitialWithViewController:self.viewController];
        }
        else
        {
            [IronSource showInterstitialWithViewController:self.viewController placement:placement];
        }

        // Send callback successfull
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
    }

- (void)didClickInterstitial
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_INTERSTITIAL_CLICKED];
    }

- (void)interstitialDidClose
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_INTERSTITIAL_CLOSED];
    }

- (void)interstitialDidFailToLoadWithError:(NSError *)error
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };

        [self emitWindowEvent:EVENT_INTERSTITIAL_FAILED_TO_LOAD withData:data];
    }

- (void)interstitialDidFailToShowWithError:(NSError *)error
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);

        NSDictionary *data = @{
                               @"error" : @{
                                       @"code" : @(error.code),
                                       @"message" : error.description
                                       }
                               };

        [self emitWindowEvent:EVENT_INTERSTITIAL_SHOW_FAILED withData:data];
    }

- (void)interstitialDidLoad
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_INTERSTITIAL_LOADED];
    }

- (void)interstitialDidOpen
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_INTERSTITIAL_WILL_OPEN];
    }

- (void)interstitialDidShow
    {
        NSLog(@"%s", __PRETTY_FUNCTION__);
        [self emitWindowEvent:EVENT_INTERSTITIAL_SHOWN];
    }

    @end

