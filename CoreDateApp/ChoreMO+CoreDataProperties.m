//
//  ChoreMO+CoreDataProperties.m
//  CoreDateApp
//
//  Created by Stefan on 12/17/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ChoreMO+CoreDataProperties.h"

@implementation ChoreMO (CoreDataProperties)

+ (NSFetchRequest<ChoreMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Chore"];
}

@dynamic chore_name;
@dynamic chore_log;

@end
