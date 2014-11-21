@import UIKit;
#import <CoreDataPoweredTableViewController.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end