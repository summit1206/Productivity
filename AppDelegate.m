#import "AppDelegate.h"
#import "TBDataManager.h"
#import "TBMenuViewController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TBMenuViewController *NaviController = [mainStory instantiateViewControllerWithIdentifier:@"menuViewController"];
    UINavigationController *control = [mainStory instantiateViewControllerWithIdentifier:@"BuleNavigation"];
    self.window.rootViewController = [control initWithRootViewController:NaviController];
    [self.window makeKeyAndVisible];
    [TBDataManager.instance initializeData];
    [TBDataManager.instance loadData];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication*)application {
}
- (void)applicationDidEnterBackground:(UIApplication*)application {
    [TBDataManager.instance saveData];
}
- (void)applicationWillEnterForeground:(UIApplication*)application {
}
- (void)applicationDidBecomeActive:(UIApplication*)application {
}
- (void)applicationWillTerminate:(UIApplication*)application {
    [TBDataManager.instance saveData];
}
@end
