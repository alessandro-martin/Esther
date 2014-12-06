#import "MainTaskViewController.h"
#import "Cell.h"
#import <UIColor+FlatColors.h>
#import "SubTask.h"
#import "LSCollectionViewHelper.h"
#import "EditSubTaskViewController.h"

static NSString * const MAX_SUB_TASKS_KEY = @"MaxSubTasksForMainTask";

@interface MainTaskViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic) NSUInteger sectionsCount;
@property (nonatomic, strong) NSMutableSet *subTasks;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, strong) NSString *currencySymbolFromLocale;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, strong) UIImageView *rightBarButtonCustomView;
@property (weak, nonatomic) IBOutlet UIView *popoverAnchorView;

@end

@implementation MainTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self setupView];
	[self setupSections];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(imageSaved) name:@"com.alessandromartin.imageupdated"
											   object:nil];
}

+ (NSArray *)subTaskColors {
	return @[
			 [UIColor flatWisteriaColor],
			 [UIColor flatPumpkinColor],
			 [UIColor flatGreenSeaColor],
			 [UIColor flatBelizeHoleColor],
			 [UIColor flatSunFlowerColor],
			 [UIColor flatPomegranateColor],
			 [UIColor flatNephritisColor],
			 ];
}

- (NSString *)currencySymbolFromLocale {
	if (!_currencySymbolFromLocale) {
		NSLocale *theLocale = [NSLocale currentLocale];
		_currencySymbolFromLocale = [theLocale objectForKey:NSLocaleCurrencySymbol];
	}
	
	return _currencySymbolFromLocale;
}

- (IBAction)mainViewDoubleTapped:(id)sender {
	if (self.subTasks.count >= [self maxSubTasks]) {
		NSLog(@"No More SubTasks!!!");
		return;
	}
	
	if (self.sections.count <= 1 && ((NSArray *)self.sections[0]).count == 0) {
		NSLog(@"Can't add a section to an empty workspace");
		return;
	}
	
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
		SubTask *s = self.sections[self.indexPath.section][self.indexPath.row];
		if (!s.subTaskIsCompletedValue) {
			[self performSegueWithIdentifier:@"editSubTaskSegue"
									  sender:self];
		}
	}
}

- (void) addNewSubTask {
	if (self.subTasks.count >= [self maxSubTasks]) {
		NSLog(@"No More SubTasks!!!");
		return;
	}
	
	self.indexPath = [NSIndexPath indexPathForRow:((NSArray *)self.sections[[self.indexPath indexAtPosition:0]]).count
										inSection:[self.indexPath indexAtPosition:0]];
	[self performSegueWithIdentifier:@"newSubTask" sender:self];
}

- (void) setupView {
	self.view.backgroundColor = [UIColor flatSilverColor];
	self.title = self.mainTask.mainTaskName;
	[self setupRightBarButtonCustomView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithCustomView:self.rightBarButtonCustomView];
	[self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
	
	if (self.subTasks.count == 0) {
		CGFloat labelWidth = self.view.bounds.size.width * 0.6;
		CGFloat labelHeight = self.view.bounds.size.height * 0.6;
		CGFloat viewWidth = CGRectGetWidth(self.view.frame);
		CGFloat viewHeight = CGRectGetHeight(self.view.frame);
		self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth / 2) - labelWidth / 2,
																	  (viewHeight / 2) - labelHeight / 2,
																	  labelWidth,
																	  labelHeight)];
		self.warningLabel.text = @"Tap do add a subtask\nAfterwards double tap to \nadd a section";
		self.warningLabel.font = [UIFont fontWithDescriptor:[UIFontDescriptor fontDescriptorWithName:@"Helvetica" size:55] size:55];
		self.warningLabel.numberOfLines = 3;
		self.warningLabel.textAlignment = NSTextAlignmentCenter;
		[self.view addSubview:self.warningLabel];
	}
}

- (void) imageSaved {
	[self setupRightBarButtonCustomView];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
											  initWithCustomView:self.rightBarButtonCustomView];
	[self.navigationController.navigationBar performSelectorOnMainThread:@selector(setNeedsDisplay)
															  withObject:nil
														   waitUntilDone:YES];
}

