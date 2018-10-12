#import "TBDataManager.h"
@implementation TBDataManager
+ (instancetype)instance {
    static id instance = nil;
    static dispatch_once_t singleton;
    dispatch_once(&singleton, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
- (void)initializeData {
    _userName = @"";
    _tasks = [[NSMutableArray alloc] init];
    _taskGroups = [[NSMutableArray alloc] init];
    _lists = [[NSMutableArray alloc] init];
}
- (void)saveData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_userName forKey:@"TBUserName"];
    NSData* encodedTasks = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
    [userDefaults setObject:encodedTasks forKey:@"TBTasks"];
    NSData* encodedGroups = [NSKeyedArchiver archivedDataWithRootObject:_taskGroups];
    [userDefaults setObject:encodedGroups forKey:@"TBTaskGroups"];
    [userDefaults synchronize];
}
- (void)loadData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    _userName = [userDefaults objectForKey:@"TBUserName"];
    NSData* taskData = [[NSData alloc] initWithData:[userDefaults objectForKey:@"TBTasks"]];
    if (taskData) {
        NSArray* taskArray = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
        _tasks = [[NSMutableArray alloc] initWithArray:taskArray];
    }
    NSData* groupData = [[NSData alloc] initWithData:[userDefaults objectForKey:@"TBTaskGroups"]];
    if (groupData) {
        NSArray* groupArray = [NSKeyedUnarchiver unarchiveObjectWithData:groupData];
        _taskGroups = [[NSMutableArray alloc] initWithArray:groupArray];
    }
}
@end
