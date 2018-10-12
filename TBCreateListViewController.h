#import <UIKit/UIKit.h>
#import "TBScreenManager.h"
#import "TBListsViewController.h"
#import "TBList.h"
@interface TBCreateListViewController : UITableViewController <UITextFieldDelegate>
@property (assign, nonatomic) UIViewController* previousViewController;
@end
