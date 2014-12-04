@import UIKit;

@interface LSCollectionViewHelper : NSObject <UIGestureRecognizerDelegate>

- (id)initWithCollectionView:(UICollectionView *)collectionView;

- (NSIndexPath *)indexPathForItemClosestToPoint:(CGPoint)point; // AMT Exposed this method

@property (nonatomic, readonly) UICollectionView *collectionView;
@property (nonatomic, readonly) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, readonly) UIPanGestureRecognizer *panPressGestureRecognizer;
@property (nonatomic, assign) UIEdgeInsets scrollingEdgeInsets;
@property (nonatomic, assign) CGFloat scrollingSpeed;
@property (nonatomic, assign) BOOL enabled;
@end
