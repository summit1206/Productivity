#import <Foundation/Foundation.h>
@interface TBTaskGroup : NSObject <NSCoding>
@property (strong, nonatomic) NSString* groupName;
@property (strong, nonatomic) NSMutableArray* tasks;
@property (strong, nonatomic) NSMutableArray* taskGroups;
- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithCoder:(NSCoder*)decoder;
- (void)encodeWithCoder:(NSCoder*)encoder;
@end
