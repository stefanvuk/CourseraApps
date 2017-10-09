//
//  MyUIViewController.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVHandlesMOC.h"
#import "SVHandlesToDoEntity.h"


@interface MyUIViewController : UIViewController<SVHandlesMOC ,SVHandlesToDoEntity>

- (void) receiveToDoEntity:(ToDoEntity*) incomingToDoEntity;
- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
