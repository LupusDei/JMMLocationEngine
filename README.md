JMMLocationEngine
=================

iOS Location, Four Square Engine and Google Place Engine

Original authtor : https://github.com/LupusDei/JMMLocationEngine

Whats New : Goolge Place Search,AutoComplete and NearbyPlaces

- To get user Location

  Example : 
  
      [JMMLocationEngine getBallParkLocationOnSuccess:^(CLLocation *loc) {
        
      } onFailure:^(NSInteger failCode) {
      
      }];

- Reverse GeoCoding

  Example : 
  
      [JMMLocationEngine getPlacemarkLocationOnSuccess:^(CLPlacemark *place) {
        
      } onFailure:^(NSInteger failCode) {
        
      }];
    
- FourSquare Nearby Venues

  Example : 
    
        [JMMLocationEngine getFoursquareVenuesNearbyOnSuccess:^(NSArray *venues) {
        
        } onFailure:^(NSInteger failCode) {
        
        }];


- To get FourSquare Venue Search 

  Example : 
  
        [JMMLocationEngine getFoursquareVenuesNearbyWithSearchString:searchText onSuccess:^(NSArray *venues) {
        
        } onFailure:^(NSInteger failCode) {
        
        }];
        
Added Google Places API Methods including 
- AutoComplete Places Search (autocomplete)
  //https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=true&key=AddYourOwnKeyHere
  
  Example : 
  
      [JMMLocationEngine getGooglePlaceAutoCompleteWithString:@"Kar"
                                                  OnSuccess:^(NSArray *places){
                                                      NSLog(@"%@",places);
                                                  }
                                                  onFailure:^(NSInteger failCode) {
        
                                                  }];
                                                  
  
- Google Places Text Search (textsearch)
  //https://maps.googleapis.com/maps/api/place/textsearch/json?sensor=true&key=AddYourOwnKeyHere="

  Example :
  
        [JMMLocationEngine searchGooglePlaceWithString:@"Karachi"
                                                  OnSuccess:^(NSArray *places){
                                                      NSLog(@"%@",places);
                                                  }
                                                  onFailure:^(NSInteger failCode) {
                                                      
                                                  }];

- Google Places Nearby Search (nearbysearch)
  //https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=500&types=food&name=harbour&sensor=false&key=AddYourOwnKeyHere

  Example 1 : 
        
        [JMMLocationEngine getNearbyGooglePlaceInRadius:500
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSInteger failCode) {
                                              
                                          }];
    
  Example 2 :     
    
      [JMMLocationEngine getNearbyGooglePlaceInRadius:500 WithName:@"Apple"
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSInteger failCode) {
                                          }];
                                          
    
  Example 3 :     
    
      [JMMLocationEngine getNearbyGooglePlaceInRadius:500
                                           WithName:@""
                                         InCategory:[NSArray arrayWithObjects:kGooglePlacesTypeRestaurant,
                                                     kGooglePlacesTypeShoppingMall,
                                                     nil]
                                          OnSuccess:^(NSArray *places){
                                              NSLog(@"%@",places);
                                          }
                                          onFailure:^(NSInteger failCode) {
                                          }];
                                          
                                          
  Example 4 : 
      
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
                                          onFailure:^(NSInteger failCode) {
                                              
                                          }];



