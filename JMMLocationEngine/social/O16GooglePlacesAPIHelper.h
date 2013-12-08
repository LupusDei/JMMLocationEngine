//
//  O16GooglePlacesAPIHelper.h
//  JMMLocationEngine
//
//  Created by M. Arsalan Anwar on 06/12/2013.
//  Copyright (c) 2013 O16 Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GooglePlacesTypes.h"

#define GoogleClientID @"<insert here>"

@interface O16GooglePlacesAPIHelper : NSObject

+(NSString *) buildPlaceAutoCompleteWithTypedCharacter:(NSString*)characters;
+(NSString *) buildPlaceSearchRequestWithSearchString:(NSString*)searchString;
+(NSString *) buildNearbyPlaceSearchRequestWithSearchString:(NSString*)searchString andLatitude:(float)lat andlongitude:(float)lan withinRadius:(float)radius inCategorories:(NSArray*)categories;

@end
