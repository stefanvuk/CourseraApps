//
//  ViewController.m
//  GeoFence
//
//  Created by Stefan on 1/26/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <UserNotifications/UserNotifications.h>

@interface ViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UNUserNotificationCenterDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *statusCheck;

@property (strong, nonatomic) MKPointAnnotation *pinAnno;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, assign) BOOL mapIsMoving;
@property (strong, nonatomic) MKPointAnnotation *currentAnno;
@property (strong, nonatomic) CLCircularRegion *geoRegion;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Turn off the user interface until permission is obtained
    self.uiSwitch.enabled = NO;
    self.statusCheck.enabled = NO;
    
    self.eventLabel.text = @"";
    self.statusLabel.text = @"";
    
    self.mapIsMoving = NO;
    
    // set up location manager
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.allowsBackgroundLocationUpdates = YES;
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5; // meters
    
    // zoom the map very close, auto zooming
    // nisam inicijalizovao promenljivu noLocation tj njene koordinate i odma daje gresku
    // 'Invalid Region <center:-180.00000000, -180.00000000 span:nan, nan>'
    CLLocationCoordinate2D noLocation = CLLocationCoordinate2DMake(44.8010734, 20.4020688);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(noLocation, 500, 500);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES]; // ovo ce uraditi zumiranje

    // create an annotaion for the user`s location
    [self addCurrentAnnotaion];
    
    // create a custom red annotaion on the specific location
    // function needed for this is viewForAnnotation
    self.pinAnno = [[MKPointAnnotation alloc] init];
    self.pinAnno.coordinate = CLLocationCoordinate2DMake(44.820081, 20.453185);
    self.pinAnno.title = @"Store Location!";
    [self.mapView addAnnotation:self.pinAnno];
    
    
    // set up a geoRegion object
    [self setUpGeoRegion];
    
    
    // Check if the device can do geofences, ako nam je available ova klasa za CircularRegion onda trazimo dozvolu za location
    if([CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]] == YES){
        //regardless of authorization, if hardware can support it set up a georegion
        [self setUpGeoRegion];
        
        // proveravamo da li vec imamo autorizaciju za pracenje lokacije
        if(([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) ||
           ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)){
            self.uiSwitch.enabled = YES;
        }
        else{
            //if not authorized try and get it authorized
            [self.locationManager requestAlwaysAuthorization];
            
        }
        //ask for notification permissions if the app is in the background
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    }
    else{
        self.statusLabel.text = @"GeoRegions not supported";
    }
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    CLAuthorizationStatus currentStatus = [CLLocationManager authorizationStatus];
    if((currentStatus == kCLAuthorizationStatusAuthorizedWhenInUse) ||
       (currentStatus == kCLAuthorizationStatusAuthorizedAlways)){
        self.uiSwitch.enabled = YES;
    }
}

- (void) mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.mapIsMoving = YES;
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    self.mapIsMoving = NO;
}

- (void) setUpGeoRegion{
    self.geoRegion = [[CLCircularRegion alloc] initWithCenter:
                      CLLocationCoordinate2DMake(44.820081, 20.453185)
                      radius: 10
                      identifier:@"MyRegionIdentifier"];
}


- (IBAction)switchTapped:(id)sender {
    
    if(self.uiSwitch.isOn){
        self.mapView.showsUserLocation = YES;
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringForRegion:self.geoRegion];
        self.statusCheck.enabled = YES;
    }
    else{
        self.statusCheck.enabled = NO;
        [self.locationManager stopMonitoringForRegion:self.geoRegion];
        [self.locationManager stopUpdatingLocation];
        self.mapView.showsUserLocation = NO;
    }
}

- (void) addCurrentAnnotaion{
    self.currentAnno = [[MKPointAnnotation alloc] init];
    self.currentAnno.coordinate = CLLocationCoordinate2DMake(0.0, 0.0);
    self.currentAnno.title = @"My location";
}

- (void) centerMap:(MKPointAnnotation *)centerPoint{
    [self.mapView setCenterCoordinate:centerPoint.coordinate animated:YES];
}


- (IBAction)statusCheckTapped:(id)sender {
    
    if(self.geoRegion != nil){
        [self.locationManager requestStateForRegion:self.geoRegion];
    }
    
}

// class needed to create custom annotation on a certain location, and set an image for it
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* AnnotaionIdentifier = @"AnnotaionIdentifier";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotaionIdentifier];
    if(annotationView)
        return annotationView;
    else{
        MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotaionIdentifier];
        annotationView.image = [UIImage imageNamed:@"rsz_1map-pin-red-hi.png"];
        return annotationView;
    }
    
    return nil;

}

// alert function da bi prikazali kupon koji nam se trazi kada udjemo u georegion
- (void) showAlertMessage: (NSString *) myMessage{
    UIAlertController *alertController;
    alertController = [UIAlertController alertControllerWithTitle:@"Store Alert" message:myMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelMessage = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelMessage];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//  ovo je za ios 10 da salje notifikacije u foreground
//- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
//    NSLog(@"Here handle push notifications in foreground");
//    //For notification Banner - when app in foreground
//    completionHandler(UNNotificationPresentationOptionAlert + UNNotificationPresentationOptionSound);
//}
// resio sam na nacin da saljem samo UIalertController umesto notifikacije, i to je nesto
// ne moze da prikaze notifikaciju dok smo u samoj aplikaciji, izgleda da je to neko pravilo u ios 9, u 10 postoji nacin iznad je i ne radi ni on :D
// okej izgleda da sam ja debil, ovo didReceiveLocalNotification treba u AppDelegate.m da bi radilo........ DEBIIIIIL!
//- (void) application:(UIApplication *) application didReceiveLocalNotification:(nonnull UILocalNotification *)notification{
//    if(application.applicationState == UIApplicationStateActive){
//        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//        localNotif.fireDate = nil;
//        localNotif.repeatInterval = 0;
//        localNotif.alertTitle = @"Store Alert!";
//        localNotif.alertBody = [NSString stringWithFormat:@"You are near the store"];
//        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//    }
//}


#pragma location call backs

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    self.currentAnno.coordinate = locations.lastObject.coordinate;
    if(self.mapIsMoving == NO)
        [self centerMap:self.currentAnno];
}

- (void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"Geofence Alert";
    note.alertBody = [NSString stringWithFormat:@"You entered the store perimeter"];
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    [self showAlertMessage:@"You received a coupon for 30% off!"];
    self.eventLabel.text = @"Entered";
}

- (void) locationManager:(CLLocationManager *)manager didExitRegion:(nonnull CLRegion *)region{
    UILocalNotification *note = [[UILocalNotification alloc] init];
    note.fireDate = nil;
    note.repeatInterval = 0;
    note.alertTitle = @"Geofence Alert";
    note.alertBody = [NSString stringWithFormat:@"You left the store perimeter"];
    [[UIApplication sharedApplication] scheduleLocalNotification:note];
    
    
    self.eventLabel.text = @"Exited";
}

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    
    if(state == CLRegionStateUnknown)
        self.statusLabel.text = @"Unknown";
    else if(state == CLRegionStateInside)
        self.statusLabel.text = @"Inside";
    else if(state == CLRegionStateOutside)
        self.statusLabel.text = @"Outside";
    else
        self.statusLabel.text = @"Mistery";
}









@end
