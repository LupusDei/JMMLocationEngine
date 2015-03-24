//
//  LocationEngine.h
//
//  Created by Justin Martin on 1/25/13.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FSVenue.h"
#import "JMMGooglePlace.h"

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

typedef void (^LEGooglePlacesSuccessBlock)(NSArray *places);
typedef void (^LEGooglePlacesFailureBlock)(NSError *error);

typedef void (^LERegionEntryExitBlock)(NSString *regionIdentifier);

@property (strong, nonatomic) LESuccessBlock successBlock;
@property (strong, nonatomic) LEFailureBlock failureBlock;
@property (strong, nonatomic) LERegionEntryExitBlock entryBlock;
@property (strong, nonatomic) LERegionEntryExitBlock exitBlock;


+(void) getBallParkLocationOnSuccess:(LESuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;
+(void) getPlacemarkLocationOnSuccess:(LEPlacemarkBlock)completionBlock onFailure:(LEFailureBlock)failureBlock;

+(void) getFoursquareVenuesNearbyOnSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;
+(void) getFoursquareVenuesNearbyWithSearchString:(NSString *)search onSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock;

+(void) getGooglePlacesNearbyOnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;
+(void) getGooglePlacesWithString:(NSString*)searchQuery onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;
+(void) getGooglePlaceAutoCompleteWithString:(NSString*)typedChars onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;

//New Entry or Exit blocks will apply to all monitored regions.  Differentiate by using the identifier passed through
+(CLCircularRegion *) monitorRegionInRadius:(double)radius aroundLat:(double)lat lng:(double)lng withIdentifier:(NSString *)identifier onEntry:(LERegionEntryExitBlock)entryBlock onExit:(LERegionEntryExitBlock)exitBlock;

/*******  Other Helpers.   Radius is in meters *********/
+(void) getNearbyGooglePlacesInRadius:(float)radius onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;
+(void) getNearbyGooglePlacesInRadius:(float)radius withName:(NSString*)name onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;
+(void) getNearbyGooglePlacesInRadius:(float)radius withName:(NSString*)name inCategory:(NSArray*)categories onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;
+(void) getNearbyGooglePlacesInRadius:(float)radius withLat:(float)lat lng:(float)lng name:(NSString*)name inCategory:(NSArray*)categories onSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock;


@end
