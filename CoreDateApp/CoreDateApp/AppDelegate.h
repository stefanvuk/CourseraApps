//
//  AppDelegate.h
//  CoreDateApp
//
//  Created by Stefan on 12/15/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ChoreMO+CoreDataClass.h"
#import "ChoreLogMO+CoreDataClass.h"
#import "PersonMO+CoreDataClass.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (ChoreMO *) createChoresMO;
- (PersonMO *) createPersonMO;
- (ChoreLogMO *) createChoreLogMO;

- (void)saveContext;


@end

