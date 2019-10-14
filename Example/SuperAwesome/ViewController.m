//
//  ViewController.m
//  SuperAwesome
//
//  Created by Gabriel Coman on 10/03/2016.
//  Copyright © 2016 Gabriel Coman. All rights reserved.
//

#import "ViewController.h"
#import "AwesomeAds.h"
#import "SAUtils.h"
#import "SASession.h"
#import "SABumperPage.h"
#import "SAAgeCheck.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet SABannerAd *bannerAd;
@property (nonatomic, strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIButton *ageCheckButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SASession *session = [[SASession alloc] init];
    [session setConfigurationStaging];
    
    [SABumperPage overrideName:@"Test app"];
    [SABumperPage overrideLogo:[UIImage imageNamed:@"kws_700"]];
    
    [_bannerAd setConfigurationProduction];
    [_bannerAd enableTestMode];
    [_bannerAd disableMoatLimiting];
    [_bannerAd enableBumperPage];
    [_bannerAd enableParentalGate];
    [_bannerAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Banner Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [_bannerAd play];
        }
    }];
    
    [SAInterstitialAd setConfigurationProduction];
    [SAInterstitialAd enableTestMode];
    [SAInterstitialAd enableBumperPage];
    [SAInterstitialAd enableParentalGate];
    [SAInterstitialAd disableMoatLimiting];
    [SAInterstitialAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Interstitial Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [SAInterstitialAd play:placementId fromVC:self];
        }
    }];
    
    [SAVideoAd setConfigurationProduction];
    [SAVideoAd enableTestMode];
    [SAVideoAd enableBumperPage];
    [SAVideoAd enableParentalGate];
    [SAVideoAd enableCloseButton];
    [SAVideoAd disableCloseAtEnd];
    [SAVideoAd disableMoatLimiting];
    [SAVideoAd setCallback:^(NSInteger placementId, SAEvent event) {
        
        NSLog(@"SUPER-AWESOME: Video Ad %ld - Event %ld", (long)placementId, (long)event);
        
        if (event == adLoaded) {
            [SAVideoAd play:placementId fromVC:self];
            [SAVideoAd play:placementId fromVC:self];
        }
    }];
    
    _data = [@[
               @{
                   @"name": @"Banners",
                   @"items": @[
                           @{@"name": @"Test Banner", @"pid": @(30471)},
                           ]
                   },
               @{
                   @"name": @"Interstitials",
                   @"items": @[
                           @{@"name": @"CPM Interstitial 1 (Image)", @"pid": @(30473)},
                           ]
                   },
               @{
                   @"name": @"Videos",
                   @"items": @[
                           @{@"name": @"Moat video", @"pid": @(30479)}
                           ]
                   }
               ] mutableCopy];
    
    
    // Age Check
    [_ageCheckButton addTarget:self
                        action:@selector(getIsMinorDetails)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *item = [_data objectAtIndex:section];
    return [item objectForKey:@"name"];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *item = [_data objectAtIndex:section];
    NSArray *items = [item objectForKey:@"items"];
    return [items count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyId"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyId"];
    }
    
    NSDictionary *item = [_data objectAtIndex:[indexPath section]];
    NSArray *items = [item objectForKey:@"items"];
    NSDictionary *placement = [items objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld | %@",
                           (long)[[placement objectForKey:@"pid"] integerValue],
                           [placement objectForKey:@"name"]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *item = [_data objectAtIndex:[indexPath section]];
    NSArray *items = [item objectForKey:@"items"];
    NSDictionary *placement = [items objectAtIndex:[indexPath row]];
    
    NSInteger placementId = [[placement objectForKey:@"pid"] integerValue];
    
    // BANNERS
    if ([indexPath section] == 0) {
        
        [_bannerAd load:placementId];
        
    }
    // INTERSTITIALS
    else if ([indexPath section] == 1) {
        
        [SAInterstitialAd load:placementId];
        
    }
    // VIDEOS
    else if ([indexPath section] == 2) {
        
        [SAVideoAd load:placementId];
        
    }
}

- (void)getIsMinorDetails {
    
    NSString* dateOfBirth = @"2012-02-02";
    __block NSString* message = nil;
    
    [AwesomeAds triggerAgeCheck:dateOfBirth response:^(GetIsMinorModel *model) {
        if (model != nil) {
            NSString* country = [model country];
            NSInteger consentAgeForCountry = [model consentAgeForCountry];
            NSInteger age = [model age];
            BOOL isMinor = [model isMinor];
            
            NSLog(@"Country: %@ | ConsentAgeForCountry %ld | Age: %ld | isMinor: %d", country, (long)consentAgeForCountry ,(long)age, isMinor);
            
            message = [NSString stringWithFormat:@"Success!\n\nCountry - '%@',\n\nConsentAgeForCountry - '%ld',\n\nAge - '%ld',\n\nisMinor - '%d'", country, (long)consentAgeForCountry ,(long)age, isMinor ];
            
        } else {
            message =  @"\nSomething went wrong...\n";
        }
        
        [self showMessage:message atPoint:CGPointMake(self.view.center.x, self.view.center.y)];
    }];
}

- (void)showMessage:(NSString*)message atPoint:(CGPoint)point {
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 150 ,self.view.center.y + 100, 300, 200)];
    label.numberOfLines = 0;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.headIndent = 5.0;
    paragraphStyle.firstLineHeadIndent = 5.0;
    paragraphStyle.tailIndent = -5.0;
    NSDictionary *attrsDictionary = @{NSParagraphStyleAttributeName: paragraphStyle};
    label.attributedText = [[NSAttributedString alloc] initWithString:message attributes:attrsDictionary];
    
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.9];
    label.font=[UIFont fontWithName:@"Helvetica" size:18];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 8;
    [self.view addSubview:label];
    
    [UIView animateWithDuration:4 delay:1 options:0 animations:^{
        label.alpha = 0;
    } completion:^(BOOL finished) {
        label.hidden = YES;
        [label removeFromSuperview];
    }];
}

@end
