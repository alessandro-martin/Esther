#import "MainTaskViewController.h"
#import "Cell.h"
#import <UIColor+FlatColors.h>
#import "SubTask.h"

//#define SECTION_COUNT 3
//#define ITEM_COUNT 5

@interface MainTaskViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic) NSUInteger sectionsCount;
@property (nonatomic, strong) NSMutableSet *subTasks;

@end

@implementation MainTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupView];
	[self setupSections];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
	CGFloat cellSide = CGRectGetWidth(self.view.frame) / 8;
	return CGSizeMake(cellSide, cellSide);
}

- (IBAction)mainViewTapped:(UITapGestureRecognizer *)sender {
	NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
	NSLog(@"%@", indexPath);
	if (!indexPath) {
		[self addNewSubTask:indexPath];
	} else {
		NSLog(@"Here I should Edit the Subtask at %@", indexPath);
	}
}

#warning  GROSS IMPLEMENTATION ADDS SUBTASK DIRECTLY!!!
- (void) addNewSubTask:(NSIndexPath *)indexPath {
	SubTask *subTask = [SubTask insertInManagedObjectContext:self.moc];
	[self.subTasks addObject:subTask];
	subTask.subTaskName = [NSString stringWithFormat:@"%lu", self.subTasks.count];
	subTask.subTaskIsCompletedValue = NO;
	subTask.subTaskIsVisibleValue = YES;
	subTask.subTaskColor = [UIColor flatCarrotColor];
	if (!indexPath) {
		indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	}
	subTask.subTaskScreenPositionXValue =
	((NSMutableArray *)self.sections[indexPath.section]).count;
	subTask.subTaskScreenPositionYValue = indexPath.section;
	subTask.mainTask = self.mainTask;
	NSError *error;
	if ([self.moc hasChanges] && ![self.moc save:&error]) {
		NSLog(@"Fatal Error: \n%@", error.localizedDescription);
		abort();
	}
	[self setupSections];
	[self.collectionView reloadData];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatSilverColor];
	self.title = self.mainTask.mainTaskName;
}

- (void) setupSections {
	int currentNumberOfSections = (int)self.sectionsCount;
	self.sections = nil;
	for(int i = 0; i < currentNumberOfSections; i++) {
		NSMutableArray *data = [NSMutableArray array];
		[self.sections addObject:data];
	}
	[self.subTasks enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		SubTask *s = (SubTask *)obj;
		int y = s.subTaskScreenPositionYValue;
		[self.sections[y] addObject:s];
		[(NSMutableArray *)self.sections[y] sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			return ((SubTask *)obj1).subTaskScreenPositionXValue >
				   ((SubTask *)obj2).subTaskScreenPositionXValue;
		}];
	}];
}

-(NSMutableArray *)sections {
	if (!_sections) {
		_sections = [NSMutableArray array];
	}
	
	return _sections;
}

-(NSMutableSet *)subTasks {
	if (!_subTasks) {
		_subTasks = [[self.mainTask subTasks] mutableCopy];
	}
	
	return _subTasks;
}

-(NSUInteger)sectionsCount {
	_sectionsCount = 0;
	[self.subTasks enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		SubTask *subTask = (SubTask *)obj;
		int y = [subTask.subTaskScreenPositionY intValue];
		_sectionsCount = (y > _sectionsCount) ? y : _sectionsCount;
	}];
	
	_sectionsCount++;
	return _sectionsCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section
{
    return [[self.sections objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
																  forIndexPath:indexPath];
    NSMutableArray *data = [self.sections objectAtIndex:indexPath.section];
	SubTask *subTask = (SubTask *)[data objectAtIndex:indexPath.item];
	cell.label.text = subTask.subTaskName;
	cell.backgroundColor = subTask.subTaskColor;
    return cell;
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row >= [self.sections[indexPath.section] count]) {
		return NO;
	}

    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
		   toIndexPath:(NSIndexPath *)toIndexPath
{
// Prevent item from being moved to index 0
//    if (toIndexPath.item == 0) {
//        return NO;
//    }
    return YES;
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)fromIndexPath
		   toIndexPath:(NSIndexPath *)toIndexPath
{
    NSMutableArray *data1 = [self.sections objectAtIndex:fromIndexPath.section];
    NSMutableArray *data2 = [self.sections objectAtIndex:toIndexPath.section];
	
	NSString *index = [data1 objectAtIndex:fromIndexPath.item];
	
    [data1 removeObjectAtIndex:fromIndexPath.item];
    [data2 insertObject:index atIndex:toIndexPath.item];
}

@end
