#import "TBScreenManager.h"
@implementation TBScreenManager
+ (void)showScreen:(NSString*)screen from:(UIViewController*)target withSetup:(void(^)(UIViewController*))setup {
    UIViewController* viewController = [target.storyboard instantiateViewControllerWithIdentifier:screen];
    if (setup) {
        setup(viewController);
    }
    [target.navigationController pushViewController:viewController animated:YES];
}
+ (void)showModal:(NSString*)modal from:(UIViewController*)target withSetup:(void(^)(UINavigationController*))setup {
    UINavigationController* navigationController = [target.storyboard instantiateViewControllerWithIdentifier:modal];
    if (setup) {
        setup(navigationController);
    }
    [target.navigationController presentViewController:navigationController animated:YES completion:nil];
}
+ (void)back:(UIViewController*)target {
    [target.navigationController popViewControllerAnimated:YES];
}
+ (void)dismissModal:(UIViewController*)target {
    [target.navigationController dismissViewControllerAnimated:YES completion:nil];
}
+ (void)backToScreen:(NSString*)screen from:(UIViewController*)target withSetup:(void(^)(UIViewController*))setup {
}
@end
