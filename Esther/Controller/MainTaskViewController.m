#import "MainTaskViewController.h"
#import "Cell.h"

#define SECTION_COUNT 3
#define ITEM_COUNT 5

@interface MainTaskViewController () <UISplitViewControllerDelegate> {
    NSMutableArray *sections;
}
@end

@implementation MainTaskViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    sections = [[NSMutableArray alloc] initWithCapacity:SECTION_COUNT];
    for(int s = 0; s < SECTION_COUNT; s++) {
        NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:ITEM_COUNT];
		//int itemCount = arc4random() % ITEM_COUNT;
        for(int i = 0; i < ITEM_COUNT; i++) {
            [data addObject:[NSString stringWithFormat:@"%c %@", 65+s, @(i)]];
        }
        [sections addObject:data];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[sections objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSMutableArray *data = [sections objectAtIndex:indexPath.section];
    
    cell.label.text = [data objectAtIndex:indexPath.item];
    
    return cell;
}

- (BOOL)collectionView:(LSCollectionViewHelper *)collectionView
canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row >= [sections[indexPath.section] count]) {
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
    NSMutableArray *data1 = [sections objectAtIndex:fromIndexPath.section];
    NSMutableArray *data2 = [sections objectAtIndex:toIndexPath.section];
	
	NSString *index = [data1 objectAtIndex:fromIndexPath.item];
	
    [data1 removeObjectAtIndex:fromIndexPath.item];
    [data2 insertObject:index atIndex:toIndexPath.item];
}

@end
