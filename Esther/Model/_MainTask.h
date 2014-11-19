// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MainTask.h instead.

#import <CoreData/CoreData.h>

extern const struct MainTaskAttributes {
	__unsafe_unretained NSString *mainTaskCreationDate;
	__unsafe_unretained NSString *mainTaskDescription;
	__unsafe_unretained NSString *mainTaskImageURL;
	__unsafe_unretained NSString *mainTaskIsVisible;
	__unsafe_unretained NSString *mainTaskName;
	__unsafe_unretained NSString *mainTaskTotalCost;
	__unsafe_unretained NSString *mainTaskTotalTime;
} MainTaskAttributes;

extern const struct MainTaskRelationships {
	__unsafe_unretained NSString *subTasks;
} MainTaskRelationships;

@class SubTask;

@interface MainTaskID : NSManagedObjectID {}
@end

@interface _MainTask : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MainTaskID* objectID;

@property (nonatomic, strong) NSDate* mainTaskCreationDate;

//- (BOOL)validateMainTaskCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* mainTaskDescription;

//- (BOOL)validateMainTaskDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* mainTaskImageURL;

//- (BOOL)validateMainTaskImageURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* mainTaskIsVisible;

@property (atomic) BOOL mainTaskIsVisibleValue;
- (BOOL)mainTaskIsVisibleValue;
- (void)setMainTaskIsVisibleValue:(BOOL)value_;

//- (BOOL)validateMainTaskIsVisible:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* mainTaskName;

//- (BOOL)validateMainTaskName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDecimalNumber* mainTaskTotalCost;

//- (BOOL)validateMainTaskTotalCost:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* mainTaskTotalTime;

@property (atomic) double mainTaskTotalTimeValue;
- (double)mainTaskTotalTimeValue;
- (void)setMainTaskTotalTimeValue:(double)value_;

//- (BOOL)validateMainTaskTotalTime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *subTasks;

- (NSMutableSet*)subTasksSet;

@end

@interface _MainTask (SubTasksCoreDataGeneratedAccessors)
- (void)addSubTasks:(NSSet*)value_;
- (void)removeSubTasks:(NSSet*)value_;
- (void)addSubTasksObject:(SubTask*)value_;
- (void)removeSubTasksObject:(SubTask*)value_;

@end

@interface _MainTask (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveMainTaskCreationDate;
- (void)setPrimitiveMainTaskCreationDate:(NSDate*)value;

- (NSString*)primitiveMainTaskDescription;
- (void)setPrimitiveMainTaskDescription:(NSString*)value;

- (NSString*)primitiveMainTaskImageURL;
- (void)setPrimitiveMainTaskImageURL:(NSString*)value;

- (NSNumber*)primitiveMainTaskIsVisible;
- (void)setPrimitiveMainTaskIsVisible:(NSNumber*)value;

- (BOOL)primitiveMainTaskIsVisibleValue;
- (void)setPrimitiveMainTaskIsVisibleValue:(BOOL)value_;

- (NSString*)primitiveMainTaskName;
- (void)setPrimitiveMainTaskName:(NSString*)value;

- (NSDecimalNumber*)primitiveMainTaskTotalCost;
- (void)setPrimitiveMainTaskTotalCost:(NSDecimalNumber*)value;

- (NSNumber*)primitiveMainTaskTotalTime;
- (void)setPrimitiveMainTaskTotalTime:(NSNumber*)value;

- (double)primitiveMainTaskTotalTimeValue;
- (void)setPrimitiveMainTaskTotalTimeValue:(double)value_;

- (NSMutableSet*)primitiveSubTasks;
- (void)setPrimitiveSubTasks:(NSMutableSet*)value;

@end
