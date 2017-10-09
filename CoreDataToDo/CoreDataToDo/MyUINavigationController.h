//
//  MyUINavigationController.h
//  CoreDataToDo
//
//  Created by Stefan on 1/14/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVHandlesMOC.h"

@interface MyUINavigationController : UINavigationController <SVHandlesMOC>

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC;


@end

