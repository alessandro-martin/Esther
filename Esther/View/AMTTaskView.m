#import "AMTTaskView.h"
#import <UIColor+FlatColors.h>
#import <POP.h>

@interface AMTTaskView ()

@property (nonatomic, getter=isInEditMode) BOOL inEditMode;
@property (nonatomic, readwrite) CGRect bounds;
@property (nonatomic) CGPoint previousLocation;

@end

@implementation AMTTaskView

@synthesize bounds = _bounds;

-(instancetype) init {
//	if (self = [super init]){
//		_bounds = CGRectMake(0, 0, 100, 100);
//	}
//	return self;
	return [self initWithFrame:CGRectMake(0, 0, 100, 100)];
}

-(instancetype)initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame]) {
		_bounds = frame;
		self.backgroundColor = [UIColor flatTurquoiseColor];
		UIPanGestureRecognizer *panGesture =
		[[UIPanGestureRecognizer alloc] initWithTarget:self
												action:@selector(handlePanGesture:)];
		panGesture.cancelsTouchesInView = NO;
		panGesture.delaysTouchesBegan = NO;
		panGesture.delaysTouchesEnded = NO;
		
		UITapGestureRecognizer *doubleTapGesture =
		[[UITapGestureRecognizer alloc] initWithTarget:self
												action:@selector(handleDoubleTapGesture:)];
		doubleTapGesture.cancelsTouchesInView = NO;
		doubleTapGesture.delaysTouchesBegan = NO;
		doubleTapGesture.delaysTouchesEnded = NO;
		doubleTapGesture.numberOfTapsRequired = 2;
		
		UITapGestureRecognizer *singleTapGesture =
		[[UITapGestureRecognizer alloc] initWithTarget:self
												action:@selector(handleSingleTapGesture:)];
		singleTapGesture.cancelsTouchesInView = NO;
		singleTapGesture.delaysTouchesBegan = NO;
		singleTapGesture.delaysTouchesEnded = NO;
		singleTapGesture.numberOfTapsRequired = 1;
		[singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
		
		self.gestureRecognizers = @[panGesture, singleTapGesture, doubleTapGesture];
	}
	return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.superview bringSubviewToFront:self];
	self.previousLocation = self.center;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.superview layoutSubviews];
}

- (void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGesture{
	self.backgroundColor = [UIColor flatAlizarinColor];
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)tapGesture {
	NSLog(@"Double tap!");
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGesture {
	CGPoint translation = [panGesture translationInView:self.superview];
	self.center = CGPointMake(self.previousLocation.x + translation.x,
							  self.previousLocation.y + translation.y);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
//	return gestureRecognizer.numberOfTouches == 2;
//}
@end
