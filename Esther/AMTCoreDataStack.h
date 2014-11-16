@import Foundation;
@import CoreData;

@interface AMTCoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, copy) NSString * persistentStoreFileName;

// DESIGNATED INITIALIZER
- (instancetype)initWithPersistentStoreFileName:(NSString *)persistentStoreFileName
								   andStoreType:(NSString *)storeType;

+ (instancetype)sharedCoreDataStack;
+ (void)saveContext:(NSManagedObjectContext *)managedObjectContext;

@end
