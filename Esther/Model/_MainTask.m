// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MainTask.m instead.

#import "_MainTask.h"

const struct MainTaskAttributes MainTaskAttributes = {
	.mainTaskCreationDate = @"mainTaskCreationDate",
	.mainTaskDescription = @"mainTaskDescription",
	.mainTaskImageURL = @"mainTaskImageURL",
	.mainTaskIsVisible = @"mainTaskIsVisible",
	.mainTaskName = @"mainTaskName",
	.mainTaskTotalCost = @"mainTaskTotalCost",
	.mainTaskTotalTime = @"mainTaskTotalTime",
};

const struct MainTaskRelationships MainTaskRelationships = {
	.subTasks = @"subTasks",
};

@implementation MainTaskID
@end

@implementation _MainTask

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MainTask" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MainTask";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MainTask" inManagedObjectContext:moc_];
}

- (MainTaskID*)objectID {
	return (MainTaskID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"mainTaskIsVisibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mainTaskIsVisible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"mainTaskTotalTimeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"mainTaskTotalTime"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic mainTaskCreationDate;

@dynamic mainTaskDescription;

@dynamic mainTaskImageURL;

@dynamic mainTaskIsVisible;

- (BOOL)mainTaskIsVisibleValue {
	NSNumber *result = [self mainTaskIsVisible];
	return [result boolValue];
}

- (void)setMainTaskIsVisibleValue:(BOOL)value_ {
	[self setMainTaskIsVisible:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveMainTaskIsVisibleValue {
	NSNumber *result = [self primitiveMainTaskIsVisible];
	return [result boolValue];
}

- (void)setPrimitiveMainTaskIsVisibleValue:(BOOL)value_ {
	[self setPrimitiveMainTaskIsVisible:[NSNumber numberWithBool:value_]];
}

@dynamic mainTaskName;

@dynamic mainTaskTotalCost;

@dynamic mainTaskTotalTime;

- (double)mainTaskTotalTimeValue {
	NSNumber *result = [self mainTaskTotalTime];
	return [result doubleValue];
}

- (void)setMainTaskTotalTimeValue:(double)value_ {
	[self setMainTaskTotalTime:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveMainTaskTotalTimeValue {
	NSNumber *result = [self primitiveMainTaskTotalTime];
	return [result doubleValue];
}

- (void)setPrimitiveMainTaskTotalTimeValue:(double)value_ {
	[self setPrimitiveMainTaskTotalTime:[NSNumber numberWithDouble:value_]];
}

@dynamic subTasks;

- (NSMutableSet*)subTasksSet {
	[self willAccessValueForKey:@"subTasks"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"subTasks"];

	[self didAccessValueForKey:@"subTasks"];
	return result;
}

@end

