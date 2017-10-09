//
//  PersonMO+CoreDataProperties.m
//  CoreDateApp
//
//  Created by Stefan on 12/17/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "PersonMO+CoreDataProperties.h"

@implementation PersonMO (CoreDataProperties)

+ (NSFetchRequest<PersonMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic person_name;
@dynamic chore_log;

@end
