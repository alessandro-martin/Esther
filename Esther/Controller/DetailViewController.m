#import "DetailViewController.h"
#import <UIColor+FlatColors.h>
#import <pop.h>

static CGFloat	  const TASK_VIEW_ASPECT_RATIO = 0.67;
static CGFloat	  const TASK_VIEW_CORNER_RADIUS = 10.0;
static NSString * const TASK_VIEW_CREATED_ANIMATION_KEY = @"taskCreated";

@interface DetailViewController ()

@property (nonatomic, strong) NSPointerArray *taskViews;
@property (nonatomic) CGFloat initialTaskViewWidth;

@end

@implementation DetailViewController

- (IBAction)userTappedMainView:(UITapGestureRecognizer *)sender {
	CGPoint center = [sender locationInView:self.view];
	CGRect taskViewFrame = CGRectMake(center.x,
									  center.y,
									  self.initialTaskViewWidth,
									  self.initialTaskViewWidth * TASK_VIEW_ASPECT_RATIO);
	UIView *taskView = [[UIView alloc] initWithFrame:CGRectZero];
	taskView.backgroundColor = [UIColor flatTurquoiseColor];
	taskView.center = center;
	taskView.layer.cornerRadius = TASK_VIEW_CORNER_RADIUS;
	[self.taskViews addPointer:(__bridge void *)(taskView)];
	[self.view addSubview:taskView];
	POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
	animation.completionBlock = ^(POPAnimation *anim, BOOL finished ){
		for (UIView *taskView in self.taskViews) {
			NSLog(@"Center: %@", NSStringFromCGPoint(taskView.center));
		}
	};
	animation.springBounciness = 20;
	animation.springSpeed = 50;
	animation.toValue = [NSValue valueWithCGRect:taskViewFrame];
	[taskView.layer pop_addAnimation:animation forKey:TASK_VIEW_CREATED_ANIMATION_KEY];
}

- (NSPointerArray *)taskViews {
	if (!_taskViews) {
		_taskViews = [NSPointerArray weakObjectsPointerArray];
	}
	
	return _taskViews;
}
#pragma mark - Managing the detail item

- (void)configureView {
	// Update the user interface for the detail item.
}

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.initialTaskViewWidth = CGRectGetWidth(self.view.frame) / 6;
	[self configureView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
