//
//  ChoreLogMO+CoreDataProperties.h
//  CoreDateApp
//
//  Created by Stefan on 12/17/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ChoreLogMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChoreLogMO (CoreDataProperties)

+ (NSFetchRequest<ChoreLogMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *when;
@property (nullable, nonatomic, retain) ChoreMO *chore_done;
@property (nullable, nonatomic, retain) PersonMO *person_who_did_it;

@end

NS_ASSUME_NONNULL_END
