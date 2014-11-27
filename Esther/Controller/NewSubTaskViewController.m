#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NewSubTaskViewController.h"
#import "SubTask.h"
#import "AMTTimePickerView.h"

static NSInteger const NUMBER_OF_COMPONENTS_IN_PICKER_VIEW = 3;
static NSUInteger const MAXIMUM_NUMBER_OF_DAYS = 45; // ONE MONTH AND A HALF
static NSUInteger const MAXIMUM_NUMBER_OF_HOURS = 23;
static NSUInteger const MAXIMUM_NUMBER_OF_MINUTES = 59;
static NSString * const TEXTVIEW_PLACEHOLDER = @"Enter a detailed description here:";

@interface NewSubTaskViewController () <UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtSubTaskName;
@property (weak, nonatomic) IBOutlet UITextView *txvSubTaskDescription;
@property (weak, nonatomic) IBOutlet AMTTimePickerView *pkrTimePickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtEstimatedCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMainTaskName;

@property (nonatomic, strong) NSArray *pickerData;

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
	subTask.subTaskTimeNeededValue = [self timeIntervalFromPicker];
	subTask.subTaskColor = self.subTaskColor;
#warning Placeholder values for Lat and Long
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
	self.lblMainTaskName.backgroundColor = [UIColor flatWisteriaColor];
	
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

@end
