#import "MainTaskViewController.h"
#import "Cell.h"
#import <UIColor+FlatColors.h>
#import "SubTask.h"
#import "LSCollectionViewHelper.h"

@interface MainTaskViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic) NSUInteger sectionsCount;
@property (nonatomic, strong) NSMutableSet *subTasks;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end

@implementation MainTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupView];
	[self setupSections];
}

+ (NSArray *)subTaskColors {
	return @[
			 [UIColor flatTurquoiseColor],
			 [UIColor flatPeterRiverColor],
			 [UIColor flatAmethystColor],
			 [UIColor flatWetAsphaltColor],
			 [UIColor flatSunFlowerColor],
			 [UIColor flatOrangeColor],
			 [UIColor flatEmeraldColor],
			 [UIColor flatBelizeHoleColor],
			 [UIColor flatWisteriaColor],
			 [UIColor flatAlizarinColor]
			 ];
}

- (IBAction)mainViewDoubleTapped:(id)sender {
	self.indexPath =[NSIndexPath indexPathForRow:0
									   inSection:self.sectionsCount];
	[self performSegueWithIdentifier:@"newSubTask" sender:self];
}

- (IBAction)mainViewTapped:(UITapGestureRecognizer *)sender {
	self.indexPath =
	[self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
	if (!self.indexPath) {
		LSCollectionViewHelper *helper = [self.collectionView getHelper];
		self.indexPath = [helper indexPathForItemClosestToPoint:[sender locationInView:self.collectionView]];
		[self addNewSubTask];
	} else {
		NSLog(@"Here I should Edit the Subtask at %@", self.indexPath);
	}
}

- (void) addNewSubTask {
	self.indexPath = [NSIndexPath indexPathForRow:((NSArray *)self.sections[[self.indexPath indexAtPosition:0]]).count
										inSection:[self.indexPath indexAtPosition:0]];
	[self performSegueWithIdentifier:@"newSubTask" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue
				 sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"newSubTask"]) {
		NewSubTaskViewController *controller = (NewSubTaskViewController *)[segue destinationViewController];
		
		UIColor *subTaskColor = [MainTaskViewController subTaskColors][[self.indexPath indexAtPosition:0]];
		controller.subTaskColor = subTaskColor;
		controller.moc = self.moc;
		controller.mainTask = self.mainTask;
		controller.indexPath = self.indexPath;
		controller.delegate = self;
	}
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatSilverColor];
	self.title = self.mainTask.mainTaskName;
	[self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
//	self.collectionView.dataSource = self;
//	self.collectionView.delegate = self;
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
	_subTasks = [[self.mainTask subTasks] mutableCopy];
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

- (CGSize)collectionView:(UICollectionView *)collectionView
				  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
#warning Cell Size Could Depend on Time, Cost, Etc...
	CGFloat cellSide = CGRectGetWidth(self.view.frame) / 8;
	return CGSizeMake(cellSide, cellSide);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
	 numberOfItemsInSection:(NSInteger)section {
    return [[self.sections objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
				  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
																  forIndexPath:indexPath];
    NSMutableArray *data = [self.sections objectAtIndex:indexPath.section];
	SubTask *subTask = (SubTask *)[data objectAtIndex:indexPath.item];
	cell.label.text = subTask.subTaskName;
	cell.backgroundColor = subTask.subTaskColor;
    return cell;
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row >= [self.sections[indexPath.section] count]) {
		return NO;
	}

    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
		   toIndexPath:(NSIndexPath *)toIndexPath {
// Prevent item from being moved to index 0
//    if (toIndexPath.item == 0) {
//        return NO;
//    }
    return YES;
}

- (void)collectionView:(LSCollectionViewHelper *)collectionView
   moveItemAtIndexPath:(NSIndexPath *)fromIndexPath
		   toIndexPath:(NSIndexPath *)toIndexPath {
	// From section and to section, might just be the same, of course
    NSMutableArray *data1 = [self.sections objectAtIndex:fromIndexPath.section];
    NSMutableArray *data2 = [self.sections objectAtIndex:toIndexPath.section];
	
	SubTask *movingTask = [data1 objectAtIndex:fromIndexPath.item];
	
    [data1 removeObjectAtIndex:fromIndexPath.item];
    [data2 insertObject:movingTask atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView
didMoveItemAtIndexPath:(NSIndexPath *)fromIndexPath
		   toIndexPath:(NSIndexPath *)toIndexPath {
	NSUInteger fromIndex = fromIndexPath.section;
	NSUInteger toIndex = toIndexPath.section;
	NSMutableArray *data1 = [self.sections objectAtIndex:fromIndex];
	NSMutableArray *data2 = [self.sections objectAtIndex:toIndex];
	BOOL isFromSectionEmpty = NO;
	
	if (data1.count == 0) {
		isFromSectionEmpty = YES;
	} else {
		[self updateStorageFromData:data1 atSection:fromIndex];
	}
	
	// Iterate through destination only if it's not the same as origin
	if (fromIndex != toIndex) {
		if (isFromSectionEmpty) {
			NSUInteger didPassEmptySection = 0;
			for (int i = 0; i < self.sections.count; i++) {
				if (i == fromIndex) {
					didPassEmptySection = 1;
					continue;
				}
				NSMutableArray *data = [self.sections objectAtIndex:i];
				[self updateStorageFromData:data atSection:i - didPassEmptySection];
			}
			[self.sections removeObjectAtIndex:fromIndex];
		} else {
			[self updateStorageFromData:data2 atSection:toIndex];
		}
	}
	
	[self updateMainTask];
}

- (void) updateStorageFromData:(NSArray *)data
					 atSection:(NSUInteger)section {
	[data enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		SubTask *s = (SubTask *)obj;
		s.subTaskColor = [MainTaskViewController subTaskColors][section];
		s.subTaskScreenPositionXValue = idx;
		s.subTaskScreenPositionYValue = section;
		
		NSError *error;
		if ([self.moc hasChanges] && ![self.moc save:&error]) {
			NSLog(@"Fatal Error: \n%@", error.localizedDescription);
			abort();
		}
	}];
}

#pragma mark - NewSubTaskViewController Delegate Method

- (void) updateMainTask {
	[self.collectionView.collectionViewLayout invalidateLayout]; // YESSSSSSSSS!!!!!!!!!!!!!!!!!!!!!!
	[self setupSections];
	[self.collectionView reloadData];
}

@end
