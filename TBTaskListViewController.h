#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
#import "TBDataManager.h"
#import "TBScreenManager.h"
#import "TBTask.h"
#import "TBTaskGroup.h"
#import "TBCreateTaskViewController.h"
@interface TBTaskListViewController : UITableViewController
- (void)setTaskSource:(NSMutableArray*)tasks groupSource:(NSMutableArray*)groups;
- (void)addTask:(TBTask*)task;
@end
