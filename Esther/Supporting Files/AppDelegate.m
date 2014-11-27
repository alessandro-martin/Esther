#import "AppDelegate.h"
#import "AMTCoreDataStack.h"
#import "MasterViewController.h"

static NSString * const MAX_MAIN_TASKS_KEY				= @"MaxMainTasks";
static NSUInteger const MAX_MAIN_TASKS_DEFAULT_VALUE	= 5;
static NSString * const MAX_SUB_TASKS_KEY				= @"MaxSubTasksForMainTask";
static NSUInteger const MAX_SUB_TASKS_DEFAULT_VALUE		= 10;

@interface AppDelegate () //<UISplitViewControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *moc;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
	MasterViewController *masterController = (MasterViewController *)navigationController.topViewController;
	// Preferences
	[self setupUserDefaults];
	// Core Data Stuff
	self.moc = [[AMTCoreDataStack alloc] initWithPersistentStoreFileName:@"EstherDB.sql"
															andStoreType:NSSQLiteStoreType].managedObjectContext;
	[masterController setMoc: self.moc];

	return YES;
}

- (void) setupUserDefaults {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:@(MAX_MAIN_TASKS_DEFAULT_VALUE) forKey:MAX_MAIN_TASKS_KEY];
	[defaults setObject:@(MAX_SUB_TASKS_DEFAULT_VALUE) forKey:MAX_SUB_TASKS_KEY];
	[defaults synchronize];
}

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

@end
