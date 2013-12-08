//
//  JMMViewController.m
//  JMMLocationEngine
//
//  Created by Justin Martin on 9/26/13.
//  Copyright (c) 2013 JMM. All rights reserved.
//

#import "JMMViewController.h"
#import "JMMLocationEngine.h"

@interface JMMViewController ()
@property (strong, nonatomic) NSArray *venues;
@end

@implementation JMMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.venueTableView.dataSource = self;
    self.venueTableView.delegate = self;
    self.venues = @[];
    self.searchBar.delegate = self;
    [self getLocationPressed:self];
    
    [self getNearbyPlaces];
//    [self searchGooglePlaceWithString:@"Karachi"];
//    [self AutoCompletePlaceNameWithCharacters:@"Kar"];
    
}
- (IBAction)getLocationPressed:(id)sender {
    [JMMLocationEngine getBallParkLocationOnSuccess:^(CLLocation *loc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLabelsWithLoc:loc];
        });
    } onFailure:^(NSInteger failCode) {
    }];
}
- (IBAction)getPlacemarksPressed:(id)sender {
    [JMMLocationEngine getPlacemarkLocationOnSuccess:^(CLPlacemark *place) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLabelsWithLoc:place.location];
            [self.placeLabel setText:[[[place addressDictionary] objectForKey:@"FormattedAddressLines"] objectAtIndex:0]];
        });
    } onFailure:^(NSInteger failCode) {
        
    }];
}
- (IBAction)getVenuesPressed:(id)sender {
    [JMMLocationEngine getFoursquareVenuesNearbyOnSuccess:^(NSArray *venues) {
        self.venues = venues;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.venueTableView reloadData];
        });
    } onFailure:^(NSInteger failCode) {
        
    }];
}

-(void) setLabelsWithLoc:(CLLocation *)loc {
    self.latLabel.text = [NSString stringWithFormat:@"%f",loc.coordinate.latitude];
    self.lngLabel.text = [NSString stringWithFormat:@"%f",loc.coordinate.longitude];
    self.accuracyLabel.text = [NSString stringWithFormat:@"%f",loc.horizontalAccuracy];
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.venues count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VenueCell"];
    
    FSVenue *venue = [self.venues objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:venue.name];
    [cell.detailTextLabel setText:[venue.location.distance stringValue]];
    return cell;
}

-(void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [JMMLocationEngine getFoursquareVenuesNearbyWithSearchString:searchText onSuccess:^(NSArray *venues) {
        self.venues = venues;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.venueTableView reloadData];
        });
    } onFailure:^(NSInteger failCode) {
        
    }];
}

#pragma mark - Google Places Test Methods
- (void)AutoCompletePlaceNameWithCharacters:(NSString*)chars{
    
    [JMMLocationEngine getGooglePlaceAutoCompleteWithString:chars
                                                  onSuccess:^(NSArray *places){
                                                      NSLog(@"%@",places);
                                                  }
                                                  onFailure:^(NSError *error) {
                                                      
                                                  }];
    
}

- (void)searchGooglePlaceWithString:(NSString*)name{
    [JMMLocationEngine getGooglePlacesWithString:name
                                         onSuccess:^(NSArray *places){
                                             NSLog(@"%@",places);
                                         }
                                         onFailure:^(NSError *error) {
                                             
                                         }];
    
}

- (void)getNearbyPlaces{
    [JMMLocationEngine getGooglePlacesNearbyOnSuccess:^(NSArray *places) {
        JMMGooglePlace *place = places[0];
        NSLog(@"Place addr:%@   lat:%f   lng:%f   name:%@", place.address, place.coordinate.latitude, place.coordinate.longitude, place.name);
        
    } onFailure:^(NSError *error) {
        
    }];
//    [JMMLocationEngine getNearbyGooglePlacesInRadius:500
//                                          onSuccess:^(NSArray *places){
//                                              NSLog(@"%@",places);
//                                          }
//                                          onFailure:^(NSError *error) {
//                                              
//                                          }];
//    
//    [JMMLocationEngine getNearbyGooglePlacesInRadius:500 withName:@"Apple"
//                                          onSuccess:^(NSArray *places){
//                                              NSLog(@"%@",places);
//                                          }
//                                          onFailure:^(NSError *error) {
//                                              
//                                          }];
//    
//    
//    [JMMLocationEngine getNearbyGooglePlacesInRadius:500
//                                           withName:@""
//                                         inCategory:[NSArray arrayWithObjects:kGooglePlacesTypeRestaurant,
//                                                     kGooglePlacesTypeShoppingMall,
//                                                     nil]
//                                          onSuccess:^(NSArray *places){
//                                              NSLog(@"%@",places);
//                                          }
//                                          onFailure:^(NSError *error) {
//                                              
//                                          }];
//    
//    
//    [JMMLocationEngine getNearbyGooglePlacesInRadius:500
//                                       withLat:37.787357
//                                       lng:-122.408226
//                                           name:@""
//                                         inCategory:[NSArray arrayWithObjects:kGooglePlacesTypeRestaurant,
//                                                     kGooglePlacesTypeShoppingMall,
//                                                     nil]
//                                          onSuccess:^(NSArray *places){
//                                              NSLog(@"%@",places);
//                                          }
//                                          onFailure:^(NSError *error) {
//                                              
//                                          }];
}

@end
