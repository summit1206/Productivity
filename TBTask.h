#import <Foundation/Foundation.h>
@interface TBTask : NSObject <NSCoding>
@property (strong, nonatomic) NSString* taskName;
@property (strong, nonatomic) NSString* taskDescription;
@property (assign, nonatomic) NSInteger timeEstimate;
@property (strong, nonatomic) NSString* timeUnits;
@property (strong, nonatomic) NSDate* dueDate;
- (instancetype)initWithName:(NSString*)name
                 description:(NSString*)description
                timeEstimate:(NSInteger)time
                   timeUnits:(NSString*)units
                     dueDate:(NSDate*)date;
- (instancetype)initWithCoder:(NSCoder*)decoder;
- (void)encodeWithCoder:(NSCoder*)encoder;
@end
