#import "MasterViewController.h"
#import "MainTaskViewController.h"
#import "MainTask.h"
#import "NewMainTaskViewController.h"
#import <UIColor+FlatColors.h>

@import QuartzCore;

static NSString * const MAX_MAIN_TASKS_KEY = @"MaxMainTasks";

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

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier
								  sender:(id)sender {
	if ([identifier isEqualToString:@"newMainTask"]) {
		if (self.fetchedResultsController.fetchedObjects.count < [self maxMainTasks]) {
			return YES;
		} else {
			[self performSegueWithIdentifier:@"settingsSegue"
									  sender:self];
			return NO;
		}
	}
	
	return YES;
}

#pragma mark - Utility Methods

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];

	cell.textLabel.text = mainTask.mainTaskName;
	NSData *pngData = [NSData dataWithContentsOfFile:mainTask.mainTaskImageURL];
	UIImage *img;
	if (!pngData) {
		img = [UIImage imageNamed:@"Logo_Keydi.png"];
	} else {
		img = [UIImage imageWithData:pngData];
	}
	cell.imageView.image = img;
	cell.backgroundColor = [UIColor clearColor];
}

- (int) maxMainTasks {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mainTasks = [defaults objectForKey:MAX_MAIN_TASKS_KEY];
	return [mainTasks intValue];
}

@end