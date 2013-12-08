//
//  JMMGooglePlace.h
//  JMMLocationEngine
//
//  Created by Justin Martin on 12/8/13.
//  Copyright (c) 2013 JMM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface JMMGooglePlace : NSObject
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *iconURL;
@property (nonatomic, strong) NSString *placeID;
@property (nonatomic, strong) NSString *name;

+(instancetype) placeFromInfo:(NSDictionary *)info;
@end
