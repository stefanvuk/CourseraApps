//
//  ViewController.m
//  ContrsintLayoutsApp
//
//  Created by Stefan on 12/24/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // Initialize web page
    NSString *webURL = @"http://www.pstech.rs";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webURL]];
    
    [self.WebView loadRequest:request];
    
    
    // Center the map
    double latitude = 44.818336;
    double longitude = 20.396297;
    
    MKPointAnnotation *wiclAnno = [[MKPointAnnotation alloc] init];
    wiclAnno.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    wiclAnno.title = @"Paris, France";
    
    [self.MapView addAnnotation:wiclAnno];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(wiclAnno.coordinate, 31000, 31000);
    MKCoordinateRegion adjusted = [self.MapView regionThatFits:region];
    [self.MapView setRegion:adjusted animated:YES];
}





@end
