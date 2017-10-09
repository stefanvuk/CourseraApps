//
//  ChoreLogMO+CoreDataProperties.m
//  CoreDateApp
//
//  Created by Stefan on 12/17/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ChoreLogMO+CoreDataProperties.h"

@implementation ChoreLogMO (CoreDataProperties)

+ (NSFetchRequest<ChoreLogMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChoreLog"];
}

@dynamic when;
@dynamic chore_done;
@dynamic person_who_did_it;

@end
