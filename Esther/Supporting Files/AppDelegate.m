#import "AppDelegate.h"
#import "DetailViewController.h"
#import "AMTCoreDataStack.h"
#import "MasterViewController.h"

#warning REMOVE THIS CRAP!
#import "MainTask.h"
static NSString * const MAIN_TASK_DEFAULT_NAME = @"Buy a Car";
static NSString * const MAIN_TASK_DEFAULT_DESCRIPTION = @"Steps necessary to purchase an automobile";
static NSString * const OTHER_MAIN_TASK_DEFAULT_NAME = @"Set Up as Freelancer";
static NSString * const OTHER_MAIN_TASK_DEFAULT_DESCRIPTION = @"Steps necessary to independently develop apps";
#warning UNTIL HERE!

static NSString * const MAX_MAIN_TASKS_KEY				= @"MaxMainTasks";
static NSUInteger const MAX_MAIN_TASKS_DEFAULT_VALUE	= 5;
static NSString * const MAX_SUB_TASKS_KEY				= @"MaxSubTasksForMainTask";
static NSUInteger const MAX_SUB_TASKS_DEFAULT_VALUE		= 10;

@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
	UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
	UINavigationController *secondNavController = [splitViewController.viewControllers firstObject];
	navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
	splitViewController.delegate = self;
	// VERY IMPORTANT!!!!!!
	splitViewController.presentsWithGesture = NO;
	
	// Preferences
	[self setupUserDefaults];
	
	
	// Core Data Stuff
	self.moc = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:@"EstherDB.sql"
															andStoreType:NSSQLiteStoreType].managedObjectContext;
	[(MasterViewController *)[secondNavController.viewControllers lastObject]  setMoc: self.moc];
	[self populateDB];
	
	return YES;
}

- (void) setupUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSNumber *mainTasks = [defaults objectForKey:MAX_MAIN_TASKS_KEY];
	NSNumber *subTasks = [defaults objectForKey:MAX_SUB_TASKS_KEY];
	if (!mainTasks || !subTasks) {
		[defaults setObject:@(MAX_MAIN_TASKS_DEFAULT_VALUE) forKey:MAX_MAIN_TASKS_KEY];
		[defaults setObject:@(MAX_SUB_TASKS_DEFAULT_VALUE) forKey:MAX_SUB_TASKS_KEY];
		[defaults synchronize];
		NSLog(@"Max Main Tasks & Max Sub Tasks Defaults Initialized!");
	} else {
		NSLog(@"Max Main Tasks: %@, Max Sub Tasks: %@", mainTasks, subTasks);
	}
}

#warning REMOVE THIS CRAP!
- (void) populateDB {
	[self setupAndInsertMainTask];
	[self setupAndInsertOtherMainTask];
}

- (BOOL)setupAndInsertMainTask {
	if ([MainTask existsMainTaskWithName:MAIN_TASK_DEFAULT_NAME
							   inContext:self.moc]) {
		NSLog(@"Object mainTask already in database");
		return NO;
	}
	MainTask *mainTask = [MainTask insertInManagedObjectContext:self.moc];
	mainTask.mainTaskName = MAIN_TASK_DEFAULT_NAME;
	mainTask.mainTaskDescription = MAIN_TASK_DEFAULT_DESCRIPTION;
	mainTask.mainTaskCreationDate = [NSDate date];
	mainTask.mainTaskIsVisibleValue = YES;
	
	[self.moc save:nil];
	return YES;
}

- (BOOL)setupAndInsertOtherMainTask {
	if ([MainTask existsMainTaskWithName:OTHER_MAIN_TASK_DEFAULT_NAME
							   inContext:self.moc]) {
		NSLog(@"Object otherMainTask already in database");
		return NO;
	}
	MainTask *otherMainTask = [MainTask insertInManagedObjectContext:self.moc];
	otherMainTask.mainTaskName = OTHER_MAIN_TASK_DEFAULT_NAME;
	otherMainTask.mainTaskDescription = OTHER_MAIN_TASK_DEFAULT_DESCRIPTION;
	otherMainTask.mainTaskCreationDate = [NSDate date];
	otherMainTask.mainTaskIsVisibleValue = NO;
	
	[self.moc save:nil];
	return YES;
}
#warning UNTIL HERE!

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
