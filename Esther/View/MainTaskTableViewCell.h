@import UIKit;

@interface MainTaskTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mainTaskImage;
@property (weak, nonatomic) IBOutlet UILabel *mainTaskNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTaskTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mainTaskCostLabel;

@end
