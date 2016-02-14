//
//  SAParentalGate2.m
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 28/09/2015.
//
//

// import main header
#import "SAParentalGate.h"

// import needed modelspace
#import "SAAd.h"
#import "SACreative.h"

// import other headers
#import "SuperAwesome.h"

// import views
#import "SABannerAd2.h"
#import "SAVideoAd2.h"

// aux stuff
#import "UIAlertController+Window.h"
#import "libSAiOSUtils.h"

// parental gate defines
#define SA_CHALLANGE_ALERTVIEW 0
#define SA_ERROR_ALLERTVIEW 1

#define SA_RAND_MIN 50
#define SA_RAND_MAX 99

#define SA_CHALLANGE_ALERTVIEW_TITLE @"Parental Gate"
#define SA_CHALLANGE_ALERTVIEW_MESSAGE @"Please solve the following problem to continue:\n%@ + %@ = ?"
#define SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE [NSString stringWithFormat:SA_CHALLANGE_ALERTVIEW_MESSAGE, @(_number1), @(_number2)]
#define SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE @"Cancel"
#define SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE @"Continue"

#define SA_ERROR_ALERTVIEW_TITLE @"Oops! That was the wrong answer."
#define SA_ERROR_ALERTVIEW_MESSAGE @"Please seek guidance from a responsible adult to help you continue."
#define SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE @"Ok"

// anonymous extension of SAParentalGate
@interface SAParentalGate ()

@property (nonatomic,assign) NSInteger number1;
@property (nonatomic,assign) NSInteger number2;
@property (nonatomic,assign) NSInteger solution;

@property (nonatomic, retain) UIAlertView *challengeAlertView;
@property (nonatomic, retain) UIAlertController *challangeAlertView;
@property (nonatomic, retain) UIAlertView *wrongAnswerAlertView;

// the ad response
@property (nonatomic, retain) SAAd *ad;

// weak ref to view
@property (nonatomic, weak) UIView *weakAdView;

@end

@implementation SAParentalGate

// custom init functions
- (id) initWithWeakRefToView:(UIView *)weakRef {
    if (self = [super init]) {
        _weakAdView = weakRef;
        if ([_weakAdView isKindOfClass:[SABannerAd2 class]]) {
            _ad = [(SABannerAd2*)_weakAdView getAd];
        }
        if ([_weakAdView isKindOfClass:[SAVideoAd2 class]]){
            _ad = [(SAVideoAd2*)_weakAdView getAd];
        }
    }
    
    return self;
}

// init a new question
- (void) newQuestion {
    _number1 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _number2 = [SAUtils randomNumberBetween:SA_RAND_MIN maxNumber:SA_RAND_MAX];
    _solution = _number1 + _number2;
}

- (void) show {
    [self newQuestion];
    
    // action block #1
    actionBlock cancelBlock = ^(UIAlertAction *action) {
        // calls to delegate or blocks
        if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasCanceled:)]){
            [_delegate parentalGateWasCanceled:_ad.placementId];
        }
    };
    
    // action block #2
    actionBlock continueBlock = ^(UIAlertAction *action) {
        
        // get number from text field
        UITextField *textField = [[_challangeAlertView textFields] firstObject];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *input = [f numberFromString:textField.text];
        
        // what happens when you get a right solution
        if([input integerValue] == self.solution){
            
            // call to delegate
            if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasSucceded:)]){
                [_delegate parentalGateWasSucceded:_ad.placementId];
            }
            
            // finally advance to URL
            if ([_weakAdView respondsToSelector:@selector(advanceToClick)]) {
                if ([_weakAdView isKindOfClass:[SABannerAd2 class]]) {
                    [(SABannerAd2*)_weakAdView advanceToClick];
                }
                if ([_weakAdView isKindOfClass:[SAVideoAd2 class]]){
                    [(SAVideoAd2*)_weakAdView advanceToClick];
                }
            }
        }
        // or a bad solution
        else{
            // ERROR
            _wrongAnswerAlertView = [[UIAlertView alloc] initWithTitle:SA_ERROR_ALERTVIEW_TITLE
                                                               message:SA_ERROR_ALERTVIEW_MESSAGE
                                                              delegate:self
                                                     cancelButtonTitle:SA_ERROR_ALERTVIEW_CANCELBUTTON_TITLE
                                                     otherButtonTitles: nil];
            [_wrongAnswerAlertView show];
            
            // call to delegate
            if(_delegate && [_delegate respondsToSelector:@selector(parentalGateWasFailed:)]){
                [_delegate parentalGateWasFailed:_ad.placementId];
            }
        }
    };
    
    
    // alert view (controller)
    _challangeAlertView = [UIAlertController alertControllerWithTitle:SA_CHALLANGE_ALERTVIEW_TITLE
                                                              message:SA_CHALLANGE_ALERTVIEW_FORMATTED_MESSAGE
                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    // actions
    UIAlertAction* continueBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CONTINUEBUTTON_TITLE
                                                          style:UIAlertActionStyleDefault
                                                        handler:continueBlock];
    UIAlertAction* cancelBtn = [UIAlertAction actionWithTitle:SA_CHALLANGE_ALERTVIEW_CANCELBUTTON_TITLE
                                                        style:UIAlertActionStyleDefault
                                                      handler:cancelBlock];
    
    
    // add actions
    [_challangeAlertView addAction:cancelBtn];
    [_challangeAlertView addAction:continueBtn];
    __block UITextField *localTextField;
    
    [_challangeAlertView addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
        localTextField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    [_challangeAlertView show];
}

@end
