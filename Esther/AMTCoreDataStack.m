#import "AMTCoreDataStack.h"

@interface AMTCoreDataStack ()

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, copy) NSString *storeType;

@end

@implementation AMTCoreDataStack

+ (instancetype)sharedCoreDataStack { // not a real singleton because we can have instances with alloc init
	static dispatch_once_t once;
	static id sharedInstance;
	dispatch_once(&once, ^{
		sharedInstance = [[self alloc] init];
	});
	
	return sharedInstance;
}

// DESIGNATED INITIALIZER
- (instancetype)initWithPersistentStoreFileName:(NSString *)persistentStoreFileName
								   andStoreType:(NSString *)storeType {
	if (self = [super init]) {
		_persistentStoreFileName = persistentStoreFileName;
		_storeType = storeType;
	}
	return self;
}

- (instancetype)init {
	return [self initWithPersistentStoreFileName:@"default"
									andStoreType:NSInMemoryStoreType];
}


@synthesize managedObjectContext = _managedObjectContext;
- (NSManagedObjectContext *)managedObjectContext {
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	if (!coordinator) {
		return nil;
	}
	_managedObjectContext = [[NSManagedObjectContext alloc] init];
	[_managedObjectContext setPersistentStoreCoordinator:coordinator];
	return _managedObjectContext;
}

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	// Create the coordinator and store
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
	NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:self.persistentStoreFileName];
	NSError *error = nil;
	NSDictionary *options = @{
							  NSMigratePersistentStoresAutomaticallyOption	:	@YES,
							  NSInferMappingModelAutomaticallyOption		:	@YES
							  };
	if (![_persistentStoreCoordinator addPersistentStoreWithType:self.storeType
												   configuration:nil
															 URL:storeURL
														 options:options
														   error:&error]) {
		// Report any error we got by creating an error by hand.
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
		dict[NSLocalizedFailureReasonErrorKey] = @"There was an error creating or loading the application's saved data.";
		dict[NSUnderlyingErrorKey] = error;
		error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN"
									code:9999
								userInfo:dict];
		// Replace this with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
	
	return _persistentStoreCoordinator;
}



#pragma mark Utility Methods

- (NSURL *)applicationDocumentsDirectory {
	// Can use NSTemporaryDirectory
	return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
												   inDomains:NSUserDomainMask] lastObject];
}

+ (void)saveContext:(NSManagedObjectContext *)managedObjectContext {
	if (managedObjectContext == nil) {
		return;
	}
	
	NSError *error = nil;
	if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
		// Replace this implementation with code to handle the error appropriately.
		// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
}

@end
