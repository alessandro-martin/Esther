#import <UIColor+FlatColors.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "NewSubTaskViewController.h"
#import "SubTask.h"
#import "AMTTimePickerView.h"

static NSInteger const NUMBER_OF_COMPONENTS_IN_PICKER_VIEW = 3;
static NSUInteger const MAXIMUM_NUMBER_OF_DAYS = 45; // ONE MONTH AND A HALF
static NSUInteger const MAXIMUM_NUMBER_OF_HOURS = 23;
static NSUInteger const MAXIMUM_NUMBER_OF_MINUTES = 59;

@interface NewSubTaskViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UITextField *txtSubTaskName;
@property (weak, nonatomic) IBOutlet UITextView *txvSubTaskDescription;
@property (weak, nonatomic) IBOutlet AMTTimePickerView *pkrTimePickerView;
@property (weak, nonatomic) IBOutlet UITextField *txtEstimatedCost;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

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
//	MainTask *mainTask = [MainTask insertInManagedObjectContext:self.moc];
//	mainTask.mainTaskCreationDate = [NSDate date];
//	mainTask.mainTaskDescription = [self.txvMainTaskDescription.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//	mainTask.mainTaskImageURL = nil;
//	mainTask.mainTaskIsVisibleValue = YES;
//	mainTask.mainTaskName = [self.txtMainTaskName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//	mainTask.mainTaskTotalCost = 0;
//	mainTask.mainTaskTotalTimeValue = 0;
	
	NSError *error;
	
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error:\n%@", error.localizedDescription);
	}
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatTurquoiseColor];
	self.txtSubTaskName.backgroundColor = [UIColor flatGreenSeaColor];
	self.btnDone.backgroundColor = [UIColor flatBelizeHoleColor];
	self.btnCancel.backgroundColor = [UIColor flatAlizarinColor];
	self.txvSubTaskDescription.backgroundColor = [UIColor flatCloudsColor];
	self.pkrTimePickerView.backgroundColor = [UIColor flatCloudsColor];
	self.lblTime.backgroundColor = [UIColor flatCloudsColor];
//	self.pkrTimePickerView.transform = CGAffineTransformMakeScale(1.0, 0.5);
	
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

-(BOOL) isValidName:(NSString *)name {
	name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	return name.length > 0;// && ![SubTask existsSubTaskWithName:name
							//						inContext:self.moc];
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
	// Selection Logic
	NSLog(@"%lu %lu", [self. pkrTimePickerView selectedRowInComponent:component], component);
}

//-(CGFloat) pickerView:(UIPickerView *)pickerView
//rowHeightForComponent:(NSInteger)component {
//	return 40.0;
//}
@end
