#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "TBDataManager.h"
#import "TBScreenManager.h"
#import "TBCreateListViewController.h"
#import "TBList.h"
@interface TBListsViewController : UITableViewController
- (void)setListSource:(NSMutableArray*)lists;
- (void)addList:(TBList*)list;
@end
