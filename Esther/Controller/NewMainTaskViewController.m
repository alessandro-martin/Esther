@import MobileCoreServices;

#import <UIColor+FlatColors.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NewMainTaskViewController.h"
#import "MainTask.h"

static NSString * const TEXTVIEW_PLACEHOLDER = @"Enter a detailed description here:";

@interface NewMainTaskViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtMainTaskName;
@property (weak, nonatomic) IBOutlet UITextView *txvMainTaskDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imgMainTaskImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnSetImage;
@property (weak, nonatomic) IBOutlet UIButton *btnDiscardImage;

@property (strong, nonatomic) UIPopoverController *imagePopOverController;
@property (nonatomic, strong) UIImage *mainTaskImage;

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
	self.btnSetImage.hidden = NO;
	self.btnSetImage.alpha = 0.0;
	[UIView animateWithDuration:0.7 animations:^{
		self.imgMainTaskImage.alpha = 0.0;
		self.btnDiscardImage.alpha = 0.0;
		self.btnSetImage.alpha = 1.0;
	} completion:^(BOOL finished) {
		self.imgMainTaskImage.image = nil;
		self.mainTaskImage = nil;
		self.btnDiscardImage.hidden = YES;
		self.btnDiscardImage.alpha = 1.0;
		[UIView animateWithDuration:0.3
						 animations:^{
							 self.imgMainTaskImage.alpha = 1.0;
						 } completion:nil
		 ];
	}];
}

- (IBAction)btnAddImagePressed:(UIButton *)sender {
	[self dismissKeyboard];
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	[picker setMediaTypes:@[(id)kUTTypeImage]];
	[picker setDelegate:self];
	CGRect coords = CGRectMake(CGRectGetWidth(self.view.bounds) / 2,
							   0,
							   CGRectGetWidth(self.view.bounds) / 2,
							   CGRectGetHeight(self.view.bounds));
#warning iPAD ONLY!!!
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
	mainTask.mainTaskIsVisibleValue = YES;
	mainTask.mainTaskName = [self.txtMainTaskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	NSString *imageFileName = [self imageUrlForMainTaskName:mainTask.mainTaskName];
	mainTask.mainTaskImageURL = imageFileName;
	[self saveImage:imageFileName];
	mainTask.mainTaskTotalCost = 0;
	mainTask.mainTaskTotalTimeValue = 0;
	
	NSError *error;
	
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error:\n%@", error.localizedDescription);
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveImage:(NSString *)filePath {
	NSData *pngData = UIImagePNGRepresentation(self.mainTaskImage);
	[pngData writeToFile:filePath atomically:YES];
}

- (NSString *)imageUrlForMainTaskName:(NSString *)mainTaskName {
	NSCharacterSet * illegalFileNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"/\\?%*|\"<>"];
	NSString *sanitizedFileName =
	[[mainTaskName componentsSeparatedByCharactersInSet:illegalFileNameCharacters] componentsJoinedByString:@""];
	NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [[documentsPath stringByAppendingPathComponent:sanitizedFileName] stringByAppendingString:@".png"];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatTurquoiseColor];
	self.txtMainTaskName.backgroundColor = [UIColor flatGreenSeaColor];
	self.imgMainTaskImage.backgroundColor = [UIColor flatGreenSeaColor];
	self.btnDone.backgroundColor = [UIColor flatBelizeHoleColor];
	self.btnCancel.backgroundColor = [UIColor flatAlizarinColor];
	self.txvMainTaskDescription.backgroundColor = [UIColor flatCloudsColor];
	self.txvMainTaskDescription.delegate = self;
	self.txvMainTaskDescription.text = TEXTVIEW_PLACEHOLDER;
	self.txvMainTaskDescription.textColor = [UIColor lightGrayColor];
	self.btnDiscardImage.backgroundColor = [UIColor flatSunFlowerColor];
	
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissKeyboard];
}

- (void) dismissKeyboard {
	[[self.view subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *v = (UIView *)obj;
		if ([v isFirstResponder]) {
			[v resignFirstResponder];
			*stop = YES;
		}
	}];
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[self.imagePopOverController dismissPopoverAnimated:YES];
	self.imgMainTaskImage.alpha = 0.0;
    self.btnDiscardImage.hidden = NO;
	self.btnDiscardImage.alpha = 0.0;
	self.mainTaskImage = [info objectForKey:UIImagePickerControllerOriginalImage];
	self.imgMainTaskImage.image = self.mainTaskImage;
	[UIView animateWithDuration:0.7
					 animations:^{
						 self.imgMainTaskImage.alpha = 1.0;
						 self.btnSetImage.alpha = 0.0;
						 self.btnDiscardImage.alpha = 1.0;
					 } completion:^(BOOL finished) {
						 self.btnSetImage.hidden = YES;
					 }];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:TEXTVIEW_PLACEHOLDER]) {
		textView.text = @"";
		textView.textColor = [UIColor darkTextColor];
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView {
	if ([textView.text isEqualToString:@""]) {
		textView.text = TEXTVIEW_PLACEHOLDER;
		textView.textColor = [UIColor lightGrayColor];
	}
}

@end
