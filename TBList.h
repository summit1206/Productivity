#import <Foundation/Foundation.h>
@interface TBList : NSObject <NSCoding>
@property (strong, nonatomic) NSString* listName;
@property (strong, nonatomic) NSMutableArray* listItems;
- (instancetype)initWithName:(NSString*)name;
- (instancetype)initWithCoder:(NSCoder*)decoder;
- (void)encodeWithCoder:(NSCoder*)encoder;
@end
