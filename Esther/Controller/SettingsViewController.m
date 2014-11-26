#import "SettingsViewController.h"
#import <UIColor+FlatColors.h>

static NSString * const MAX_MAIN_TASKS_KEY				= @"MaxMainTasks";
static NSString * const MAX_SUB_TASKS_KEY				= @"MaxSubTasksForMainTask";


@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *maximumMainTasksLabel;
@property (weak, nonatomic) IBOutlet UILabel *maximumSubTasksLabel;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	//self.view.backgroundColor = [UIColor flatMidnightBlueColor];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgoundSettingsPlain.png"]];
	[self displayUserDefaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void) displayUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mainTasks = [defaults objectForKey:MAX_MAIN_TASKS_KEY];
	NSNumber *subTasks = [defaults objectForKey:MAX_SUB_TASKS_KEY];
	self.maximumMainTasksLabel.text = [NSString stringWithFormat:@"Current Allowed Main Tasks:%@", mainTasks];
	self.maximumSubTasksLabel.text = [NSString stringWithFormat:@"Current Allowed Sub Tasks:%@", subTasks];
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
