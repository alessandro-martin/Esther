#import "MainTaskTableViewCell.h"

@interface MainTaskTableViewCell ()

@end

@implementation MainTaskTableViewCell

- (void)awakeFromNib {
    // Initialization code
	self.mainTaskImage.layer.borderWidth = 1;
	self.mainTaskImage.layer.borderColor = [UIColor whiteColor].CGColor;
	self.mainTaskImage.layer.cornerRadius = CGRectGetWidth(self.mainTaskImage.layer.frame) / 2;
	self.mainTaskImage.layer.masksToBounds = YES;
	self.layer.borderWidth = 1;
	self.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
