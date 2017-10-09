//
//  ViewController.m
//  DistanceCalculation
//
//  Created by Stefan on 11/19/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *request;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;
@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;
@property (weak, nonatomic) IBOutlet UIButton *calculateButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@end

@implementation ViewController
- (IBAction)calculateButtonTapped:(id)sender {

    self.calculateButton.enabled = NO;
    
    self.request = [DGDistanceRequest alloc];
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSArray *dests = @[destA, destB, destC];
    
    self.request = [self.request initWithLocationDescriptions:dests sourceDescription:start];
    
    __weak ViewController *weakSelf = self;
    
    self.request.callback = ^void(NSArray *responses){
        ViewController *strongSelf = weakSelf;
        if(!strongSelf) return;
        
        NSNull *badResult = [NSNull null];
        
        if(responses[0] != badResult){
            double dist1;
            if(strongSelf.unitController.selectedSegmentIndex == 0){
                dist1 = [responses[0] floatValue]/1.0;
                NSString *x = [NSString stringWithFormat:@"%.2f m", dist1];
                strongSelf.distanceA.text = x;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 1){
                dist1 = [responses[0] floatValue]/1000.0;
                NSString *x = [NSString stringWithFormat:@"%.2f km", dist1];
                strongSelf.distanceA.text = x;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 2){
                dist1 = [responses[0] floatValue]*0.000621371192;
                NSString *x = [NSString stringWithFormat:@"%.2f miles", dist1];
                strongSelf.distanceA.text = x;
            }
        }
        else
            strongSelf.distanceA.text = @"Error";
        
        if(responses[1] != badResult){
            double dist2;
            if(strongSelf.unitController.selectedSegmentIndex == 0){
                dist2 = [responses[1] floatValue]/1.0;
                NSString *y = [NSString stringWithFormat:@"%.2f m", dist2];
                strongSelf.distanceB.text = y;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 1){
                dist2 = [responses[1] floatValue]/1000.0;
                NSString *y = [NSString stringWithFormat:@"%.2f km", dist2];
                strongSelf.distanceB.text = y;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 2){
                dist2 = [responses[1] floatValue]*0.000621371192;
                NSString *y = [NSString stringWithFormat:@"%.2f miles", dist2];
                strongSelf.distanceB.text = y;
            }
        }
        else
            strongSelf.distanceA.text = @"Error";
        
        if(responses[2] != badResult){
            double dist3;
            if(strongSelf.unitController.selectedSegmentIndex == 0){
                dist3 = [responses[2] floatValue]/1.0;
                NSString *z = [NSString stringWithFormat:@"%.2f m", dist3];
                strongSelf.distanceC.text = z;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 1){
                dist3 = [responses[2] floatValue]/1000.0;
                NSString *z = [NSString stringWithFormat:@"%.2f km", dist3];
                strongSelf.distanceC.text = z;
            }
            else if(strongSelf.unitController.selectedSegmentIndex == 2){
                dist3 = [responses[2] floatValue]*0.000621371192;
                NSString *z = [NSString stringWithFormat:@"%.2f miles", dist3];
                strongSelf.distanceC.text = z;
            }
        }
        else
            strongSelf.distanceC.text = @"Error";
        


        
        strongSelf.request = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    [self.request start];

}



@end
