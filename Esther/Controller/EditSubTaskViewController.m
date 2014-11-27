#import "EditSubTaskViewController.h"

#import <UIColor+FlatColors/UIColor+FlatColors.h>
#import "AMTTimePickerView.h"

static NSInteger		const NUMBER_OF_COMPONENTS_IN_PICKER_VIEW = 3;
static NSUInteger	const MAXIMUM_NUMBER_OF_DAYS = 45; // ONE MONTH AND A HALF
static NSUInteger	const MAXIMUM_NUMBER_OF_HOURS = 23;
static NSUInteger	const MAXIMUM_NUMBER_OF_MINUTES = 59;
static NSString  * 	const TEXTVIEW_PLACEHOLDER = @"Enter Any Observations Here:";

@interface EditSubTaskViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet AMTTimePickerView *pkrTimePickerView;
@property (weak, nonatomic) IBOutlet UILabel *lblEstimatedTime;
@property (weak, nonatomic) IBOutlet UILabel *lblEstimatedCost;
@property (weak, nonatomic) IBOutlet UILabel *lblActualTimeTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblActualCostTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtActualCost;
@property (weak, nonatomic) IBOutlet UITextView *txvComments;
@property (weak, nonatomic) IBOutlet UIButton *btnCompleted;
@property (weak, nonatomic) IBOutlet UIButton *btnNotYet;

@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, strong) NSString *currencySymbolFromLocale;

@end

@implementation EditSubTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setupView];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatPeterRiverColor];
	self.txvComments.delegate = self;
	self.txvComments.text = @"Enter Any Observations Here:";
	self.txvComments.textColor = [UIColor lightGrayColor];
	self.lblActualCostTitle.backgroundColor = [UIColor flatBelizeHoleColor];
	self.lblActualTimeTitle.backgroundColor = [UIColor flatBelizeHoleColor];
	self.lblEstimatedCost.backgroundColor = [UIColor flatBelizeHoleColor];
	self.lblEstimatedCost.text = [NSString stringWithFormat:@"Estimated Cost of Completion Was %@ %@", self.subTask.subTaskFinancialCost, [self currencySymbolFromLocale]];
	self.lblEstimatedTime.text = [NSString stringWithFormat:@"Estimated Time of Completion Was %@", [self daysHoursAndMinutesStringFromSeconds:self.subTask.subTaskTimeNeededValue]];
	self.lblEstimatedTime.backgroundColor = [UIColor flatBelizeHoleColor];
	self.pkrTimePickerView.backgroundColor = [UIColor flatBelizeHoleColor];
	self.btnCompleted.backgroundColor = [UIColor flatEmeraldColor];
	self.btnNotYet.backgroundColor = [UIColor flatAlizarinColor];
	self.txtActualCost.placeholder = self.currencySymbolFromLocale;
}

- (NSString *)daysHoursAndMinutesStringFromSeconds:(double) timeLapse {
	int seconds = (int) timeLapse;
	int minutes = seconds / 60;
	int hours = minutes / 60;
	minutes = minutes % 60;
	int days = hours / 24;
	hours = hours % 24;
	
	return [NSString stringWithFormat:@"%dd %dh %dm", days, hours, minutes];
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
	self.subTask.subTaskTimeNeededValue = [self timeIntervalFromPicker];
	self.subTask.subTaskIsCompletedValue = YES;
	
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

- (IBAction)btnNotYetPressed:(id)sender {
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

- (NSArray *)pickerData {
	if (!_pickerData) {
		NSMutableArray *temp = [NSMutableArray array];
		for (int i = 0; i < NUMBER_OF_COMPONENTS_IN_PICKER_VIEW; i++) {
			NSMutableArray *componentData = [NSMutableArray array];
			[temp addObject:componentData];
			NSUInteger size = 0;
			NSString *componentTitle;
			switch (i) {
				case 0:
					size = MAXIMUM_NUMBER_OF_DAYS;
					componentTitle = @"Days";
					break;
				case 1:
					size = MAXIMUM_NUMBER_OF_HOURS;
					componentTitle = @"Hours";
					break;
				case 2:
					size = MAXIMUM_NUMBER_OF_MINUTES;
					componentTitle = @"Minutes";
					break;
				default:
					break;
			}
			[componentData addObject:componentTitle];
			for (int j = 0; j <= size; j++) {
				[componentData addObject:@(j)];
			}
		}
		_pickerData = temp;
	}
	
	return _pickerData;
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

- (double) timeIntervalFromPicker {
	int days = [[self pickerView:self.pkrTimePickerView
					 titleForRow:[self.pkrTimePickerView selectedRowInComponent:0]
					forComponent:0] intValue];
	int hours = [[self pickerView:self.pkrTimePickerView
					  titleForRow:[self.pkrTimePickerView selectedRowInComponent:1]
					 forComponent:1] intValue];;
	int minutes = [[self pickerView:self.pkrTimePickerView
						titleForRow:[self.pkrTimePickerView selectedRowInComponent:2]
					   forComponent:2] intValue];
	int timeInSeconds = (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60);
	
	return timeInSeconds;
}

#pragma mark - UIPickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return NUMBER_OF_COMPONENTS_IN_PICKER_VIEW;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
	return ((NSArray *)self.pickerData[component]).count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView
			titleForRow:(NSInteger)row
		   forComponent:(NSInteger)component{
	return [NSString stringWithFormat:@"%@", self.pickerData[component][row]];
}

- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
	if (row == 0) {
		[self.pkrTimePickerView selectRow:1
							  inComponent:component
								 animated:YES];
	}
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
