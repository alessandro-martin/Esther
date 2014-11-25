@import UIKit;

#import "UICollectionViewDataSource_Draggable.h"

@interface UICollectionView (Draggable)

@property (nonatomic, assign) BOOL draggable;
@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;

- (LSCollectionViewHelper *)getHelper;

@end
