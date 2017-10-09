//
//  ViewController.m
//  ReverseGeocode
//
//  Created by Stefan on 1/21/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"


@interface ViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *geocodeLabel;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (weak, nonatomic) IBOutlet UIImageView *pinIcon;
@property (assign, nonatomic) BOOL lookupUP;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.geocoder = [[CLGeocoder alloc] init];
    self.geocodeLabel.text = nil;
    // alpha je koliko je label transparentan
    self.geocodeLabel.alpha = 0.5;
    self.lookupUP = NO;
}

// kada se mapa pomera pokreni execute the lookup, znaci pokrece reverse geocode
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    [self executeTheLookUp];
}

# pragma mark - Private

- (void) executeTheLookUp{
    // ako nije zauzet trazenjem vec necega pokreni reverse geocode
    if(self.lookupUP == NO){
        self.lookupUP = YES;
        CLLocationCoordinate2D coord = [self locationAtCenterOfMapView];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        [self startReverseGeocodeLocation:loc];
    }
}

- (CLLocationCoordinate2D) locationAtCenterOfMapView{
    // uzima koordinate x i y od slike, moze mid max i min, za sredinu gore i dole
    // nama treba min jer je donji deo slike tj spic ono sto je bitno na mapi
    // i to pointuje na neki deo pa cemo na tome da radimo reverse geocoding
    CGPoint centerOfPin = CGPointMake(CGRectGetMinX(self.pinIcon.bounds), CGRectGetMinY(self.pinIcon.bounds));
    // nakon sto smo izracunali koordinate slike, to treba da pretvorimo u mapview space
    // tj latitude i longitude
    return [self.mapView convertPoint:centerOfPin toCoordinateFromView:self.pinIcon];
}

- (void) startReverseGeocodeLocation:(CLLocation *) location{
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray* placemarks, NSError* error){
         if(error){
             UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"There was a problem with reverse geocoding." message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
             [self presentViewController:ac animated:YES completion:nil];
             return;
         }
         
         // grab sme interesting bits of CLLPlacemark and show it
         // but no duplicates
         NSMutableSet *mappedPlaceDescs = [NSMutableSet new];
         for(CLPlacemark *p in placemarks){
             if(p.name != nil)
                 [mappedPlaceDescs addObject:p.name];
             if(p.administrativeArea != nil)
                 [mappedPlaceDescs addObject:p.administrativeArea];
             if(p.country != nil)
                 [mappedPlaceDescs addObject:p.country];
             [mappedPlaceDescs addObjectsFromArray:p.areasOfInterest];
         }
         self.geocodeLabel.text = [[mappedPlaceDescs allObjects] componentsJoinedByString:@"\n"];
         self.geocodeLabel.alpha = 1.0;
         self.lookupUP = NO;
     }];
}

@end














