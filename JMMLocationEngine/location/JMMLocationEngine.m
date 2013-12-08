//
//  LocationEngine.m
//
//  Created by Justin Martin on 1/25/13.
//
//

#import "JMMLocationEngine.h"
#import "FSConverter.h"
#import "JMMFoursquareAPIHelper.h"

#define UNACCEPTABLE_ACCURACY_IN_METERS 2000
#define LOCATION_REQUEST_TIMEOUT 5

@implementation JMMLocationEngine
BOOL _timerIsValid;
static JMMLocationEngine *currentEngineInstance = nil;

+ (JMMLocationEngine *)current {
    @synchronized(self) {
        return [[self alloc] init];
    }
	return currentEngineInstance;
}


+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (currentEngineInstance == nil) {
			currentEngineInstance = [super allocWithZone:zone];
            currentEngineInstance.locator = [[CLLocationManager alloc] init];
            [currentEngineInstance.locator setDesiredAccuracy:kCLLocationAccuracyKilometer];
            currentEngineInstance.locator.delegate = currentEngineInstance;
		}
        return currentEngineInstance;
    }
    return nil;
}

+(void) getBallParkLocationOnSuccess:(LESuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock {
    if ([CLLocationManager locationServicesEnabled]) {
        JMMLocationEngine *le = [self current];
        le.successBlock = successBlock;
        le.failureBlock = failureBlock;
        [le scheduleTimeout];
        [le.locator startUpdatingLocation];
    }
    else {
        if (failureBlock) {
            failureBlock(AuthorizationFailure);
        }
    }
        
}

+(void) getPlacemarkLocationOnSuccess:(LEPlacemarkBlock)completionBlock onFailure:(LEFailureBlock)failureBlock {
    [self getBallParkLocationOnSuccess:^(CLLocation *loc){
        CLGeocoder *geo = [[CLGeocoder alloc] init];
        [geo reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error){
            completionBlock([placemarks objectAtIndex:0]);
        }];
    } onFailure:failureBlock];
// Use the [placemark addressDictionary] to get this object, which can be easily formatted as needed
//place:{
//    City = "New York";
//    Country = "United States";
//    CountryCode = US;
//    FormattedAddressLines =     (
//                                 "521 5th Ave",
//                                 "New York, NY  10175-0003",
//                                 "United States"
//                                 );
//    Name = "521 5th Ave";
//    PostCodeExtension = 0003;
//    State = "New York";
//    Street = "521 5th Ave";
//    SubAdministrativeArea = "New York";
//    SubLocality = Midtown;
//    SubThoroughfare = 521;
//    Thoroughfare = "5th Ave";
//    ZIP = 10175;
//}
}

+(void) getFoursquareVenuesForLat:(float)lat lng:(float)lng andSearchString:(NSString *)search onSuccess:(void (^)(NSDictionary *venuesInfo))successBlock onFailure:(void (^)(NSError *))failBlock {
    NSString *url = [JMMFoursquareAPIHelper buildVenuesSearchRequestWithLat:lat lng:lng andSearchString:search];
    dispatch_queue_t fsQueue = dispatch_queue_create("fsQueue", nil);
    dispatch_async(fsQueue, ^{
        NSError *error;
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSDictionary *jsonResp;
        if (result) {
            jsonResp = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
        }
        else {
            error = [NSError errorWithDomain:@"com.jmm.JMMLocationEngine" code:1 userInfo:@{@"error":@"Empty response"}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failBlock)
                    failBlock(error);
            }
            else {
                if (successBlock)
                    successBlock([jsonResp objectForKey:@"response"]);
            }
        });
    });
}

+(void) getFoursquareVenuesNearbyWithSearchString:(NSString *)search onSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock {
    [self getBallParkLocationOnSuccess:^(CLLocation *loc) {
        [self getFoursquareVenuesForLat:loc.coordinate.latitude lng:loc.coordinate.longitude andSearchString:search onSuccess:^(NSDictionary *venues) {
            NSArray *vens = [FSConverter convertToObjects:[venues objectForKey:@"venues"]];
            if (successBlock) {
                successBlock(vens);
            }
            
        } onFailure:^(NSError *error) {
            if (failureBlock)
                failureBlock(TimeOutFailure);
        }];
    } onFailure:^(NSInteger failCode) {
        
    }];
}

+(void) getFoursquareVenuesNearbyOnSuccess:(LEFoursquareSuccessBlock)successBlock onFailure:(LEFailureBlock)failureBlock {
	[self getFoursquareVenuesNearbyWithSearchString:@"" onSuccess:successBlock onFailure:failureBlock];
}

+(void) getGooglePlaceAutoCompleteWithString:(NSString*)typedChars OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    
    NSString *url = [O16GooglePlacesAPIHelper buildPlaceAutoCompleteWithTypedCharacter:typedChars];
    
    dispatch_queue_t fsQueue = dispatch_queue_create("GoogleAutoCompleteQueue", nil);
    dispatch_async(fsQueue, ^{
        NSError *error;
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSDictionary *jsonResp;
        if (result) {
            jsonResp = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
        }
        else {
            error = [NSError errorWithDomain:@"com.jmm.JMMLocationEngine" code:1 userInfo:@{@"error":@"Empty response"}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failureBlock)
                failureBlock(error);
            }
            else {
                if (successBlock)
                    successBlock([jsonResp objectForKey:@"predictions"]);
            }
        });
    });
}

