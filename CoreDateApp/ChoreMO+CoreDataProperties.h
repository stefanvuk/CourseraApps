//
//  ChoreMO+CoreDataProperties.h
//  CoreDateApp
//
//  Created by Stefan on 12/17/16.
//  Copyright © 2016 Stefan. All rights reserved.
//

#import "ChoreMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChoreMO (CoreDataProperties)

+ (NSFetchRequest<ChoreMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chore_name;
@property (nullable, nonatomic, retain) NSSet<ChoreLogMO *> *chore_log;

@end

@interface ChoreMO (CoreDataGeneratedAccessors)

- (void)addChore_logObject:(ChoreLogMO *)value;
- (void)removeChore_logObject:(ChoreLogMO *)value;
- (void)addChore_log:(NSSet<ChoreLogMO *> *)values;
- (void)removeChore_log:(NSSet<ChoreLogMO *> *)values;

@end

NS_ASSUME_NONNULL_END