- (void) setupRightBarButtonCustomView {
	self.rightBarButtonCustomView = [[UIImageView alloc] initWithImage:[self mainTaskImage]];
	self.rightBarButtonCustomView.frame = CGRectMake(0, 0, 40, 40);
	self.rightBarButtonCustomView.contentMode = UIViewContentModeScaleAspectFill;
	self.rightBarButtonCustomView.layer.borderWidth = 1;
	self.rightBarButtonCustomView.layer.borderColor = [UIColor whiteColor].CGColor;
	self.rightBarButtonCustomView.layer.cornerRadius = CGRectGetWidth(self.rightBarButtonCustomView.layer.frame) / 2;
	self.rightBarButtonCustomView.layer.masksToBounds = YES;
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
	cell.label.text = [NSString stringWithFormat:@"%@\n%@ %@", subTask.subTaskName,
					   subTask.subTaskFinancialCost, self.currencySymbolFromLocale];
	cell.label.backgroundColor = subTask.subTaskIsCompletedValue ? [UIColor clearColor] : [UIColor colorWithRed:0.1
																										  green:0.1
																										   blue:0.1 alpha:0.3];
	cell.backgroundColor = subTask.subTaskIsCompletedValue ? [UIColor flatSilverColor] : subTask.subTaskColor;
	
	// SHADOW
	cell.layer.masksToBounds = NO;
	cell.layer.shadowOpacity = 0.30f;
	cell.layer.shadowRadius = 10.0f;
	cell.layer.shadowOffset = CGSizeMake(15, 20);
	cell.layer.shadowPath = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
	//
	
	// BORDER
	cell.layer.borderColor = [UIColor clearColor].CGColor;
	cell.layer.borderWidth = 1.0f;
	cell.layer.cornerRadius = 10.0f;
	
	cell.label.layer.masksToBounds = YES;
	cell.label.layer.borderColor = [UIColor clearColor].CGColor;
	cell.label.layer.borderWidth = 1.0f;
	cell.label.layer.cornerRadius = 10.0f;
	//
	
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
		s.subTaskColor = [MainTaskViewController subTaskColors][section % [MainTaskViewController subTaskColors].count];
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
	if ([self.view.subviews containsObject:self.warningLabel]) {
		[self.warningLabel removeFromSuperview];
	}
	[self.collectionView.collectionViewLayout invalidateLayout]; // I Tweeted about this!
	[self setupSections];
	[self.collectionView reloadData];
}

#pragma mark - Segues

-(void) prepareForSegue:(UIStoryboardSegue *)segue
				 sender:(id)sender {
	if ([[segue identifier] isEqualToString:@"newSubTask"]) {
		NewSubTaskViewController *controller = (NewSubTaskViewController *)[segue destinationViewController];
		
		UIColor *subTaskColor = [MainTaskViewController subTaskColors][[self.indexPath indexAtPosition:0] %
																	   [MainTaskViewController subTaskColors].count];
		controller.subTaskColor = subTaskColor;
		controller.moc = self.moc;
		controller.mainTask = self.mainTask;
		controller.indexPath = self.indexPath;
		controller.delegate = self;
	} else if ([[segue identifier] isEqualToString:@"editSubTaskSegue"]) {
		UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.indexPath];
		self.popoverAnchorView.frame = CGRectMake(cell.center.x,
												  cell.center.y + cell.frame.size.height / 2,
												  1,
												  1);
		NSUInteger s = self.indexPath.section;
		NSUInteger r =  self.indexPath.row;
		EditSubTaskViewController *controller = (EditSubTaskViewController *)[segue destinationViewController];
		controller.delegate = self;
		controller.moc = self.moc;
		controller.subTask = (SubTask *)self.sections[s][r];
	}
}

#pragma mark - Utility

- (int) maxSubTasks {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *subTasks = [defaults objectForKey:MAX_SUB_TASKS_KEY];
	return [subTasks intValue];
}

- (UIImage *) mainTaskImage {
	NSData *pngData = [NSData dataWithContentsOfFile:self.mainTask.mainTaskImageURL];
	UIImage *img;
	if (!pngData) {
		img = [UIImage imageNamed:@"Logo_Keydi.png"];
	} else {
		img = [UIImage imageWithData:pngData];
	}
	
	return img;
}

@end
