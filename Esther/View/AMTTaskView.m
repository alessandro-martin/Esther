#import "AMTTaskView.h"

@interface AMTTaskView ()

@property (nonatomic, getter=isInEditMode) BOOL inEditMode;

@end

@implementation AMTTaskView


- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		_inEditMode = YES;
	}
	
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
