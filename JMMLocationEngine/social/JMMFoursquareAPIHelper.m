//
//  JMMFoursquareAPIHelper.m
//
//  Created by Justin Martin on 2/28/13.
//
//

#import "JMMFoursquareAPIHelper.h"

@implementation JMMFoursquareAPIHelper

#define FoursquareBaseURL @"api.foursquare.com/v2/"
#define FoursquareVenuesExploreURL @"venues/explore"
#define FoursquareVenuesSearchURL @"venues/search"

+(NSString *) buildFoursquareURLWithPath:(NSString *)path andParams:(NSDictionary *)params {
    __block NSString *url = [@"https://" stringByAppendingString:FoursquareBaseURL];
    url = [url stringByAppendingString:path];
    url = [url stringByAppendingFormat:@"?client_id=%@",FoursquareClientID];
    url = [url stringByAppendingFormat:@"&client_secret=%@", FoursquareClientSecret];
    url = [url stringByAppendingFormat:@"&v=%@", FoursquareVersion];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        url = [url stringByAppendingFormat:@"&%@=%@", key, obj];
    }];
    
    return url;
}

+(NSString *) buildVenuesExploreRequestWithLat:(float)lat long:(float)ln {
    return [self buildFoursquareURLWithPath:FoursquareVenuesExploreURL andParams:@{@"ll":[NSString stringWithFormat:@"%f,%f", lat, ln]}];
}

+(NSString *) buildVenuesSearchRequestWithLat:(float)lat long:(float)ln {
    return [self buildFoursquareURLWithPath:FoursquareVenuesSearchURL andParams:@{@"ll":[NSString stringWithFormat:@"%f,%f", lat, ln]}];
}

@end
