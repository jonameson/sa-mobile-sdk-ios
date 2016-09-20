//
//  SACapper.m
//  Pods
//
//  Created by Gabriel Coman on 16/02/2016.
//
//

#import "SACapper.h"
#import "SAUtils.h"

#define SUPER_AWESOME_FIRST_PART_DAU @"SUPER_AWESOME_FIRST_PART_DAU"

// this thing right here imports AdSupport framework
@import AdSupport;

@interface SACapper ()
@property (nonatomic, strong) NSUserDefaults *defs;
@end

@implementation SACapper

- (id) init {
    if (self = [super init]) {
        _defs = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void) enableCapping:(didFindDAUId)callback {
    // get if the user has an advertising enabled
    BOOL canTrack = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    
    // if user had disabled tracking --> that's it
    if (!canTrack) {
        callback(0);
        return;
    }
    
    // continue as if  user has Ad Tracking enabled and all ...
    NSString *firstPartOfDAU = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *secondPartOfDAU = [_defs objectForKey:SUPER_AWESOME_FIRST_PART_DAU];
    
    if (!secondPartOfDAU || [secondPartOfDAU isEqualToString:@""]){
        secondPartOfDAU = [SAUtils generateUniqueKey];
        [_defs setObject:secondPartOfDAU forKey:SUPER_AWESOME_FIRST_PART_DAU];
        [_defs synchronize];
    }
    
    NSUInteger hash1 = [firstPartOfDAU hash];
    NSUInteger hash2 = [secondPartOfDAU hash];
    NSUInteger dauHash = hash1 ^ hash2;
    
    callback(dauHash);
}

@end
