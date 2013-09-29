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
    [self getLocationPressed:self];
}
- (IBAction)getLocationPressed:(id)sender {
    [JMMLocationEngine getBallParkLocationOnSuccess:^(CLLocation *loc) {
        NSLog(@"JMMVC -- ballpark:%@", loc);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setLabelsWithLoc:loc];
        });
    } onFailure:^(NSInteger failCode) {
        NSLog(@"JMMVC -- failed to get ballpark location");
    }];
}
- (IBAction)getPlacemarksPressed:(id)sender {
    [JMMLocationEngine getPlacemarkLocationOnSuccess:^(CLPlacemark *place) {
        NSLog(@"JMMVC -- placemark:%@", place);
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

@end
