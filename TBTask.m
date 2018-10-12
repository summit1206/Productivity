#import "TBTask.h"
@implementation TBTask
- (instancetype)initWithName:(NSString*)name description:(NSString*)description timeEstimate:(NSInteger)time timeUnits:(NSString*)units dueDate:(NSDate*)date {
    self = [super init];
    if (self) {
        _taskName = name;
        _taskDescription = description;
        _timeEstimate = time;
        _timeUnits = units;
        _dueDate = date;
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)decoder {
    self = [super init];
    if (self) {
        _taskName = [decoder decodeObjectForKey:@"taskName"];
        _taskDescription = [decoder decodeObjectForKey:@"taskDescription"];
        _timeEstimate = [decoder decodeIntegerForKey:@"timeEstimate"];
        _timeUnits = [decoder decodeObjectForKey:@"timeUnits"];
        _dueDate = [decoder decodeObjectForKey:@"dueDate"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:_taskName forKey:@"taskName"];
    [encoder encodeObject:_taskDescription forKey:@"taskDescription"];
    [encoder encodeInteger:_timeEstimate forKey:@"timeEstimate"];
    [encoder encodeObject:_timeUnits forKey:@"timeUnits"];
    [encoder encodeObject:_dueDate forKey:@"dueDate"];
}
@end
