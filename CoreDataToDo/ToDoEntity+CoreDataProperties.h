//
//  ToDoEntity+CoreDataProperties.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "ToDoEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ToDoEntity (CoreDataProperties)

+ (NSFetchRequest<ToDoEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *toDoTitle;
@property (nullable, nonatomic, copy) NSString *toDoDetails;
@property (nullable, nonatomic, copy) NSDate *toDoDueDate;

@end

NS_ASSUME_NONNULL_END
