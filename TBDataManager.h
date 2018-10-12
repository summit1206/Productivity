#import <Foundation/Foundation.h>
@interface TBDataManager : NSObject
@property (strong, nonatomic) NSString* userName;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (strong, nonatomic) NSMutableArray* taskGroups;
@property (strong, nonatomic) NSMutableArray* lists;
+ (instancetype)instance;
- (void)initializeData;
- (void)saveData;
- (void)loadData;
@end
