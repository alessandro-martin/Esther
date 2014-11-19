// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubTask.h instead.

#import <CoreData/CoreData.h>

extern const struct SubTaskAttributes {
	__unsafe_unretained NSString *subTaskColor;
	__unsafe_unretained NSString *subTaskDescription;
	__unsafe_unretained NSString *subTaskFinancialCost;
	__unsafe_unretained NSString *subTaskIsCompleted;
	__unsafe_unretained NSString *subTaskIsVisible;
	__unsafe_unretained NSString *subTaskLatitude;
	__unsafe_unretained NSString *subTaskLongitude;
	__unsafe_unretained NSString *subTaskName;
	__unsafe_unretained NSString *subTaskScreenPositionX;
	__unsafe_unretained NSString *subTaskScreenPositionY;
	__unsafe_unretained NSString *subTaskTimeNeeded;
} SubTaskAttributes;

extern const struct SubTaskRelationships {
	__unsafe_unretained NSString *mainTask;
	__unsafe_unretained NSString *parent;
} SubTaskRelationships;

@class MainTask;
@class SubTask;

@class NSObject;

@interface SubTaskID : NSManagedObjectID {}
@end

@interface _SubTask : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) SubTaskID* objectID;

@property (nonatomic, strong) id subTaskColor;

//- (BOOL)validateSubTaskColor:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* subTaskDescription;

//- (BOOL)validateSubTaskDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDecimalNumber* subTaskFinancialCost;

//- (BOOL)validateSubTaskFinancialCost:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskIsCompleted;

@property (atomic) BOOL subTaskIsCompletedValue;
- (BOOL)subTaskIsCompletedValue;
- (void)setSubTaskIsCompletedValue:(BOOL)value_;

//- (BOOL)validateSubTaskIsCompleted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskIsVisible;

@property (atomic) BOOL subTaskIsVisibleValue;
- (BOOL)subTaskIsVisibleValue;
- (void)setSubTaskIsVisibleValue:(BOOL)value_;

//- (BOOL)validateSubTaskIsVisible:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskLatitude;

@property (atomic) float subTaskLatitudeValue;
- (float)subTaskLatitudeValue;
- (void)setSubTaskLatitudeValue:(float)value_;

//- (BOOL)validateSubTaskLatitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskLongitude;

@property (atomic) float subTaskLongitudeValue;
- (float)subTaskLongitudeValue;
- (void)setSubTaskLongitudeValue:(float)value_;

//- (BOOL)validateSubTaskLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* subTaskName;

//- (BOOL)validateSubTaskName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskScreenPositionX;

@property (atomic) float subTaskScreenPositionXValue;
- (float)subTaskScreenPositionXValue;
- (void)setSubTaskScreenPositionXValue:(float)value_;

//- (BOOL)validateSubTaskScreenPositionX:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskScreenPositionY;

@property (atomic) float subTaskScreenPositionYValue;
- (float)subTaskScreenPositionYValue;
- (void)setSubTaskScreenPositionYValue:(float)value_;

//- (BOOL)validateSubTaskScreenPositionY:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* subTaskTimeNeeded;

@property (atomic) double subTaskTimeNeededValue;
- (double)subTaskTimeNeededValue;
- (void)setSubTaskTimeNeededValue:(double)value_;

//- (BOOL)validateSubTaskTimeNeeded:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MainTask *mainTask;

//- (BOOL)validateMainTask:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) SubTask *parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;

@end

@interface _SubTask (CoreDataGeneratedPrimitiveAccessors)

- (id)primitiveSubTaskColor;
- (void)setPrimitiveSubTaskColor:(id)value;

- (NSString*)primitiveSubTaskDescription;
- (void)setPrimitiveSubTaskDescription:(NSString*)value;

- (NSDecimalNumber*)primitiveSubTaskFinancialCost;
- (void)setPrimitiveSubTaskFinancialCost:(NSDecimalNumber*)value;

- (NSNumber*)primitiveSubTaskIsCompleted;
- (void)setPrimitiveSubTaskIsCompleted:(NSNumber*)value;

- (BOOL)primitiveSubTaskIsCompletedValue;
- (void)setPrimitiveSubTaskIsCompletedValue:(BOOL)value_;

- (NSNumber*)primitiveSubTaskIsVisible;
- (void)setPrimitiveSubTaskIsVisible:(NSNumber*)value;

- (BOOL)primitiveSubTaskIsVisibleValue;
- (void)setPrimitiveSubTaskIsVisibleValue:(BOOL)value_;

- (NSNumber*)primitiveSubTaskLatitude;
- (void)setPrimitiveSubTaskLatitude:(NSNumber*)value;

- (float)primitiveSubTaskLatitudeValue;
- (void)setPrimitiveSubTaskLatitudeValue:(float)value_;

- (NSNumber*)primitiveSubTaskLongitude;
- (void)setPrimitiveSubTaskLongitude:(NSNumber*)value;

- (float)primitiveSubTaskLongitudeValue;
- (void)setPrimitiveSubTaskLongitudeValue:(float)value_;

- (NSString*)primitiveSubTaskName;
- (void)setPrimitiveSubTaskName:(NSString*)value;

- (NSNumber*)primitiveSubTaskScreenPositionX;
- (void)setPrimitiveSubTaskScreenPositionX:(NSNumber*)value;

- (float)primitiveSubTaskScreenPositionXValue;
- (void)setPrimitiveSubTaskScreenPositionXValue:(float)value_;

- (NSNumber*)primitiveSubTaskScreenPositionY;
- (void)setPrimitiveSubTaskScreenPositionY:(NSNumber*)value;

- (float)primitiveSubTaskScreenPositionYValue;
- (void)setPrimitiveSubTaskScreenPositionYValue:(float)value_;

- (NSNumber*)primitiveSubTaskTimeNeeded;
- (void)setPrimitiveSubTaskTimeNeeded:(NSNumber*)value;

- (double)primitiveSubTaskTimeNeededValue;
- (void)setPrimitiveSubTaskTimeNeededValue:(double)value_;

- (MainTask*)primitiveMainTask;
- (void)setPrimitiveMainTask:(MainTask*)value;

- (SubTask*)primitiveParent;
- (void)setPrimitiveParent:(SubTask*)value;

@end
