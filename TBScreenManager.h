#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TBScreenManager : NSObject
+ (void)showScreen:(NSString*)screen from:(UIViewController*)target withSetup:(void(^)(UIViewController*))setup;
+ (void)showModal:(NSString*)modal from:(UIViewController*)target withSetup:(void(^)(UINavigationController*))setup;
+ (void)back:(UIViewController*)target;
+ (void)dismissModal:(UIViewController*)target;
+ (void)backToScreen:(NSString*)screen from:(UIViewController*)target withSetup:(void(^)(UIViewController*))setup;
@end
