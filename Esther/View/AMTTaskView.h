@import UIKit;

@interface AMTTaskView : UIView <UIDynamicItem, UIGestureRecognizerDelegate>

@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readwrite) CGAffineTransform transform;
@property(nonatomic) BOOL cancelsTouchesInView;
@end
