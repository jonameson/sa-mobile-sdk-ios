//
//  SABannerAd2.h
//  Pods
//
//  Created by Gabriel Coman on 13/02/2016.
//
//

#import <UIKit/UIKit.h>

// useful imports
#import "SAProtocols.h"
#import "SAWebViewProtocol.h"

// forward declarations
@class SAParentalGate;
@class SAAd;
@class SAWebView;

// class declaration for SABannerAd
@interface SABannerAd : UIView <SAViewProtocol>

@property (nonatomic, weak) id<SAAdProtocol> adDelegate;
@property (nonatomic, weak) id<SAParentalGateProtocol> parentalGateDelegate;
@property (nonatomic, assign) IBInspectable BOOL isParentalGateEnabled;

@end
