//
//  ToDoEntity+CoreDataProperties.m
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ToDoEntity+CoreDataProperties.h"

@implementation ToDoEntity (CoreDataProperties)

+ (NSFetchRequest<ToDoEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ToDoEntity"];
}

@dynamic toDoTitle;
@dynamic toDoDetails;
@dynamic toDoDueDate;

@end
