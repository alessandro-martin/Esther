//
//  SubTask.h
//  Esther
//
//  Created by Alessandro on 16/11/14.
//  Copyright (c) 2014 Alessandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubTask : NSManagedObject

@property (nonatomic, retain) NSString * subTaskName;
@property (nonatomic, retain) NSString * subTaskDescription;
@property (nonatomic, retain) NSDecimalNumber * subTaskFinancialCost;
@property (nonatomic, retain) NSNumber * subTaskTimeNeeded;
@property (nonatomic, retain) NSNumber * subTaskLongitude;
@property (nonatomic, retain) NSNumber * subTaskLatitude;

@end
