// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SubTask.m instead.

#import "_SubTask.h"

const struct SubTaskAttributes SubTaskAttributes = {
	.subTaskColor = @"subTaskColor",
	.subTaskDescription = @"subTaskDescription",
	.subTaskFinancialCost = @"subTaskFinancialCost",
	.subTaskIsCompleted = @"subTaskIsCompleted",
	.subTaskIsVisible = @"subTaskIsVisible",
	.subTaskLatitude = @"subTaskLatitude",
	.subTaskLongitude = @"subTaskLongitude",
	.subTaskName = @"subTaskName",
	.subTaskScreenPositionX = @"subTaskScreenPositionX",
	.subTaskScreenPositionY = @"subTaskScreenPositionY",
	.subTaskTimeNeeded = @"subTaskTimeNeeded",
};

const struct SubTaskRelationships SubTaskRelationships = {
	.mainTask = @"mainTask",
	.parent = @"parent",
};

@implementation SubTaskID
@end

@implementation _SubTask

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"SubTask" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"SubTask";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"SubTask" inManagedObjectContext:moc_];
}

- (SubTaskID*)objectID {
	return (SubTaskID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"subTaskIsCompletedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskIsCompleted"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskIsVisibleValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskIsVisible"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskLatitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskLatitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskLongitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskLongitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskScreenPositionXValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskScreenPositionX"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskScreenPositionYValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskScreenPositionY"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"subTaskTimeNeededValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"subTaskTimeNeeded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic subTaskColor;

@dynamic subTaskDescription;

@dynamic subTaskFinancialCost;

@dynamic subTaskIsCompleted;

- (BOOL)subTaskIsCompletedValue {
	NSNumber *result = [self subTaskIsCompleted];
	return [result boolValue];
}

- (void)setSubTaskIsCompletedValue:(BOOL)value_ {
	[self setSubTaskIsCompleted:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSubTaskIsCompletedValue {
	NSNumber *result = [self primitiveSubTaskIsCompleted];
	return [result boolValue];
}

- (void)setPrimitiveSubTaskIsCompletedValue:(BOOL)value_ {
	[self setPrimitiveSubTaskIsCompleted:[NSNumber numberWithBool:value_]];
}

@dynamic subTaskIsVisible;

- (BOOL)subTaskIsVisibleValue {
	NSNumber *result = [self subTaskIsVisible];
	return [result boolValue];
}

- (void)setSubTaskIsVisibleValue:(BOOL)value_ {
	[self setSubTaskIsVisible:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSubTaskIsVisibleValue {
	NSNumber *result = [self primitiveSubTaskIsVisible];
	return [result boolValue];
}

- (void)setPrimitiveSubTaskIsVisibleValue:(BOOL)value_ {
	[self setPrimitiveSubTaskIsVisible:[NSNumber numberWithBool:value_]];
}

@dynamic subTaskLatitude;

- (float)subTaskLatitudeValue {
	NSNumber *result = [self subTaskLatitude];
	return [result floatValue];
}

- (void)setSubTaskLatitudeValue:(float)value_ {
	[self setSubTaskLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveSubTaskLatitudeValue {
	NSNumber *result = [self primitiveSubTaskLatitude];
	return [result floatValue];
}

- (void)setPrimitiveSubTaskLatitudeValue:(float)value_ {
	[self setPrimitiveSubTaskLatitude:[NSNumber numberWithFloat:value_]];
}

@dynamic subTaskLongitude;

- (float)subTaskLongitudeValue {
	NSNumber *result = [self subTaskLongitude];
	return [result floatValue];
}

- (void)setSubTaskLongitudeValue:(float)value_ {
	[self setSubTaskLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveSubTaskLongitudeValue {
	NSNumber *result = [self primitiveSubTaskLongitude];
	return [result floatValue];
}

- (void)setPrimitiveSubTaskLongitudeValue:(float)value_ {
	[self setPrimitiveSubTaskLongitude:[NSNumber numberWithFloat:value_]];
}

@dynamic subTaskName;

@dynamic subTaskScreenPositionX;

- (int16_t)subTaskScreenPositionXValue {
	NSNumber *result = [self subTaskScreenPositionX];
	return [result shortValue];
}

- (void)setSubTaskScreenPositionXValue:(int16_t)value_ {
	[self setSubTaskScreenPositionX:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSubTaskScreenPositionXValue {
	NSNumber *result = [self primitiveSubTaskScreenPositionX];
	return [result shortValue];
}

- (void)setPrimitiveSubTaskScreenPositionXValue:(int16_t)value_ {
	[self setPrimitiveSubTaskScreenPositionX:[NSNumber numberWithShort:value_]];
}

@dynamic subTaskScreenPositionY;

- (int16_t)subTaskScreenPositionYValue {
	NSNumber *result = [self subTaskScreenPositionY];
	return [result shortValue];
}

- (void)setSubTaskScreenPositionYValue:(int16_t)value_ {
	[self setSubTaskScreenPositionY:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSubTaskScreenPositionYValue {
	NSNumber *result = [self primitiveSubTaskScreenPositionY];
	return [result shortValue];
}

- (void)setPrimitiveSubTaskScreenPositionYValue:(int16_t)value_ {
	[self setPrimitiveSubTaskScreenPositionY:[NSNumber numberWithShort:value_]];
}

@dynamic subTaskTimeNeeded;

- (double)subTaskTimeNeededValue {
	NSNumber *result = [self subTaskTimeNeeded];
	return [result doubleValue];
}

- (void)setSubTaskTimeNeededValue:(double)value_ {
	[self setSubTaskTimeNeeded:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveSubTaskTimeNeededValue {
	NSNumber *result = [self primitiveSubTaskTimeNeeded];
	return [result doubleValue];
}

- (void)setPrimitiveSubTaskTimeNeededValue:(double)value_ {
	[self setPrimitiveSubTaskTimeNeeded:[NSNumber numberWithDouble:value_]];
}

@dynamic mainTask;

@dynamic parent;

@end

