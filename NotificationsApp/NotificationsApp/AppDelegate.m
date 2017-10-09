//
//  AppDelegate.m
//  NotificationsApp
//
//  Created by Stefan on 12/5/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.applicationIconBadgeNumber = 0;
    
    UILocalNotification *localNotif = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
    
    if(localNotif){
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Notification on launch" message:localNotif.alertBody preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
        
        [ac addAction:aa];
        
        // present the popup, and do it on the main thread, proveri tacno za dispatch_async sta je
        dispatch_async(dispatch_get_main_queue(), ^{[application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];});

    }
    
    return YES;
}

- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    application.applicationIconBadgeNumber = 0;
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Notification on action" message:identifier preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:aa];
    
    dispatch_async(dispatch_get_main_queue(), ^{[application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];});
    
    completionHandler();
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    application.applicationIconBadgeNumber = 0;
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Notification while runing" message:notification.alertBody preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
    
    [ac addAction:aa];
    
    // present the popup, and do it on the main thread, proveri tacno za dispatch_async sta je
    dispatch_async(dispatch_get_main_queue(), ^{[application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];});
}

@end
