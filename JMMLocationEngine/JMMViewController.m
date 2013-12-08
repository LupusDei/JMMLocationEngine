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
    
//    [self getNearbyPlaces];
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
                                                  OnSuccess:^(NSArray *places){
                                                      NSLog(@"%@",places);
                                                  }
                                                  onFailure:^(NSError *error) {
                                                      
                                                  }];
    
}

- (void)searchGooglePlaceWithString:(NSString*)name{
    [JMMLocationEngine searchGooglePlaceWithString:name
                                         OnSuccess:^(NSArray *places){
                                             NSLog(@"%@",places);
                                         }
                                         onFailure:^(NSError *error) {
                                             
                                         }];
    
}

- (void)getNearbyPlaces{
    [JMMLocationEngine getNearbyGooglePlaceInRadius:500
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSError *error) {
                                              
                                          }];
    
    [JMMLocationEngine getNearbyGooglePlaceInRadius:500 WithName:@"Apple"
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSError *error) {
                                              
                                          }];
    
    
    [JMMLocationEngine getNearbyGooglePlaceInRadius:500
                                           WithName:@""
                                         InCategory:[NSArray arrayWithObjects:kGooglePlacesTypeRestaurant,
                                                     kGooglePlacesTypeShoppingMall,
                                                     nil]
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSError *error) {
                                              
                                          }];
    
    
    [JMMLocationEngine getNearbyGooglePlaceInRadius:500
                                       WithLatitude:37.787357
                                       andLongitude:-122.408226
                                           WithName:@""
                                         InCategory:[NSArray arrayWithObjects:kGooglePlacesTypeRestaurant,
                                                     kGooglePlacesTypeShoppingMall,
                                                     nil]
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSError *error) {
                                              
                                          }];
}

@end
