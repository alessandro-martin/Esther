@import UIKit;
#import <UIColor+FlatColors.h>

#import "MainTask.h"

@protocol NewSubTaskViewControllerDone <NSObject>

- (void) updateMainTask;

@end

@interface NewSubTaskViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) MainTask *mainTask;
@property (nonatomic, strong) UIColor *subTaskColor;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<NewSubTaskViewControllerDone> delegate;

@end
