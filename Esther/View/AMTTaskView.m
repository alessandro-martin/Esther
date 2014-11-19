#import "AMTTaskView.h"

@interface AMTTaskView ()

@property (nonatomic, getter=isInEditMode) BOOL inEditMode;
@property (nonatomic, readwrite) CGRect bounds;
@end

@implementation AMTTaskView

@synthesize bounds = _bounds;

-(instancetype) init {
	if (self = [super init]){
		_bounds = CGRectMake(0, 0, 100, 100);
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		_bounds = frame;
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
	return gestureRecognizer.numberOfTouches == 2;
}
@end
