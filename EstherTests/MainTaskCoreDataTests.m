@import UIKit;
@import XCTest;

#import "AMTCoreDataStack.h"
#import "MainTask.h"

static NSString * const MAIN_TASK_DEFAULT_NAME = @"Buy a Car";
static NSString * const MAIN_TASK_DEFAULT_DESCRIPTION = @"Steps necessary to purchase an automobile";

static NSString * const OTHER_MAIN_TASK_DEFAULT_NAME = @"Set Up as Freelancer";
static NSString * const OTHER_MAIN_TASK_DEFAULT_DESCRIPTION = @"Steps necessary to independently develop apps";

static NSString * const MAIN_TASK_ENTITY_STRING = @"MainTask";
static NSString * const DATABASE_FILENAME = @"EstherTestDB.sql";

@interface MainTaskCoreDataTests : XCTestCase

@property (nonatomic, strong) AMTCoreDataStack *stack;
@property (nonatomic, strong) MainTask *mainTask;
@property (nonatomic, strong) MainTask *otherMainTask;

@end

@implementation MainTaskCoreDataTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (BOOL)setupAndInsertMainTask {
	if ([MainTask existsMainTaskWithName:MAIN_TASK_DEFAULT_NAME
							   inContext:self.stack.managedObjectContext]) {
		// Task Already Exists!
		return NO;
	}
	self.mainTask = [MainTask insertInManagedObjectContext:self.stack.managedObjectContext];
	self.mainTask.mainTaskName = MAIN_TASK_DEFAULT_NAME;
	self.mainTask.mainTaskDescription = MAIN_TASK_DEFAULT_DESCRIPTION;
	self.mainTask.mainTaskCreationDate = [NSDate date];
	self.mainTask.mainTaskIsVisibleValue = YES;
	
	return YES;
}

- (BOOL)setupAndInsertOtherMainTask {
	if ([MainTask existsMainTaskWithName:OTHER_MAIN_TASK_DEFAULT_NAME
							   inContext:self.stack.managedObjectContext]) {
		//Task Already Exists!
		return NO;
	}
	self.otherMainTask = [MainTask insertInManagedObjectContext:self.stack.managedObjectContext];
	self.otherMainTask.mainTaskName = OTHER_MAIN_TASK_DEFAULT_NAME;
	self.otherMainTask.mainTaskDescription = OTHER_MAIN_TASK_DEFAULT_DESCRIPTION;
	self.otherMainTask.mainTaskCreationDate = [NSDate date];
	self.otherMainTask.mainTaskIsVisibleValue = NO;
	
	return YES;
}

- (void) testInMemoryInsertionSuccessful {
	self.stack = [AMTCoreDataStack sharedCoreDataStack];
	[self setupAndInsertMainTask];
	
	NSError *error;
	[self.stack.managedObjectContext save:&error];
	
	if (error) {
		NSLog(@"%@", error.localizedDescription);
	} else {
		NSLog(@"Saved!");
	}
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MainTask entityName]];
	fetchRequest.predicate = [NSPredicate predicateWithValue:YES];
	NSArray *mainTasks = [self.stack.managedObjectContext executeFetchRequest:fetchRequest
																		error:&error];
	for (MainTask *t in mainTasks) {
		XCTAssertEqualObjects(t.mainTaskName, MAIN_TASK_DEFAULT_NAME);
	}
}

- (void) testPersistentInsertionSuccessful {
	self.stack = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:DATABASE_FILENAME
															  andStoreType:NSSQLiteStoreType];
	if ([self setupAndInsertMainTask]){
		NSError *error;
		if ([self.stack.managedObjectContext hasChanges] && ![self.stack.managedObjectContext save:&error]) {
			NSLog(@"%@", error.localizedDescription);
		} else {
			NSLog(@"Saved!");
		}
		
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[MainTask entityName]];
		fetchRequest.predicate = [NSPredicate predicateWithValue:YES];
		NSArray *mainTasks = [self.stack.managedObjectContext executeFetchRequest:fetchRequest
																			error:&error];
		for (MainTask *t in mainTasks) {
			XCTAssertEqualObjects(t.mainTaskName, MAIN_TASK_DEFAULT_NAME);
		}
	}
}

- (void) testMainTaskExists {
	self.stack = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:DATABASE_FILENAME
															  andStoreType:NSSQLiteStoreType];
	if ([self setupAndInsertMainTask]) {
		BOOL mainTaskExists = [MainTask existsMainTaskWithName:MAIN_TASK_DEFAULT_NAME
													 inContext:self.stack.managedObjectContext];
		XCTAssertTrue(mainTaskExists);
	}
}

- (void) testAllMainTasksWithName {
	self.stack = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:DATABASE_FILENAME
															 andStoreType:NSSQLiteStoreType];
	NSArray *result;
	if([self setupAndInsertMainTask]) {
		 result = [MainTask getMainTasksWithName:MAIN_TASK_DEFAULT_NAME
											   inContext:self.stack.managedObjectContext];
		XCTAssertEqual(result.count, 1);
	}
}

- (void) testsGetMainTasks {
	self.stack = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:DATABASE_FILENAME
															  andStoreType:NSSQLiteStoreType];
	NSError *error;
	NSArray *results;
	if ([self setupAndInsertMainTask]) {
		NSLog(@"There was no mainTask");
	}
	if ([self setupAndInsertOtherMainTask]) {
		NSLog(@"There was no otherTask");
	}
	
	if ([self.stack.managedObjectContext hasChanges] && ![self.stack.managedObjectContext save:&error]) {
		NSLog(@"%@", error.localizedDescription);
	}
	
	results = [MainTask getAllMainTasksInContext:self.stack.managedObjectContext];
	XCTAssertEqual(results.count, 2);
}
@end
