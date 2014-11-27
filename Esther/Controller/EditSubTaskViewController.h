@import UIKit;

#import "SubTask.h"
#import "NewSubTaskViewController.h"

@interface EditSubTaskViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) SubTask *subTask;

@property (nonatomic, weak) id<NewSubTaskViewControllerDone> delegate;

@end
