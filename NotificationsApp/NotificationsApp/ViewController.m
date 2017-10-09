//
//  ViewController.m
//  NotificationsApp
//
//  Created by Stefan on 12/5/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

- (void) requestPermissionToNotify;
- (void) createANotification:(int) secondsInTheFuture;

@end

@implementation ViewController

- (IBAction)scheduleTapped:(id)sender {
    [self requestPermissionToNotify];
    [self createANotification:15];
}

// fja koja na samom pocetku aplikacije otvara onaj prozor za dozvolu notifikacija
// otvara se samo prvi put kada pokrecemo aplikaciju
- (void) requestPermissionToNotify{
    // prva akcija
    UIMutableUserNotificationAction *floatAction = [[UIMutableUserNotificationAction alloc] init];
    floatAction.identifier = @"FLOAT_ACTION";
    floatAction.title = @"Float";
    floatAction.activationMode = UIUserNotificationActivationModeBackground;
    floatAction.destructive = YES;
    floatAction.authenticationRequired = NO;
    // druga akcija
    UIMutableUserNotificationAction *stingAction = [[UIMutableUserNotificationAction alloc] init];
    stingAction.identifier = @"STING_ACTION";
    stingAction.title = @"Sting";
    stingAction.activationMode = UIUserNotificationActivationModeForeground;
    stingAction.destructive = NO;
    stingAction.authenticationRequired = NO;
    
    UIMutableUserNotificationCategory *category = [[UIMutableUserNotificationCategory alloc] init];
    category.identifier = @"MAIN_CATEGORY";
    [category setActions:@[floatAction, stingAction] forContext:UIUserNotificationActionContextDefault];
    
    NSSet *categories = [NSSet setWithObjects:category, nil];
    
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

- (void) createANotification:(int)secondsInTheFuture{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:secondsInTheFuture];
    // timezone je nil, znaci menjace se nas alarm recimo ili notifikacije zajedno sa zonom u kojoj smo
    // ako stavimo da je timezone = neka odredjena zona, onda ce se on zakljucati na nju, valjda
    localNotif.timeZone = nil;
    
    localNotif.alertTitle = @"Alert Title";
    localNotif.alertBody = @"This is the alarm you are looking for!";
    localNotif.alertAction = @"Okay";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    localNotif.applicationIconBadgeNumber = 431;
    
    localNotif.category = @"MAIN_CATEGORY";

    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
