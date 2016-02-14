//
//  TestDataProvider.m
//  sa-mobileios-sdk-test
//
//  Created by Gabriel Coman on 09/12/2015.
//  Copyright © 2015 Gabriel Coman. All rights reserved.
//

#import "TestDataProvider.h"
#import "AdItem.h"

@implementation TestDataProvider

+ (NSArray*) createTestData {
    return @[
             
             CreateAdItem(@"Normal Interstiail 231", 230, false, interstitial_item),
             CreateAdItem(@"Tag Movie 233", 233, false, fullscreen_video_item),
             CreateAdItem(@"Rich Media Interstitial 232", 232, false, interstitial_item),
             CreateAdItem(@"Banner 229", 229, false, banner_item),
             CreateAdItem(@"Normal Movie 231", 231, false, video_item),
             
             
//             CreateAdItem(@"Image Interstitial - 43", 43, false, interstitial_item),
//             CreateAdItem(@"Image Banner - 45", 45, false, banner_item),
//             CreateAdItem(@"Rich Media Interstitial - 44", 44, false, interstitial_item),
//             CreateAdItem(@"Tablet Preroll - 38", 38, false, fullscreen_video_item),
//             CreateAdItem(@"Mobile Preroll - 40", 40, false, fullscreen_video_item),
//             CreateAdItem(@"Rich Media MPU - 46", 46, false, banner_item),
//             CreateAdItem(@"Third Party Tag - 48", 48, false, interstitial_item),
//             CreateAdItem(@"30372", 30372, true, banner_item),
//             CreateAdItem(@"63", 63, false, interstitial_item),
//             CreateAdItem(@"72", 72, false, interstitial_item),
//             
             CreateAdItem(@"Upsight - Phone Portrait Static - 30165", 30165, false, interstitial_item),
             CreateAdItem(@"Upsight - Phone Landscape Static - 30164", 30164, false, interstitial_item),
             
             CreateAdItem(@"Upsight - Tablet Portrait Static - 30166", 30166, false, interstitial_item),
             CreateAdItem(@"Upsight - Tablet Landscape Static - 30167", 30167, false, interstitial_item),
             
             CreateAdItem(@"Upsight - Rewarded Video - 30169", 30169, false, fullscreen_video_item),
             CreateAdItem(@"Upsight - Non Reward Video - 30168", 30168, false, fullscreen_video_item),
//
////             CreateAdItem(@"79 Inter", 79, false, interstitial_item),
//             CreateAdItem(@"79 Video", 79, false, fullscreen_video_item)
             
//             CreateAdItem(@"Banner - 9549", 9549, false, interstitial_item),
//             CreateAdItem(@"Interstitial - 10324", 10324, false, interstitial_item),
//             CreateAdItem(@"Fullscreen Video - 21022", 21022, false, fullscreen_video_item),
//             CreateAdItem(@"Fallback Tag - 10213 ", 10213, false, interstitial_item),
//             CreateAdItem(@"Interstitial - 25397", 25397, false, interstitial_item),
//             CreateAdItem(@"Small Banner - 25785", 25785, false, banner_item),
//             CreateAdItem(@"Test 5740", 5750, true, fullscreen_video_item),
//             CreateAdItem(@"Preroll 28000", 28000, false, fullscreen_video_item),
//             CreateAdItem(@"10198", 10198, false, interstitial_item),
//             CreateAdItem(@"Unity - 30288", 30288, false, fullscreen_video_item),
//             CreateAdItem(@"Poki Test - 30210", 30210, false, fullscreen_video_item),
//             CreateAdItem(@"Fungus Amungus - 30302", 30302, false, banner_item),
//             CreateAdItem(@"10305", 10305, false, interstitial_item),
//             CreateAdItem(@"30324", 30324, false, interstitial_item),
//             CreateAdItem(@"30326", 30326, false, interstitial_item)
             ];
}

@end

AdItem *getItemFromArrayByPlacement(NSArray *arr, NSInteger placementId) {
    
    for (AdItem *item in arr) {
        if (item.placementId == placementId) {
            return item;
            break;
        }
    }
    
    return NULL;
}