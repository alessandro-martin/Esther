@import UIKit;
@import CoreData;

@interface CoreDataPoweredFetchedResultsControllerHelper : NSObject <NSFetchedResultsControllerDelegate>

// Designated initialiser
- (instancetype)initWithTableView:(UITableView *)tableView
			andBlockToUpdateCells:(void (^)(NSIndexPath *indexPath)) block;
- (instancetype) __unavailable init;

@end
