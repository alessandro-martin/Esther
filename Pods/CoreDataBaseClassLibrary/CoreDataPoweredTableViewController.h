@import UIKit;
@import CoreData;

@interface CoreDataPoweredTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *moc;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchRequest *fetchRequest;

@property (nonatomic) CGFloat defaultCellHeight;

@end
