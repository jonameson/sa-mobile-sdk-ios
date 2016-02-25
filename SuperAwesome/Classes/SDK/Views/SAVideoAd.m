//
//  SAVideoAd2.m
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import "SAVideoAd.h"

// import Parental Gate
#import "SuperAwesome.h"
#import "SAParentalGate.h"
#import "SAAd.h"
#import "SACreative.h"
#import "SADetails.h"
#import "SASender.h"
#import "SAWebView.h"
#import "SAUtils.h"
#import "SAVASTPlayer.h"
#import "SAVASTManager.h"

#define SMALL_PAD_FRAME CGRectMake(0, 0, 49, 25)

@interface SAVideoAd () <SAVASTManagerProtocol>

@property (nonatomic, weak) id<SAAdProtocol> internalAdProto;
@property (nonatomic, weak) id<SAVideoAdProtocol> internalVideoAdProto;

@property (nonatomic, strong) SAAd *ad;
@property (nonatomic, strong) NSString *destinationURL;

@property (nonatomic, strong) SAParentalGate *gate;
@property (nonatomic, strong) UIImageView *padlock;
@property (nonatomic, strong) SAVASTPlayer *player;
@property (nonatomic, strong) SAVASTManager *manager;

@end

@implementation SAVideoAd

#pragma mark <INIT> functions

- (id) init {
    if (self = [super init]){
        _isParentalGateEnabled = false;
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _isParentalGateEnabled = false;
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]){
        _isParentalGateEnabled = false;
    }
    return self;
}

#pragma mark <SAViewProtocol>

- (void) setAd:(SAAd*)__ad {
    _ad = __ad;
}

- (SAAd*) getAd {
    return _ad;
    return nil;
}

- (void) play {
    // check for incorrect placement
    if (_ad.creative.format != video || _ad == nil) {
        if (_adDelegate != NULL && [_adDelegate respondsToSelector:@selector(adHasIncorrectPlacement:)]){
            [_adDelegate adHasIncorrectPlacement:_ad.placementId];
        }
        return;
    }
    
    // start creating the banner ad
    _gate = [[SAParentalGate alloc] initWithWeakRefToView:self];
    _gate.delegate = _parentalGateDelegate;
    
    // create the player
    _player = [[SAVASTPlayer alloc] initWithFrame:self.bounds];
    [self addSubview:_player];

    // create the vast manager
    _manager = [[SAVASTManager alloc] initWithPlayer:_player];
    _manager.delegate = self;
    [_manager parseVASTURL:_ad.creative.details.vast];

    // add the padlick
    _padlock = [[UIImageView alloc] initWithFrame:SMALL_PAD_FRAME];
    _padlock.image = [UIImage imageNamed:@"watermark_49x25"];
    if (!_ad.isFallback && !_ad.isHouse) {
        [self addSubview:_padlock];
    }
}

- (void) close {
    [_player resetPlayer];
}

- (void) tryToGoToURL:(NSURL*)url {
    // get the going to URL
    _destinationURL = [url absoluteString];
    
    if (_isParentalGateEnabled) {
        // send an event
        [SASender sendEventToURL:_ad.creative.parentalGateClickURL];
        
        // show the gate
        [_gate show];
    } else {
        [self advanceToClick];
    }
}

- (void) advanceToClick {
    NSLog(@"[AA :: INFO] Going to %@", _destinationURL);
    
//    if ([_destinationURL rangeOfString:[[SuperAwesome getInstance] getBaseURL]].location == NSNotFound) {
//        NSLog(@"Sending click event to %@", _ad.creative.trackingURL);
//        [SASender sendEventToURL:_ad.creative.trackingURL];
//    }
    
    // call delegate
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasClicked:)]) {
        [_adDelegate adWasClicked:_ad.placementId];
    }
    
    NSURL *url = [NSURL URLWithString:_destinationURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void) resizeToFrame:(CGRect)toframe {
    
    self.frame = toframe;
    CGRect playerFrame = CGRectMake(0, 0, toframe.size.width, toframe.size.height);
    [_player updateToFrame:playerFrame];
    
    // rearrange the padlock
    _padlock.frame = SMALL_PAD_FRAME;
}

#pragma mark <SAVASTProtocol>

- (void) didParseVASTAndFindAds {
    
}

- (void) didParseVASTButDidNotFindAnyAds {
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:_ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:_ad.placementId];
    }
}

- (void) didNotParseVAST {
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adFailedToShow:)]) {
        [_adDelegate adFailedToShow:_ad.placementId];
    }
    
    // send a message to the internal ad proto as well
    if (_internalAdProto && [_internalAdProto respondsToSelector:@selector(adFailedToShow:)]) {
        [_internalAdProto adFailedToShow:_ad.placementId];
    }
}

- (void) didStartAd {
    // send the viewable impression URL as well
    [SASender sendEventToURL:_ad.creative.viewableImpressionURL];
    
    if (_adDelegate && [_adDelegate respondsToSelector:@selector(adWasShown:)]) {
        [_adDelegate adWasShown:_ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(adStarted:)]) {
        [_internalVideoAdProto adStarted:_ad.placementId];
    }
}

- (void) didStartCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoStarted:)]) {
        [_videoDelegate videoStarted:_ad.placementId];
    }
}

- (void) didReachFirstQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedFirstQuartile:)]) {
        [_videoDelegate videoReachedFirstQuartile:_ad.placementId];
    }
}

- (void) didReachMidpointOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedMidpoint:)]) {
        [_videoDelegate videoReachedMidpoint:_ad.placementId];
    }
}

- (void) didReachThirdQuartileOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoReachedThirdQuartile:)]) {
        [_videoDelegate videoReachedThirdQuartile:_ad.placementId];
    }
}

- (void) didEndOfCreative {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(videoEnded:)]) {
        [_videoDelegate videoEnded:_ad.placementId];
    }
}

- (void) didHaveErrorForCreative{
    
}

- (void) didEndAd {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(adEnded:)]) {
        [_videoDelegate adEnded:_ad.placementId];
    }
}

- (void) didEndAllAds {
    if (_videoDelegate && [_videoDelegate respondsToSelector:@selector(allAdsEnded:)]) {
        [_videoDelegate allAdsEnded:_ad.placementId];
    }
    
    if (_internalVideoAdProto && [_internalVideoAdProto respondsToSelector:@selector(allAdsEnded:)]) {
        [_internalVideoAdProto allAdsEnded:_ad.placementId];
    }
}

- (void) didGoToURL:(NSURL *)url {
    [self tryToGoToURL:url];
}

@end
