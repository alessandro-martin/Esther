@import UIKit;

#import "UICollectionViewLayout_Warpable.h"
#import "LSCollectionViewLayoutHelper.h"

@interface DraggableCollectionViewFlowLayout : UICollectionViewFlowLayout <UICollectionViewLayout_Warpable>

@property (readonly, nonatomic) LSCollectionViewLayoutHelper *layoutHelper;
@end
