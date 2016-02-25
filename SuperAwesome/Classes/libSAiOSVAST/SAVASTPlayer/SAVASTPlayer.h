//
//  SAVASTPlayer.h
//  Pods
//
//  Copyright (c) 2015 SuperAwesome Ltd. All rights reserved.
//
//  Created by Gabriel Coman on 12/15/2015.
//
//

#import <UIKit/UIKit.h>

// import protocol
#import "SAVASTPlayerProtocol.h"

@interface SAVASTPlayer : UIView

// protocol delegate
@property (nonatomic, weak) id<SAVASTPlayerProtocol> delegate;

// play or stop
- (void) playWithMediaURL:(NSURL *)url;

// reset the player
- (void) resetPlayer;

// update frame function
- (void) updateToFrame:(CGRect)frame;

@end
