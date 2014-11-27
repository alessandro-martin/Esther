@import UIKit;

#import "MainTask.h"
#import "UICollectionView+Draggable.h"
#import "NewSubTaskViewController.h"
#import "EditSubTaskViewController.h"

@interface MainTaskViewController : UIViewController <UICollectionViewDataSource_Draggable, UICollectionViewDelegate, NewSubTaskViewControllerDone>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) MainTask *mainTask;
@property (nonatomic, strong) NSManagedObjectContext *moc;

@end
