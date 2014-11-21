#import "DetailViewController.h"
#import <UIColor+FlatColors.h>
#import <pop.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "extobjc.h"
#import "AMTTaskView.h"
#import "AMTGlobalTaskView.h"

static CGFloat	  const TASK_VIEW_ASPECT_RATIO = 0.67;
static CGFloat	  const TASK_VIEW_CORNER_RADIUS_RATIO = 10.0;
static NSString * const TASK_VIEW_CREATED_ANIMATION_KEY = @"taskCreated";

@interface DetailViewController ()

@property (nonatomic, strong) NSMutableArray *taskViews;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic) CGFloat initialTaskViewWidth;
@property (nonatomic) CGFloat initialTaskViewHeight;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehavior;

@end

@implementation DetailViewController

- (IBAction)userTappedMainView:(UITapGestureRecognizer *)sender {
	CGPoint center = [sender locationInView:self.view];
	CGRect taskViewFrame = CGRectMake(center.x,
									  center.y,
									  self.initialTaskViewWidth,
									  self.initialTaskViewHeight);
	AMTTaskView *taskView = [[AMTTaskView alloc] initWithFrame:taskViewFrame];
	taskView.center = center;
	taskView.layer.cornerRadius = self.initialTaskViewWidth / TASK_VIEW_CORNER_RADIUS_RATIO;
	taskView.layer.borderColor = [UIColor blackColor].CGColor;
	taskView.layer.borderWidth = 4.0f;
	NSMutableArray *fromKVC = [self mutableArrayValueForKey:@"taskViews"];
	[fromKVC addObject:taskView];
	
	[self.view addSubview:taskView];
//	[self.collisionBehavior addItem:taskView];
//	[self.dynamicItemBehavior addItem:taskView];
	POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
	animation.springBounciness = 20;
	animation.springSpeed = 50;
	animation.toValue = [NSValue valueWithCGRect:taskViewFrame];
	[taskView.layer pop_addAnimation:animation forKey:TASK_VIEW_CREATED_ANIMATION_KEY];
}

- (NSMutableArray *)taskViews {
	if (!_taskViews) {
		_taskViews = [NSMutableArray array];
	}
	
	return _taskViews;
}
#pragma mark - Managing the detail item

- (void)configureView {
	//self.view.backgroundColor = [UIColor flatCloudsColor];
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	self.initialTaskViewHeight = CGRectGetHeight(self.view.frame) / ((AMTGlobalTaskView *)self.view).sections / 3;
	self.initialTaskViewWidth = self.initialTaskViewHeight / TASK_VIEW_ASPECT_RATIO;
	self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.taskViews];
	self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
	self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.taskViews];
	self.dynamicItemBehavior.allowsRotation = NO;
	[self.animator addBehavior:self.collisionBehavior];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
//	[RACObserve(self, taskViews) subscribeNext:^(NSMutableArray *x) {
//		NSLog(@"%lu", x.count);
//	}];
//	[[RACObserve(self, taskViews) filter:^BOOL(id value) {
//		return [(NSMutableArray *)value count] % 2 == 0 && [(NSMutableArray *)value count] != 0 ;
//	}] subscribeNext:^(id x) {
//		NSLog(@"Even tasks count!");
//	}];
//	
//	[[RACObserve(self, taskViews) filter:^BOOL(id value) {
//		return [(NSMutableArray *)value count] % 2 != 0 ;
//	}] subscribeNext:^(id x) {
//		NSLog(@"Odd tasks count!");
//	}];
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	[self configureView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Utility Methods

@end