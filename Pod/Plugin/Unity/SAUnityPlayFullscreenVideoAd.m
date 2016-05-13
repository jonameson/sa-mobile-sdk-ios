//
//  SAUnityPlayFullscreenVideoAd.m
//  Pods
//
//  Created by Gabriel Coman on 13/05/2016.
//
//

#import "SAUnityPlayFullscreenVideoAd.h"
// import SA header
#import "SuperAwesome.h"
#import "SAUnityExtensionContext.h"
#import "NSObject+ModelToString.h"
#import "SAParser.h"

@interface SAUnityPlayFullscreenVideoAd () <SAAdProtocol, SAVideoAdProtocol, SAParentalGateProtocol>

@property (nonatomic, strong) NSString *unityAd;
@property (nonatomic, strong) NSString *adJson;
@property (nonatomic, assign) NSInteger placementId;
@property (nonatomic, assign) BOOL isTestingEnabled;
@property (nonatomic, assign) BOOL isParentalGateEnabled;
@property (nonatomic, assign) BOOL shouldShowCloseButton;
@property (nonatomic, assign) BOOL shouldAutomaticallyCloseAtEnd;

@end

@implementation SAUnityPlayFullscreenVideoAd


- (void) showVideoAdWith:(NSInteger)placementId
               andAdJson:(NSString*)adJson
            andUnityName:(NSString*)unityAd
      andHasParentalGate:(BOOL)isParentalGateEnabled
       andHasCloseButton:(BOOL)shouldShowCloseButton
          andClosesAtEnd:(BOOL)shouldAutomaticallyCloseAtEnd {
    
    // get parameters
    _placementId = placementId;
    _adJson = adJson;
    _unityAd = unityAd;
    _isParentalGateEnabled = isParentalGateEnabled;
    _shouldShowCloseButton = shouldShowCloseButton;
    _shouldAutomaticallyCloseAtEnd = shouldAutomaticallyCloseAtEnd;
    
    // form the ad
    SAParser *parser = [[SAParser alloc] init];
    SAAd *parsedAd = [parser parseAdFromExistingString:_adJson];
    
    if (parsedAd != NULL) {
        // create fvad
        SAFullscreenVideoAd *fvad = [[SAFullscreenVideoAd alloc] init];
        [fvad setAd:parsedAd];
        
        // parametrize
        [fvad setIsParentalGateEnabled:_isParentalGateEnabled];
        [fvad setShouldAutomaticallyCloseAtEnd:_shouldAutomaticallyCloseAtEnd];
        [fvad setShouldShowCloseButton:_shouldShowCloseButton];
        
        // set delegates
        [fvad setAdDelegate:self];
        [fvad setParentalGateDelegate:self];
        [fvad setVideoDelegate:self];
        
        // get root vc, show fvad and then play it
        UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:fvad animated:YES completion:^{
            // play
            [fvad play];
            
            // add "bad" as a key in the dictionary, under the Unity Ad name
            [[SAUnityExtensionContext getInstance] setAd:fvad forKey:unityAd];
        }];
    } else {
        if (_adEvent){
            _adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
        }
    }
    
}

- (void) closeFullscreenVideoForUnityName:(NSString *)unityAd {
    NSObject * temp = [[SAUnityExtensionContext getInstance] getAdForKey:unityAd];
    if (temp != NULL){
        if ([temp isKindOfClass:[SAFullscreenVideoAd class]]){
            SAFullscreenVideoAd *fvad = (SAFullscreenVideoAd*)temp;
            [fvad close];
        }
    }
}

#pragma mark <SAAdProtocol Implementations>

- (void) adWasShown:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasShown");
    }
}

- (void) adFailedToShow:(NSInteger)placementId {
    
    [[SAUnityExtensionContext getInstance] removeAd:placementId];
    
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adFailedToShow");
    }
}

- (void) adWasClosed:(NSInteger)placementId {
    
    
    [[SAUnityExtensionContext getInstance] removeAd:placementId];
    
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasClosed");
    }
}

- (void) adWasClicked:(NSInteger)placementId{
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adWasClicked");
    }
}

- (void) adHasIncorrectPlacement:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adHasIncorrectPlacement");
    }
}

#pragma mark <SAParentalGateProtocol Implementations>

- (void) parentalGateWasCanceled:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasCanceled");
    }
}

- (void) parentalGateWasFailed:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasFailed");
    }
}

- (void) parentalGateWasSucceded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_parentalGateWasSucceded");
    }
}

#pragma mark <SAVideoAdProtocol Implementations>

- (void) adStarted:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adStarted");
    }
}

- (void) videoStarted:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_videoStarted");
    }
}

- (void) videoReachedFirstQuartile:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_videoReachedFirstQuartile");
    }
}

- (void) videoReachedMidpoint:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_videoReachedMidpoint");
    }
}

- (void) videoReachedThirdQuartile:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_videoReachedThirdQuartile");
    }
}

- (void) videoEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_videoEnded");
    }
}

- (void) adEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_adEnded");
    }
}

- (void) allAdsEnded:(NSInteger)placementId {
    if (_adEvent){
        _adEvent(_unityAd, (int)placementId, @"callback_allAdsEnded");
    }
}

@end