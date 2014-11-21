@import CoreGraphics;

#import "AMTGlobalTaskView.h"
#import <UIColor+FlatColors.h>

@implementation AMTGlobalTaskView

- (instancetype)initWithCoder:(NSCoder *)coder
{
	self = [super initWithCoder:coder];
	if (self) {
		NSLog(@"initwithCoder called");
		self.sections = 3;
		self.backgroundColor = [UIColor flatAmethystColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
#warning SECTIONS!!!!
	self.sections = 3;
	CGFloat rectWidth = CGRectGetWidth(self.frame);
	CGFloat rectHeight = CGRectGetHeight(self.frame) / self.sections;
	CGContextRef context = UIGraphicsGetCurrentContext();
	for (int i = 0; i < self.sections; i++) {
		UIColor *color = [UIColor colorWithHue: 170 / 255.0
#warning Saturation Algorithm could use some improvement
										saturation: 1.0 / (1 + i)
										brightness: 150 / 255.0
											 alpha: 1.0];
		CGRect section = CGRectMake(0.0, i * rectHeight, rectWidth, rectHeight);
		CGContextSetFillColorWithColor(context, color.CGColor);
		CGContextAddRect(context, section);
		CGContextFillPath(context);
	}
}

@end
