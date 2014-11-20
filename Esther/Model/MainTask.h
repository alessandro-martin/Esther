#import "_MainTask.h"

@interface MainTask : _MainTask {}

+ (BOOL) existsMainTaskWithName:(NSString *)mainTaskName
					  inContext:(NSManagedObjectContext *)context;
+ (NSArray *) getMainTasksWithName:(NSString *) mainTaskName
						 inContext:(NSManagedObjectContext *) context;
+ (NSArray *) getAllMainTasksInContext:(NSManagedObjectContext *) context;

@end
