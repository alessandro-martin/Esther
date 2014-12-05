#import "EditSubTaskViewController.h"

#import <UIColor+FlatColors/UIColor+FlatColors.h>

static NSString  * 	const TEXTVIEW_PLACEHOLDER = @"Enter Any Observations Here:";

@interface EditSubTaskViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet AMTTimePicker *pkrTimePickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblActualTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblActualCostTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtActualCost;
@property (weak, nonatomic) IBOutlet UITextView *txvComments;
@property (weak, nonatomic) IBOutlet UIButton *btnCompleted;
@property (weak, nonatomic) IBOutlet UIButton *btnNotYet;

@property (nonatomic, strong) NSString *currencySymbolFromLocale;
@property (nonatomic) NSTimeInterval timeFromPicker;

@end

@implementation EditSubTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupView];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatAsbestosColor];
	self.lblActualCostTitle.backgroundColor = [UIColor flatCloudsColor];
	self.lblActualTimeTitle.backgroundColor = [UIColor flatCloudsColor];
	self.txvComments.delegate = self;
	self.txvComments.text = @"Enter Any Observations Here:";
	self.txvComments.textColor = [UIColor lightGrayColor];
	self.txtActualCost.text = [NSString stringWithFormat:@"%@ %@", self.subTask.subTaskFinancialCost, [self currencySymbolFromLocale]];
	self.pkrTimePickerView.backgroundColor = [UIColor flatCloudsColor];
	[self.pkrTimePickerView setTimeInterval:self.subTask.subTaskTimeNeededValue];
	self.btnCompleted.backgroundColor = [UIColor flatCloudsColor];
	self.btnNotYet.backgroundColor = [UIColor flatCloudsColor];
	self.txtActualCost.placeholder = self.currencySymbolFromLocale;
	[self.btnCompleted setTitleColor:[UIColor flatNephritisColor]
							forState:UIControlStateNormal];
	[self.btnNotYet setTitleColor:[UIColor flatAlizarinColor]
						 forState:UIControlStateNormal];
	[self drawBorders];
}

- (void) drawBorders {
	[self.view.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		UIView *v = (UIView *)obj;
		if ([v isKindOfClass:[UITextView class]] ||
			[v isKindOfClass:[UIButton class]] ||
			[v isKindOfClass:[UILabel class]] ||
			[v isKindOfClass:[UITextField class]]) {
			v.layer.borderWidth = 1.0;
			v.layer.borderColor = [UIColor blackColor].CGColor;
			v.layer.cornerRadius = 10;
			v.layer.masksToBounds = YES;
		}
	}];
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

- (IBAction)btnCompletedPressed:(id)sender {
	self.subTask.subTaskFinancialCost = [self costValueFromTextField];
	self.subTask.subTaskDescription = [self.txvComments.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	self.subTask.subTaskTimeNeededValue = self.timeFromPicker;
	self.subTask.subTaskIsCompletedValue = YES;
	
	NSError *error;
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error: \n%@", error.localizedDescription);
		abort();
	}
	
	[self dismissViewControllerAnimated:YES completion:^{
		[self dismissKeyboard];
		if ([self.delegate respondsToSelector:@selector(updateMainTask)]) {
			[self.delegate updateMainTask];
		}
	}];
}

- (IBAction)btnNotYetPressed:(id)sender {
	[self dismissKeyboard];
	[self dismissViewControllerAnimated:YES
							 completion:nil];

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

- (NSDecimalNumber *)costValueFromTextField {
	NSScanner *costScanner = [NSScanner scannerWithString:self.txtActualCost.text];
	NSDecimal costValue;
	NSDecimalNumber *cost;
	if ([costScanner scanDecimal:&costValue]) {
		cost = [NSDecimalNumber decimalNumberWithDecimal:costValue];
	} else {
		cost = [NSDecimalNumber decimalNumberWithString:@"0.0"];
	}
	
	return cost;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
