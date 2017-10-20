//
//  ISAppLovinRewardedVideoListener.h
//  ISAppLovinAdapter
//
//  Created by Daniil Bystrov on 3/15/16.
//  Copyright © 2016 IronSource. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ALSdk.h>
#import "ALIncentivizedInterstitialAd.h"

@protocol ISAppLovinRewardedVideoDelegate  <NSObject>
- (void)adUnitRVDidLoad;
- (void)adUnitRVDidFailToLoadWithError:(int)code;
- (void)adUnitRVFullyWatched;
- (void)adUnitRVRewardValidationRequestDidFailedWithError:(int)code;
- (void)adUnitRVStarted;
- (void)adUnitRVEnded;
- (void)adunitRVWasDisplayed;
- (void)adunitRVWasHidden;
- (void)adunitRVWasClicked;
@end

@interface ISAppLovinRewardedVideoListener : NSObject <ALAdLoadDelegate, ALAdDisplayDelegate, ALAdRewardDelegate, ALAdVideoPlaybackDelegate>
@property (nonatomic, weak) id<ISAppLovinRewardedVideoDelegate> delegate;
@end
