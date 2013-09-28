//
//  JMMFoursquareAPIHelper.h
//
//  Created by Justin Martin on 2/28/13.
//
//

#import <Foundation/Foundation.h>

#define FoursquareClientID @"<insert here>"
#define FoursquareClientSecret @"<insert here>"
#define FoursquareVersion @"20130228"

@interface JMMFoursquareAPIHelper : NSObject

+(NSString *) buildVenuesExploreRequestWithLat:(float)lat long:(float)ln;
+(NSString *) buildVenuesSearchRequestWithLat:(float)lat long:(float)ln;

@end
