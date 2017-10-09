//
//  SVHandlesToDoEntity.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDoEntity+CoreDataClass.h"

@protocol SVHandlesToDoEntity <NSObject>

- (void) receiveToDoEntity:(ToDoEntity*) incomingToDoEntity;
@end
