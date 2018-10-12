#import "TBTaskGroup.h"
@implementation TBTaskGroup
- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        _groupName = name;
        _tasks = [[NSMutableArray alloc] init];
        _taskGroups = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)decoder {
    self = [super init];
    if (self) {
        _groupName = [decoder decodeObjectForKey:@"groupName"];
        _tasks = [decoder decodeObjectForKey:@"tasks"];
        _taskGroups = [decoder decodeObjectForKey:@"taskGroups"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:_groupName forKey:@"groupName"];
    [encoder encodeObject:_tasks forKey:@"tasks"];
    [encoder encodeObject:_taskGroups forKey:@"taskGroups"];
}
@end
