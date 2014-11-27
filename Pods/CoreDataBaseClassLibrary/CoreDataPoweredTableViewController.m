#import "CoreDataPoweredTableViewController.h"
#import "CoreDataPoweredFetchedResultsControllerHelper.h"

@interface CoreDataPoweredTableViewController ()

@property (nonatomic, strong) CoreDataPoweredFetchedResultsControllerHelper *helper;

@end

@implementation CoreDataPoweredTableViewController

@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.helper =
	[[CoreDataPoweredFetchedResultsControllerHelper alloc]
		 initWithTableView:self.tableView
	 andBlockToUpdateCells:^(NSIndexPath *indexPath) {
		 [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath]
				 atIndexPath:indexPath];
		 }
	 ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
	NSLog(@"Low memory!");
}

#pragma mark - NSFetchedResultController
- (NSFetchedResultsController *)fetchedResultsController {
	if (_fetchedResultsController) {
		return _fetchedResultsController;
	}
	
	NSAssert(self.fetchRequest != nil, @"I'm gonna need a fetch request!");
	NSAssert(self.moc != nil, @"Gimme a blody context!");
	[NSFetchedResultsController deleteCacheWithName:@"Master"];
	
	_fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest
																	managedObjectContext:self.moc
																	  sectionNameKeyPath:nil
																			   cacheName:@"Master"];
	_fetchedResultsController.delegate = self.helper;
	
	NSError *error;
	if (![_fetchedResultsController performFetch:&error]) {
		NSLog(@"%@", error.localizedDescription);
		abort();
	}
	
	return _fetchedResultsController;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
	id<NSFetchedResultsSectionInfo> info = [self.fetchedResultsController sections][section];
	return [info numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	[self configureCell:cell atIndexPath:indexPath];
	
	return cell;
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
#warning SHOULD ALSO DELETE IMAGE FROM DOCUMENTS SANDBOX
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		self.moc = [self.fetchedResultsController managedObjectContext];
		[self.moc deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if ([self.moc hasChanges] && ![self.moc save:&error]) {
			NSLog(@"Fatal Error: \n%@", error.localizedDescription);
			abort();
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSAssert(self.defaultCellHeight != 0.0, @"Cell Height is 0!!!");
	return self.defaultCellHeight;
}

- (void) configureCell:(UITableViewCell *)cell
		   atIndexPath:(NSIndexPath *)indexPath {
}
@end
