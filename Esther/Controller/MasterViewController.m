#import "MasterViewController.h"
#import "MainTaskViewController.h"
#import "MainTask.h"
#import "NewMainTaskViewController.h"
#import <UIColor+FlatColors.h>

@import QuartzCore;

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@end

@implementation MasterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor flatCloudsColor];
	self.defaultCellHeight = CGRectGetHeight(self.view.frame) /  6.0;
	self.fetchRequest = [MainTask allMainTasksFetchRequestInContext:self.moc];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
	    MainTaskViewController *controller = (MainTaskViewController *)[segue destinationViewController] ;
	    [controller setMainTask:mainTask];
		[controller setMoc:self.moc];
	}
	
	if ([[segue identifier] isEqualToString:@"newMainTask"]){
		NewMainTaskViewController *controller = (NewMainTaskViewController *)[segue destinationViewController];
		[controller setMoc:self.moc];
	}
}

#pragma mark - Utility Methods

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = mainTask.mainTaskName;
	NSData *pngData = [NSData dataWithContentsOfFile:mainTask.mainTaskImageURL];
	cell.imageView.image = [UIImage imageWithData:pngData];
	cell.backgroundColor = [UIColor clearColor];
}

@end