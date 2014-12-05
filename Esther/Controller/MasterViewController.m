#import "MasterViewController.h"
#import "MainTaskViewController.h"
#import "MainTask.h"
#import "NewMainTaskViewController.h"
#import <UIColor+FlatColors.h>
#import "MainTaskTableViewCell.h"
#import "MainTaskTableViewCell.h"

@import QuartzCore;

static NSString * const MAX_MAIN_TASKS_KEY = @"MaxMainTasks";

@interface MasterViewController () <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSString *currencySymbolFromLocale;

@end

@implementation MasterViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor flatSilverColor];
	self.defaultCellHeight = CGRectGetHeight(self.view.frame) /  6.0;
	self.fetchRequest = [MainTask allMainTasksFetchRequestInContext:self.moc];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(contextChanged)
												 name:NSManagedObjectContextDidSaveNotification
											   object:nil];
}

- (void) contextChanged {
	[self.tableView reloadData];
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
	MainTaskTableViewCell *mainTaskCell = (MainTaskTableViewCell *)cell;
	MainTask *mainTask = [self.fetchedResultsController objectAtIndexPath:indexPath];
	
	mainTaskCell.mainTaskNameLabel.text = mainTask.mainTaskName;
	
	double longestTime = [self timeOfLongestChainOfEventsInMainTask:mainTask];
	NSString *longestTimeString = [self daysHoursAndMinutesStringFromSeconds:longestTime];
	mainTaskCell.mainTaskTimeLabel.text = [NSString stringWithFormat:@"%@", longestTimeString];
	mainTaskCell.mainTaskCostLabel.text = [NSString stringWithFormat:@"%@ %@", [self totalCostForMainTask:mainTask],
										   [self currencySymbolFromLocale]];
	NSData *pngData = [NSData dataWithContentsOfFile:mainTask.mainTaskImageURL];
	UIImage *img;
	if (!pngData) {
		img = [UIImage imageNamed:@"Logo_Keydi.png"];
	} else {
		img = [UIImage imageWithData:pngData];
	}
	mainTaskCell.mainTaskImage.image = img;
	mainTaskCell.backgroundColor = [UIColor whiteColor];
}

- (int) maxMainTasks {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mainTasks = [defaults objectForKey:MAX_MAIN_TASKS_KEY];
	return [mainTasks intValue];
}

- (NSDecimalNumber *)totalCostForMainTask:(MainTask *)mainTask {
	NSDecimalNumber *totalCost = [NSDecimalNumber zero];
	for (SubTask *subTask in mainTask.subTasks) {
		if (!subTask.subTaskIsCompletedValue) {
			totalCost = [totalCost decimalNumberByAdding:subTask.subTaskFinancialCost];
		}
	}
	
	return totalCost;
}

- (NSString *)currencySymbolFromLocale {
	if (!_currencySymbolFromLocale) {
		NSLocale *theLocale = [NSLocale currentLocale];
		_currencySymbolFromLocale = [theLocale objectForKey:NSLocaleCurrencySymbol];
	}
	
	return _currencySymbolFromLocale;
}

- (double) timeOfLongestChainOfEventsInMainTask:(MainTask *)mainTask {
	NSMutableDictionary *times = [@{} mutableCopy];
	for (SubTask *subTask in mainTask.subTasks) {
		if (subTask.subTaskIsCompletedValue) {
			continue;
		}
		NSNumber *section = subTask.subTaskScreenPositionY;
		NSNumber *subTaskTime = subTask.subTaskTimeNeeded;
		if ([times objectForKey:section] == nil) {
			times[section] = subTaskTime;
		} else {
			times[section] = @([times[section] doubleValue] + [subTaskTime doubleValue]);
		}
	}
	
	double longestChainTime = 0;
	for (NSNumber *time in times.allValues) {
		if ([time doubleValue] > longestChainTime) {
			longestChainTime = [time doubleValue];
		}
	}
	
	return longestChainTime;
}

- (NSString *)daysHoursAndMinutesStringFromSeconds:(double) timeLapse {
	int seconds = (int) timeLapse;
	int minutes = seconds / 60;
	int hours = minutes / 60;
	minutes = minutes % 60;
	int days = hours / 24;
	hours = hours % 24;
	
	return [NSString stringWithFormat:@"%@ %dh %dm", (days > 0) ?
			[NSString stringWithFormat:@"%dd", days ] :
			@"",
			hours, minutes];
}

@end