@import UIKit;
#import <CoreDataPoweredTableViewController.h>

@class DetailViewController;

@interface MasterViewController : CoreDataPoweredTableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end