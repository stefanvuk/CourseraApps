//
//  ViewController.m
//  MapViewTestiranje
//
//  Created by Stefan on 1/8/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "MapKit/MapKit.h"

@interface ViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISwitch *switchField;

@property (strong, nonatomic) MKPointAnnotation *wiclAnno;
@property (strong, nonatomic) MKPointAnnotation *luciAnno;
@property (strong, nonatomic) MKPointAnnotation *gradientAnno;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;
@property (nonatomic, assign) BOOL mapIsMoving;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.mapIsMoving = NO;
    [self addAnnotaions];

}

- (IBAction)luciTapped:(id)sender {
    [self centerMap:self.luciAnno];
}

- (IBAction)wiclTapped:(id)sender {
    [self centerMap:self.wiclAnno];
}

- (IBAction)gradientTapped:(id)sender {
    [self centerMap:self.gradientAnno];
}

- (IBAction)switchChanged:(id)sender {
    if(self.switchField.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
    }
    else{
        self.mapView.showsUserLocation = NO;
        [self.locationManager stopUpdatingLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    
    if(self.mapIsMoving == NO){
        [self centerMap:self.currentAnno];
    }
}

-(void) centerMap: (MKPointAnnotation *)centerPoint{

    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}

-(void) addAnnotaions{

    self.luciAnno = [[MKPointAnnotation alloc] init];
    self.luciAnno.coordinate = CLLocationCoordinate2DMake(44.8195164,20.4571263);
    self.luciAnno.title = @"University of Belgrade, Faculty of Mathematics";
    
    self.wiclAnno = [[MKPointAnnotation alloc] init];
    self.wiclAnno.coordinate = CLLocationCoordinate2DMake(44.7999127,20.4846465);
    self.wiclAnno.title = @"Faculty of Mathematics, IT department";
    
    self.gradientAnno = [[MKPointAnnotation alloc] init];
    self.gradientAnno.coordinate = CLLocationCoordinate2DMake(44.8185759,20.421375);
    self.gradientAnno.title = @"Microsoft Belgrade";
    
    self.currentAnno = [[MKPointAnnotation alloc] init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnno.title = @"Current location";
    
    [self.mapView addAnnotations:@[self.luciAnno, self.wiclAnno, self.gradientAnno]];
}

-(void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.mapIsMoving = YES;
}

-(void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.mapIsMoving = NO;
}













@end
