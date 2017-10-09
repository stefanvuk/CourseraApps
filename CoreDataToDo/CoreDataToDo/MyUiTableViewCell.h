//
//  MyUiTableViewCell.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoEntity+CoreDataClass.h"

@interface MyUiTableViewCell : UITableViewCell

@property (strong, nonatomic) ToDoEntity *localToDoEntity;
@property (weak, nonatomic) IBOutlet UILabel *toDoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDoDueDateLabel;


- (void) setInternalFields:(ToDoEntity *)incomingToDoEntity;
@end
