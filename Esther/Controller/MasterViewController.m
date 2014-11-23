#import "MasterViewController.h"
//#import "DetailViewController.h"
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

//- (void)insertNewObject:(id)sender {
//	NSLog(@"Do Something!!!");
//	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//}

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

//#pragma mark - Table View
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	return self.objects.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//	return cell;
//}
//
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//	// Return NO if you do not want the specified item to be editable.
//	return YES;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//	if (editingStyle == UITableViewCellEditingStyleDelete) {
//	    [self.objects removeObjectAtIndex:indexPath.row];
//	    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//	} else if (editingStyle == UITableViewCellEditingStyleInsert) {
//	    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//	}
//}

#pragma mark - Utility Methods

- (void)configureCell:(UITableViewCell *)cell
		  atIndexPath:(NSIndexPath *)indexPath {
	MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = mainTask.mainTaskName;
}


@end