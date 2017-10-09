//
//  MyUITableViewController.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVHandlesMOC.h"
#import "SVHandlesToDoEntity.h"

@interface MyUITableViewController : UITableViewController<SVHandlesMOC>

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC;
- (void) receiveToDoEntity:(ToDoEntity*) incomingToDoEntity;

@end
