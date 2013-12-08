//
//  JMMGooglePlace.m
//  JMMLocationEngine
//
//  Created by Justin Martin on 12/8/13.
//  Copyright (c) 2013 JMM. All rights reserved.
//

#import "JMMGooglePlace.h"

@implementation JMMGooglePlace
+(instancetype) placeFromInfo:(NSDictionary *)info {
    JMMGooglePlace *place = [JMMGooglePlace new];
    @try {
        NSDictionary *locInfo = info[@"geometry"];
        NSDictionary *loc = locInfo[@"location"];
        double lat = [((NSNumber *) loc[@"lat"]) doubleValue];
        double lng = [((NSNumber *) loc[@"lng"]) doubleValue];
        place.coordinate = CLLocationCoordinate2DMake(lat, lng);
        place.address = info[@"formatted_address"];
        if (!place.address || [place.address isEqual:[NSNull null]]) {
            place.address = info[@"vicinity"];
        }
        place.iconURL = info[@"icon"];
        place.placeID = info[@"id"];
        place.name = info[@"name"];
        
    } @catch (NSException *e) {
        NSLog(@"Failed to parse place from info:%@\n exception: %@",info, e);
    }
    return place;
}
@end
