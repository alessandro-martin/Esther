#import "AMTTimePicker.h"

static NSInteger		const numberOfComponentsInPickerView = 3;
static NSUInteger	const defaultMaxNumberOfDays = 45;
static NSUInteger	const maxNumberOfHours = 23;
static NSUInteger	const maxNumberOfMinutes = 59;

@interface AMTTimePicker () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, readwrite) NSUInteger maxNumberOfDays;

@end

@implementation AMTTimePicker
@synthesize delegate;

- (void)awakeFromNib {	
	[self setUpWithMaxDays:defaultMaxNumberOfDays];
}

- (void) setUpWithMaxDays:(NSUInteger)days {
	self.maxNumberOfDays = days;
	[self selectRow:1 inComponent:0 animated:YES];
	[self selectRow:1 inComponent:1 animated:YES];
	[self selectRow:1 inComponent:2 animated:YES];
	super.delegate = self;
	super.dataSource = self;
}

- (instancetype)initWithMaxDays:(NSUInteger)days {
	if (self = [super init]) {
		[self setUpWithMaxDays:(days > 0) ? days : defaultMaxNumberOfDays];
	}
	
	return self;
}

- (instancetype)init {
	if (self = [super init]) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:frame])) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
	if ((self = [super initWithCoder:aDecoder])) {
		[self setUpWithMaxDays:defaultMaxNumberOfDays];
	}
	return self;
}

#pragma mark - Data and Utility

- (void) setTimeInterval:(NSTimeInterval)timeInterval {
	if (timeInterval <= [self maxPossibleTimeInterval]) {
		int seconds = (int) timeInterval;
		int minutes = seconds / 60;
		int hours = minutes / 60;
		minutes = minutes % 60;
		int days = hours / 24;
		hours = hours % 24;
		[self selectRow:days + 1 inComponent:0 animated:YES];
		[self selectRow:hours + 1 inComponent:1 animated:YES];
		[self selectRow:minutes + 1 inComponent:2 animated:YES];
		[self reloadAllComponents];
	}
}

- (NSTimeInterval)maxPossibleTimeInterval {
	return	(self.maxNumberOfDays * 24 * 60 * 60) +
			(maxNumberOfHours * 60 * 60) +
			(maxNumberOfMinutes * 60);
}

- (NSArray *)pickerData {
	if (!_pickerData) {
		NSMutableArray *temp = [NSMutableArray array];
		for (int i = 0; i < numberOfComponentsInPickerView; i++) {
			NSMutableArray *componentData = [NSMutableArray array];
			[temp addObject:componentData];
			NSUInteger size = 0;
			NSString *componentTitle;
			switch (i) {
				case 0:
					size = self.maxNumberOfDays;
					componentTitle = @"Days";
					break;
				case 1:
					size = maxNumberOfHours;
					componentTitle = @"Hours";
					break;
				case 2:
					size = maxNumberOfMinutes;
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

- (double) timeIntervalFromPicker {
	UILabel *daysView = (UILabel *)[self pickerView:self
										 viewForRow:[self selectedRowInComponent:0]
									   forComponent:0
										reusingView:nil];
	UILabel *hoursView = (UILabel *)[self pickerView:self
										  viewForRow:[self selectedRowInComponent:1]
										forComponent:1
										 reusingView:nil];
	UILabel *minutesView = (UILabel *)[self pickerView:self
											viewForRow:[self selectedRowInComponent:2]
										  forComponent:2
										   reusingView:nil];
	int days		= [[[daysView attributedText] string] intValue];
	int hours	= [[[hoursView attributedText] string] intValue];
	int minutes = [[[minutesView attributedText] string] intValue];
	int timeInSeconds = (days * 24 * 60 * 60) + (hours * 60 * 60) + (minutes * 60);
	
	return timeInSeconds;
}

#pragma mark - UIPickerViewDataSource Methods

- (NSInteger)numberOfComponentsInPickerView:(__unused UIPickerView *)pickerView {
	return numberOfComponentsInPickerView;
}

- (NSInteger)pickerView:(__unused UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
	return ((NSArray *)self.pickerData[component]).count;
}

#pragma mark - UIPickerViewDelegate Methods

//-(NSString *)pickerView:(UIPickerView *)pickerView
//			titleForRow:(NSInteger)row
//		   forComponent:(NSInteger)component{
//	return [NSString stringWithFormat:@"%@", self.pickerData[component][row]];
//}

- (UIView *)pickerView:(UIPickerView *)pickerView
			viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component
		   reusingView:(UILabel *)recycledLabel {
	UILabel *label = recycledLabel;
	if (!label) {
		label = [[UILabel alloc] init];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
	}
	
	UIFont *font = [UIFont fontWithName:@"Helvetica"
								   size:14.0];
	NSDictionary *attributedStringDictionary = @{
												 NSFontAttributeName : font
												 };
	NSAttributedString *attrString =
	[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.pickerData[component][row]]
									attributes:attributedStringDictionary];

	label.attributedText = attrString;
	
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView
	  didSelectRow:(NSInteger)row
	   inComponent:(NSInteger)component {
	if (row == 0) {
		[self selectRow:1
			inComponent:component
			   animated:YES];
	} else {
		[self.delegate amtTimePicker:self
					   didSelectTime:[self timeIntervalFromPicker]];
	}
}

@end
