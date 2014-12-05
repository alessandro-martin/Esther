#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NewSubTaskViewController.h"
#import "SubTask.h"

static NSString  * 	const TEXTVIEW_PLACEHOLDER = @"Enter a detailed description here:";

@interface NewSubTaskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtSubTaskName;
@property (weak, nonatomic) IBOutlet UITextView *txvSubTaskDescription;
@property (weak, nonatomic) IBOutlet AMTTimePicker *pkrTimePickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtEstimatedCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMainTaskName;

@property (nonatomic, strong) NSString *currencySymbolFromLocale;
@property (nonatomic) NSTimeInterval timeFromPicker;

@end

@implementation NewSubTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)currencySymbolFromLocale {
	if (!_currencySymbolFromLocale) {
		NSLocale *theLocale = [NSLocale currentLocale];
		_currencySymbolFromLocale = [theLocale objectForKey:NSLocaleCurrencySymbol];
	}
	
	return _currencySymbolFromLocale;
}

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

- (IBAction)btnCancelPressed:(id)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnDonePressed:(id)sender {
	SubTask *subTask = [SubTask insertInManagedObjectContext:self.moc];
	subTask.subTaskName =
	[self.txtSubTaskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	subTask.subTaskDescription =
	[self.txvSubTaskDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	subTask.subTaskFinancialCost = [self costValueFromTextField];
	subTask.subTaskTimeNeededValue = self.timeFromPicker;
	subTask.subTaskColor = self.subTaskColor;
	// Placeholder values for Lat and Long
	subTask.subTaskLatitudeValue = 0.0f;
	subTask.subTaskLongitudeValue = 0.0f;
	subTask.subTaskIsCompletedValue = NO;
	subTask.subTaskIsVisibleValue = YES;
	subTask.subTaskScreenPositionXValue = [self.indexPath indexAtPosition:1];
	subTask.subTaskScreenPositionYValue = [self.indexPath indexAtPosition:0];
	subTask.mainTask = self.mainTask;
	
	NSError *error;
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error: \n%@", error.localizedDescription);
		abort();
	}
	
	[self dismissViewControllerAnimated:YES completion:^{
		if ([self.delegate respondsToSelector:@selector(updateMainTask)]) {
			[self.delegate updateMainTask];
		}
	}];
	
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatTurquoiseColor];
	self.txtEstimatedCost.placeholder = self.currencySymbolFromLocale;
	self.txtSubTaskName.backgroundColor = [UIColor flatGreenSeaColor];
	self.btnDone.backgroundColor = [UIColor flatBelizeHoleColor];
	self.btnCancel.backgroundColor = [UIColor flatAlizarinColor];
	self.txvSubTaskDescription.backgroundColor = [UIColor flatCloudsColor];
	self.txvSubTaskDescription.delegate = self;
	self.txvSubTaskDescription.text = TEXTVIEW_PLACEHOLDER;
	self.txvSubTaskDescription.textColor = [UIColor lightGrayColor];
	self.pkrTimePickerView.backgroundColor = [UIColor flatCloudsColor];
	self.lblTime.backgroundColor = [UIColor flatCloudsColor];
	self.lblMainTaskName.text =
	[NSString stringWithFormat:@"Main Task: %@", self.mainTask.mainTaskName];
	self.lblMainTaskName.backgroundColor = self.subTaskColor;
	
	[[self.txtSubTaskName.rac_textSignal
	  map:^id(NSString *text) {
		  return [NSNumber numberWithBool:[self isValidName:text]];
	  }]
	 subscribeNext:^(NSNumber *enable) {
		 self.btnDone.enabled = [enable boolValue];
		 [UIView animateWithDuration:0.5
						  animations:^{
							  self.btnDone.alpha = [enable boolValue] ? 1.0 : 0.3;
							  self.txtSubTaskName.backgroundColor =
							  [enable boolValue] ? [UIColor flatCloudsColor]: [UIColor flatSunFlowerColor];
						  }];
		 
	 }];
}

- (BOOL) isValidName:(NSString *)name {
	name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return name.length > 0;
}

- (NSDecimalNumber *)costValueFromTextField {
	NSScanner *costScanner = [NSScanner scannerWithString:self.txtEstimatedCost.text];
	NSDecimal costValue;
	NSDecimalNumber *cost;
	if ([costScanner scanDecimal:&costValue]) {
		cost = [NSDecimalNumber decimalNumberWithDecimal:costValue];
	} else {
		cost = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	}
	
	return cost;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark AMTTimePickerDelegate

- (void)amtTimePicker:(AMTTimePicker *)picker
		didSelectTime:(NSTimeInterval)timeInterval {
	self.timeFromPicker = timeInterval;
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
