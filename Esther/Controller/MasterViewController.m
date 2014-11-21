#import "MasterViewController.h"
#import "DetailViewController.h"
#import "MainTask.h"
#import <UIColor+FlatColors.h>

@import QuartzCore;

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property NSMutableArray *objects;
@end

@implementation MasterViewController

- (void)awakeFromNib {
	[super awakeFromNib];
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
	    self.clearsSelectionOnViewWillAppear = NO;
	    self.preferredContentSize = CGSizeMake(320.0, 600.0);
	}
}

//- (void)viewWillAppear:(BOOL)animated {
//	CAGradientLayer *gradient = [CAGradientLayer layer];
//	gradient.frame = self.view.bounds;
//	gradient.colors = @[
//						(id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor,
//						(id)[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor
//						];
//	[self.view.layer insertSublayer:gradient atIndex:0];}
//
- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor flatCloudsColor];
	// Do any additional setup after loading the view, typically from a nib.
	//self.navigationItem.leftBarButtonItem = self.editButtonItem;

//	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//	self.navigationItem.rightBarButtonItem = addButton;
	self.defaultCellHeight = 120.0;
	self.fetchRequest = [MainTask allMainTasksFetchRequestInContext:self.moc];
	
	self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
	if (!self.objects) {
	    self.objects = [[NSMutableArray alloc] init];
	}
	[self.objects insertObject:[NSDate date] atIndex:0];
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"showDetail"]) {
	    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	    NSDate *object = self.objects[indexPath.row];
	    DetailViewController *controller = (DetailViewController *)[segue destinationViewController] ;
	    [controller setDetailItem:object];
	    controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	    controller.navigationItem.leftItemsSupplementBackButton = YES;
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

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	cell.textLabel.text = mainTask.mainTaskName;
}


@end