+(void) searchGooglePlaceWithString:(NSString*)searchQuery OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    
    NSString *url = [O16GooglePlacesAPIHelper buildPlaceSearchRequestWithSearchString:searchQuery];
    
    dispatch_queue_t fsQueue = dispatch_queue_create("GooglePlacesSearchQueue", nil);
    dispatch_async(fsQueue, ^{
        NSError *error;
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSDictionary *jsonResp;
        if (result) {
            jsonResp = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
        }
        else {
            error = [NSError errorWithDomain:@"com.jmm.JMMLocationEngine" code:1 userInfo:@{@"error":@"Empty response"}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failureBlock)
                    failureBlock(error);
            }
            else {
                if (successBlock)
                    successBlock([jsonResp objectForKey:@"results"]);
            }
        });
    });
}

+(void) getNearbyGooglePlaceInRadius:(float)radius WithLatitude:(float)lat andLongitude:(float)lng WithName:(NSString*)name InCategory:(NSArray*)categories OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    
    NSString *url = [O16GooglePlacesAPIHelper buildNearbyPlaceSearchRequestWithSearchString:name
                                                                                andLatitude:lat
                                                                               andlongitude:lng
                                                                               withinRadius:radius
                                                                             inCategorories:categories];
    
    dispatch_queue_t fsQueue = dispatch_queue_create("GooglePlacesNearBySearchQueue", nil);
    dispatch_async(fsQueue, ^{
        NSError *error;
        NSData *result = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSDictionary *jsonResp;
        if (result) {
            jsonResp = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
        }
        else {
            error = [NSError errorWithDomain:@"com.jmm.JMMLocationEngine" code:1 userInfo:@{@"error":@"Empty response"}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                if (failureBlock)
                failureBlock(error);
            }
            else {
                if (successBlock)
                    successBlock([jsonResp objectForKey:@"results"]);
            }
        });
    });
}

+(void) getNearbyGooglePlaceInRadius:(float)radius OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    [self getBallParkLocationOnSuccess:^(CLLocation *loc) {
        [self getNearbyGooglePlaceInRadius:radius WithLatitude:loc.coordinate.latitude
                              andLongitude:loc.coordinate.longitude
                                  WithName:@""
                                InCategory:nil
                                 OnSuccess:successBlock
                                 onFailure:failureBlock];
        
    } onFailure:^(NSInteger failCode) {
        
    }];
}

+(void) getNearbyGooglePlaceInRadius:(float)radius WithName:(NSString*)name OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    [self getBallParkLocationOnSuccess:^(CLLocation *loc) {
        [self getNearbyGooglePlaceInRadius:radius WithLatitude:loc.coordinate.latitude
                              andLongitude:loc.coordinate.longitude
                                  WithName:name
                                InCategory:nil
                                 OnSuccess:successBlock
                                 onFailure:failureBlock];
    } onFailure:^(NSInteger failCode) {
        
    }];
}

+(void) getNearbyGooglePlaceInRadius:(float)radius WithName:(NSString*)name InCategory:(NSArray*)categories OnSuccess:(LEGooglePlacesSuccessBlock)successBlock onFailure:(LEGooglePlacesFailureBlock)failureBlock{
    
    [self getBallParkLocationOnSuccess:^(CLLocation *loc) {
        [self getNearbyGooglePlaceInRadius:radius WithLatitude:loc.coordinate.latitude
                              andLongitude:loc.coordinate.longitude
                                  WithName:name
                                InCategory:categories
                                 OnSuccess:successBlock
                                 onFailure:failureBlock];
    } onFailure:^(NSInteger failCode) {
        
    }];
}

-(void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorized:
            self.locatorIsAuthorized = YES;
            break;
        case kCLAuthorizationStatusDenied:
            self.locatorIsAuthorized = NO;
            break;
        case kCLAuthorizationStatusNotDetermined:
            self.locatorIsAuthorized = NO;
            break;
        case kCLAuthorizationStatusRestricted:
            self.locatorIsAuthorized = NO;
            break;
        default:
            break;
    }
}

-(BOOL) isInvalidLocation {
    return self.currentLocation.horizontalAccuracy < 0 ? YES : NO;
}

-(BOOL) isSufficientlyAccurate {
    return (self.currentLocation.horizontalAccuracy < UNACCEPTABLE_ACCURACY_IN_METERS) ? YES : NO;
}

-(BOOL) accuracyHasImproved {
    if (!self.lastLocation) return YES;
    return self.currentLocation.horizontalAccuracy < self.lastLocation.horizontalAccuracy ? YES : NO;
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self stopUpdating];
    if (self.failureBlock) {
        self.failureBlock(AuthorizationFailure);   
    }
    self.successBlock = nil;
    self.failureBlock = nil;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.lastLocation = self.currentLocation;
    self.currentLocation = [locations lastObject];
    if ([self isInvalidLocation]) {
        self.currentLocation = self.lastLocation;
    }
    else {
        if ([self isSufficientlyAccurate]) {
            [self stopUpdating];
            if (self.successBlock) {
                self.successBlock(self.currentLocation);
                self.successBlock = nil;
                self.failureBlock = nil;
            }
        }
    }
}

-(void) scheduleTimeout {
    [NSTimer scheduledTimerWithTimeInterval:LOCATION_REQUEST_TIMEOUT target:self selector:@selector(timesUp) userInfo:nil repeats:NO];
    _timerIsValid = YES;
}

-(void) timesUp {
    if (_timerIsValid) {
        self.failureBlock(TimeOutFailure);
        [self stopUpdating];
        self.failureBlock = nil;
        self.successBlock = nil;
    }
}

-(void) stopUpdating {
    [self.locator stopUpdatingLocation];
    _timerIsValid = NO;
}
@end
