//
//  MyUiTableViewCell.m
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import "MyUiTableViewCell.h"

@implementation MyUiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setInternalFields:(ToDoEntity *)incomingToDoEntity{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    self.toDoTitleLabel.text = incomingToDoEntity.toDoTitle;
    self.toDoDueDateLabel.text = [dateFormatter stringFromDate:incomingToDoEntity.toDoDueDate];
    
    self.localToDoEntity = incomingToDoEntity;
}

@end
