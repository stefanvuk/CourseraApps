//
//  AppDelegate.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

