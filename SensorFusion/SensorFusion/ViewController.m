//
//  ViewController.m
//  SensorFusion
//
//  Created by Stefan on 2/1/17.
//  Copyright © 2017 Stefan. All rights reserved.
//


#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic)CMMotionManager *manager;

@property (strong, nonatomic) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.manager = [[CMMotionManager alloc] init];
 
    self.images = @[[UIImage imageNamed:@"1.jpg"], [UIImage imageNamed:@"2.jpg"]
                    , [UIImage imageNamed:@"3.jpg"], [UIImage imageNamed:@"4.jpg"]];
    
    [self chooseImage:0.0];
    
    [self.manager startDeviceMotionUpdates];
    self.manager.accelerometerUpdateInterval = 0.01;
    
    ViewController * __weak weakSelf = self;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // ovo su svi moguci reference frames, moze samo jedan u jedno vreme zato su 3 iskomentarisana
    // razlika izmedju XArbitraryCorrectedZVertical i XArbitraryZVertical je sto corrected
    // pored accelerometra i ziroskopa koristi i magnetometar da bi ispravljao gresku,
    // da bi slika manje driftovala kada rotiramo device
    CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryCorrectedZVertical;
    
//  CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXArbitraryZVertical;
    
    // ovo je orijentisano prema kompasu, tj prati se sever kao pocetna tacka,
    // x osa se poravna sa severom, i to se prati magnetic north
//  CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXMagneticNorthZVertical;
    
    // ovde se koriste prva tri senzora i koristice i senzor za location
//  CMAttitudeReferenceFrame frame = CMAttitudeReferenceFrameXTrueNorthZVertical;
    
    [self.manager startDeviceMotionUpdatesUsingReferenceFrame:frame toQueue:queue withHandler:
     ^(CMDeviceMotion *data, NSError *error){
         // double x = data.gravity.x;
         // double y = data.gravity.y;
         // z nam ne treba za rotaciju, koristimo samo x i y za rotaciju slike
         // double z = data.gravity.z;
         
         // postoje i data.attitude.pitch i data.attitude.yaw svaki je za orijentaciju
         double yaw =  data.attitude.yaw;
         
         // ne treba nam rotacija sada, yaw je rotacija u ovom slucaju
         //double rotation = -atan2(x, -y);
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             weakSelf.imageView.transform = CGAffineTransformMakeRotation(yaw);
         }];
         
         [self chooseImage:yaw];
     }];

}

// na osnovu ugla rotacije bira se odredjena slika
- (void) chooseImage:(double)yaw{
    // ako je yaw manji od pi/4 tj 45 stepeni
    if(yaw <= M_PI_4){
        if(yaw >= M_PI_4)
            self.imageView.image = self.images[0];
        else if(yaw >= -3.0*M_PI_4)
            self.imageView.image = self.images[1];
        else
            self.imageView.image = self.images[2];
    } else{
        if(yaw <= 3.0*M_PI_4)
            self.imageView.image = self.images[3];
        else
            self.imageView.image = self.images[2];
    }
}

// dodatni kod i izmene koda da bi ovaj program
// funkcionisao tako da umesto da radi preko rotacija
// slika se menja kada korisnik cukne telefon ili ipad
// znaci bukvalno smo napravili bump senzor

// @property (assign, nonatomic) int imageCount;

// u viewdidload dodajemo/ili menjamo sledece

// self.imageCount = 0;
// [self chooseImage];
// frame nece biti toliko bitan

// u handleru dodajem
// double x = data.userAcceleration.x;
// double y = data.userAcceleration.y;
// double z = data.userAcceleration.z;
// double bump = sqrt(pow(x,2) + pow(y,2) + pow(z,2));
// ako je bump 3 puta veci od gravitacije, povecaj imageCount
// if(bump > 3.0){
//      self.imageCount++;
//}

// moramo da menjamo chooseImage fju, ovo ide umesto celog koda
// i nema vise yaw promenljive
// self.imageView.image = self.images[self.imageCount %4];

@end
