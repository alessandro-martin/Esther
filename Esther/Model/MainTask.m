#import "MainTask.h"

@interface MainTask ()

// Private interface goes here.

@end

@implementation MainTask

+ (BOOL) existsMainTaskWithName:(NSString *)mainTaskName
					  inContext:(NSManagedObjectContext *)context{
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"mainTaskName = %@", mainTaskName];
	NSUInteger count = [context countForFetchRequest:fetchRequest
											   error:&error];
	if (error) {
		NSLog(@"FATAL ERROR! %@", error.localizedDescription);
		abort();
	}
	return (count == 0) ? NO : YES;
}

+ (NSArray *) getMainTasksWithName:(NSString *) mainTaskName
						 inContext:(NSManagedObjectContext *) context {
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"mainTaskName = %@", mainTaskName];
	NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
	if (error) {
		NSLog(@"FATAL ERROR! %@", error.localizedDescription);
		abort();
	}
	NSAssert(result.count <= 1, @"Duplicate Main Task, that's IMPOSSIBLE!");
	return result;
}

+ (NSArray *) getAllMainTasksInContext:(NSManagedObjectContext *) context {
	NSError *error;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self entityName]];
	fetchRequest.predicate = [NSPredicate predicateWithValue:YES];
	NSArray *mainTasks = [context executeFetchRequest:fetchRequest
												error:&error];
	if (error) {
		NSLog(@"FATAL ERROR! %@", error.localizedDescription);
		abort();
	}
	return mainTasks;
}
@end
