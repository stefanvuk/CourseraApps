//
//  SVHandlesMOC.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <Foundation/Foundation.h>

// SVHandles ManagedObjectContext
@protocol SVHandlesMOC <NSObject>

- (void) receiveMOC:(NSManagedObjectContext*) incomingMOC;

@end
