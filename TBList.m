#import "TBList.h"
@implementation TBList
- (instancetype)initWithName:(NSString*)name {
    self = [super init];
    if (self) {
        _listName = name;
        _listItems = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder*)decoder {
    self = [super init];
    if (self) {
        _listName = [decoder decodeObjectForKey:@"listName"];
        _listItems = [decoder decodeObjectForKey:@"listItems"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder*)encoder {
    [encoder encodeObject:_listName forKey:@"listName"];
    [encoder encodeObject:_listItems forKey:@"listItems"];
}
@end
