@import UIKit;

#import "MainTask.h"
@interface NewSubTaskViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) MainTask *mainTask;

@end
