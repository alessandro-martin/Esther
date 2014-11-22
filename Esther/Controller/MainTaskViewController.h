@import UIKit;

#import "MainTask.h"
#import "UICollectionView+Draggable.h"

@interface MainTaskViewController : UIViewController <UICollectionViewDataSource_Draggable, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) MainTask *detailItem;

@end
