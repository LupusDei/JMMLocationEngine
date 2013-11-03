//
//  LocationEngine.h
//
//  Created by Justin Martin on 1/25/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FSVenue.h"

#define TimeOutFailure 0
#define AuthorizationFailure 1

@interface JMMLocationEngine : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locator;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) NSDate *lastUpdated;
@property BOOL locatorIsAuthorized;
@property BOOL isCurrentlyBusy;

typedef void (^LESuccessBlock)(CLLocation *loc);
typedef void (^LEPlacemarkBlock)(CLPlacemark *place);
typedef void (^LEFailureBlock)(NSInteger failCode);
typedef void (^LEFoursquareSuccessBlock)(NSArray *venues);
@property (strong, nonatomic) LESuccessBlock successBlock;
@property (strong, nonatomic) LEFailureBlock failureBlock;

+(void) getBallParkLocationOnSuccess:(LESuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;
+(void) getPlacemarkLocationOnSuccess:(LEPlacemarkBlock)completionBlock onFailure:(LEFailureBlock)failureBlock;

+(void) getFoursquareVenuesNearbyOnSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;
+(void) getFoursquareVenuesNearbyWithSearchString:(NSString *)search onSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;
@end
