@import MobileCoreServices;

#import <UIColor+FlatColors.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NewMainTaskViewController.h"
#import "MainTask.h"

@interface NewMainTaskViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMainTaskName;
@property (weak, nonatomic) IBOutlet UITextView *txvMainTaskDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgMainTaskImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSetImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscardImage;

@property (strong, nonatomic) UIPopoverController *imagePopOverController;

@end

@implementation NewMainTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupView];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnDiscardImagePressed:(id)sender {
#warning btnDiscardImage color not flat :D
	[UIView animateWithDuration:0.5 animations:^{
		self.imgMainTaskImage.alpha = 0.0;
	} completion:^(BOOL finished) {
		self.imgMainTaskImage.image = nil;
		self.btnSetImage.hidden = NO;
		self.btnDiscardImage.hidden = YES;
		self.imgMainTaskImage.alpha = 1.0;
	}];
}

- (IBAction)btnAddImagePressed:(UIButton *)sender {
#warning Check Why Real Size and Position Don't match coords CGRect
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	[picker setMediaTypes:@[(id)kUTTypeImage]];
	[picker setDelegate:self];
	CGRect coords = CGRectMake(CGRectGetWidth(self.view.bounds) / 2,
							   0,
							   CGRectGetWidth(self.view.bounds) / 2,
							   CGRectGetHeight(self.view.bounds));
	self.imagePopOverController = [[UIPopoverController alloc] initWithContentViewController:picker];
	self.imagePopOverController.delegate = self;
	[self.imagePopOverController presentPopoverFromRect:coords
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
	self.imagePopOverController.popoverContentSize = CGSizeMake(coords.size.width,
																coords.size.height);
	
	
	
}

- (IBAction)btnCancelPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDonePressed:(id)sender {
	MainTask *mainTask = [MainTask insertInManagedObjectContext:self.moc];
	mainTask.mainTaskCreationDate = [NSDate date];
	mainTask.mainTaskDescription = [self.txvMainTaskDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	mainTask.mainTaskImageURL = nil;
	mainTask.mainTaskIsVisibleValue = YES;
	mainTask.mainTaskName = [self.txtMainTaskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	mainTask.mainTaskTotalCost = 0;
	mainTask.mainTaskTotalTimeValue = 0;
	
	NSError *error;
	
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error:\n%@", error.localizedDescription);
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatTurquoiseColor];
	self.txtMainTaskName.backgroundColor = [UIColor flatGreenSeaColor];
	self.txvMainTaskDescription.backgroundColor = [UIColor flatGreenSeaColor];
	self.imgMainTaskImage.backgroundColor = [UIColor flatGreenSeaColor];
	self.btnDone.backgroundColor = [UIColor flatBelizeHoleColor];
	self.btnCancel.backgroundColor = [UIColor flatAlizarinColor];
	self.txvMainTaskDescription.backgroundColor = [UIColor flatCloudsColor];
	
	[[self.txtMainTaskName.rac_textSignal
	  map:^id(NSString *text) {
		  return [NSNumber numberWithBool:[self isValidName:text]];
	  }]
      subscribeNext:^(NSNumber *enable) {
		  self.btnDone.enabled = [enable boolValue];
		  [UIView animateWithDuration:0.5
						   animations:^{
							   self.btnDone.alpha = [enable boolValue] ? 1.0 : 0.3;
							   self.txtMainTaskName.backgroundColor =
							   [enable boolValue] ? [UIColor flatCloudsColor]: [UIColor flatSunFlowerColor];
						   }];
		  
	  }];
}

-(BOOL) isValidName:(NSString *)name {
	name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return name.length > 0 && ![MainTask existsMainTaskWithName:name
													 inContext:self.moc];
}

//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier{
//	
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	self.imgMainTaskImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
	self.btnSetImage.hidden = YES;
	self.btnDiscardImage.hidden = NO;
}

@end
