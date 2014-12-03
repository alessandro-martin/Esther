@import UIKit;
@class AMTTimePicker;

@protocol AMTTimePickerDelegate <UIPickerViewDelegate>
@required
- (void) amtTimePicker:(__unused AMTTimePicker *)picker
		 didSelectTime:(NSTimeInterval)timeInterval;

@end

@interface AMTTimePicker : UIPickerView

@property (nonatomic, weak) id<AMTTimePickerDelegate>delegate;

// Designated initializer
- (instancetype)initWithMaxDays:(NSUInteger)days;
- (void) setTimeInterval:(NSTimeInterval)timeInterval;

@end
