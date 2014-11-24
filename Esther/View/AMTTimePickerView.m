#import "AMTTimePickerView.h"

@interface AMTTimePickerView ()

@end

@implementation AMTTimePickerView

- (void)awakeFromNib {
	[self selectRow:1 inComponent:0 animated:YES];
	[self selectRow:1 inComponent:1 animated:YES];
	[self selectRow:1 inComponent:2 animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
