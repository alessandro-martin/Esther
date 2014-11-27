@import UIKit;

#import "SubTask.h"

@interface EditSubTaskViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) SubTask *subTask;

@end
