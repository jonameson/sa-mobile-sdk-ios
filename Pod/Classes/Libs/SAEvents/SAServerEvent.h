/**
 * @Copyright:   SuperAwesome Trading Limited 2017
 * @Author:      Gabriel Coman (gabriel.coman@superawesome.tv)
 */

#import <Foundation/Foundation.h>

@class SAAd;
@protocol SASessionProtocol;

// typical event response (used mostly for testing purposes atm)
typedef void (^saDidTriggerEvent) (BOOL success);

@interface SAServerEvent : NSObject {
    SAAd      *ad;
    id<SASessionProtocol> session;
}

- (id) initWithAd: (SAAd*) ad
       andSession: (id<SASessionProtocol>) session;

- (NSString*) getUrl;
- (NSString*) getEndpoint;
- (NSDictionary*) getHeader;
- (NSDictionary*) getQuery;
- (void) triggerEvent;
- (void) triggerEvent: (saDidTriggerEvent) response;

@end
