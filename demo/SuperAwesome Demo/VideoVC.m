//
//  VideoVC.m
//  SuperAwesome Demo
//
//  Created by Gabriel Coman on 08/10/2015.
//  Copyright © 2015 SuperAwesome Ltd. All rights reserved.
//

#import "VideoVC.h"
#import "SuperAwesome.h"

@interface VideoVC () <SAPreloadProtocol>
@property (nonatomic, retain) SAFullscreenVideoAd *video;
@end

@implementation VideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[SAAdPreloader sharedManager] setDelegate:self];
    [[SAAdPreloader sharedManager] preloadAd:21454];
    
    _video = [[SAFullscreenVideoAd alloc] initWithPlcementId:21454];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) playAction:(id)sender {
    [_video play];
}

- (void) didPreloadAd:(SAAd *)ad {
    [_video assignAd:ad];
}

- (void) didFailToPreloadAd:(NSInteger)placementId {
    // failure
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
