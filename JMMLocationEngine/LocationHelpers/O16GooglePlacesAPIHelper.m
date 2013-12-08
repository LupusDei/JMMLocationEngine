//
//  O16GooglePlacesAPIHelper.m
//  JMMLocationEngine
//
//  Created by M. Arsalan Anwar on 06/12/2013.
//  Copyright (c) 2013 O16 Labs. All rights reserved.
//

#import "O16GooglePlacesAPIHelper.h"

#define GooglePlaceBaseURL          @"maps.googleapis.com/maps/api/place/"
#define GooglePlaceAutoCompleteURL  @"autocomplete/"
#define GooglePlaceSearchURL        @"textsearch/"
#define GooglePlaceNearbySearchURL  @"nearbysearch/"

//https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=AddYourOwnKeyHere
//https://maps.googleapis.com/maps/api/place/textsearch/json?sensor=true&key=AddYourOwnKeyHere&query="
//https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AddYourOwnKeyHere


@implementation O16GooglePlacesAPIHelper

+(NSString *) buildGooglePlacesURLWithPath:(NSString *)path andParams:(NSDictionary *)params {
    __block NSString *url = [@"https://" stringByAppendingString:GooglePlaceBaseURL];
    
    url = [url stringByAppendingString:path];
    url = [url stringByAppendingFormat:@"json?key=%@&sensor=true",GoogleClientID];
    
    [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        url = [url stringByAppendingFormat:@"&%@=%@", key, obj];
    }];
    
    return url;
}

+(NSString *) buildPlaceAutoCompleteWithTypedCharacter:(NSString*)characters{
    characters = [characters stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self buildGooglePlacesURLWithPath:GooglePlaceAutoCompleteURL andParams:@{@"input":[NSString stringWithFormat:@"%@",characters]}];
}

+(NSString *) buildPlaceSearchRequestWithSearchString:(NSString*)searchString{
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [self buildGooglePlacesURLWithPath:GooglePlaceSearchURL andParams:@{@"query":[NSString stringWithFormat:@"%@",searchString]}];
}

+(NSString *) buildNearbyPlaceSearchRequestWithSearchString:(NSString*)searchString andLatitude:(float)lat andlongitude:(float)lng withinRadius:(float)radius inCategorories:(NSArray*)categories{
    
    searchString = searchString.length > 0 ? searchString : @"";
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSString stringWithFormat:@"%f,%f", lat, lng] forKey:@"location"];
    [params setObject:[NSString stringWithFormat:@"%f",radius] forKey:@"radius"];
    if (searchString.length > 0) {
        [params setObject:searchString forKey:@"name"];
    }
    
    if (categories.count > 0) {
        __block NSString *categoriesFormat = @"";
        [categories enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
            categoriesFormat = index == 0 ?
            [categoriesFormat stringByAppendingFormat:@"%@", object]:
            [categoriesFormat stringByAppendingFormat:@"|%@", object];
            
        }];
        
        [params setObject:categoriesFormat forKey:@"type"];
    }
    
    return [self buildGooglePlacesURLWithPath:GooglePlaceNearbySearchURL andParams:params];
    
}
@end
