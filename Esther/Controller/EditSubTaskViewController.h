@import UIKit;

#import "SubTask.h"
#import "NewSubTaskViewController.h"
#import <AMTTimePicker.h>

@interface EditSubTaskViewController : UIViewController <AMTTimePickerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) SubTask *subTask;

@property (nonatomic, weak) id<NewSubTaskViewControllerDone> delegate;

@end
