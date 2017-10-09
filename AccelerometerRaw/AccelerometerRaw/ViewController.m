//
//  ViewController.m
//  AccelerometerRaw
//
//  Created by Stefan on 1/30/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *staticLabel;
@property (weak, nonatomic) IBOutlet UILabel *dynamicLabel;
@property (weak, nonatomic) IBOutlet UIButton *staticButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicStartButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicStopButton;
@property (strong, nonatomic) CMMotionManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (assign, nonatomic) double x,y,z;

@end

// ova aplikacija ne moze da se testira na simulatoru, moram da je pokrenem na telefonu
// da bi video kako radi
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.staticLabel.text = @"No data";
    self.dynamicLabel.text = @"No data";
    self.staticButton.enabled = NO;
    self.dynamicStartButton.enabled = NO;
    self.dynamicStopButton.enabled = NO;
    
    self.imageView.image = [UIImage imageNamed: @"Meditation_BlueWater_900-375x375.jpg"];
    
    self.x = 0.0;
    self.y = 0.0;
    self.z = 0.0;
    
    self.manager = [[CMMotionManager alloc] init];
    if(self.manager.accelerometerAvailable){
        self.staticButton.enabled = YES;
        self.dynamicStartButton.enabled = YES;
        [self.manager startAccelerometerUpdates];
    } else{
        self.staticLabel.text = @"No accelerometer available";
        self.dynamicLabel.text = @"No accelerometer available";
    }
    
}

- (IBAction)staticRequest:(id)sender {
    CMAccelerometerData *accelerometerData = self.manager.accelerometerData;
    if(accelerometerData != nil){
        CMAcceleration acceleration = accelerometerData.acceleration;
        self.staticLabel.text = [NSString stringWithFormat:@"x:%f\ny:%f\nz:%f",
                                 acceleration.x, acceleration.y, acceleration.z];
        
    }
}

- (IBAction)dynamicStart:(id)sender {
    self.dynamicStartButton.enabled = NO;
    self.dynamicStopButton.enabled = YES;
    
    self.manager.accelerometerUpdateInterval = 0.01;
    
    ViewController * __weak weakSelf = self;
    // pravimo novi thread valjda, jer ne zelimo
    // da nam se ovo izvrsavana main threadu
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [self.manager startAccelerometerUpdatesToQueue:queue withHandler:
     ^(CMAccelerometerData *data, NSError *error){
         // do work here
         self.x = .1 * data.acceleration.x + .9 * self.x;
         self.y = .1 * data.acceleration.y + .9 * self.y;
         self.z = .1 * data.acceleration.z + .9 * self.z;
         double rotation = -atan2(self.x, -self.y);
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             // update UI here
             // ovo za update image znaci da ce slika
             // uvek da se rotira tako da stoji uspravno
             weakSelf.imageView.transform = CGAffineTransformMakeRotation(rotation);
             weakSelf.dynamicLabel.text = [NSString stringWithFormat:
                                           @"rotation:%f\nx:%f\ny:%f\nz:%f",
                                           rotation, self.x, self.y, self.z];
         }];
     }];
}

- (IBAction)dynamicStop:(id)sender {
    [self.manager stopAccelerometerUpdates];
    self.dynamicStartButton.enabled = YES;
    self.dynamicStopButton.enabled = NO;
}

@end











