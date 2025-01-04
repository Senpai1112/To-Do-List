//
//  List.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "List.h"

@implementation List
{
    
}
- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_descript forKey:@"descript"];
    [coder encodeObject:_endDate forKey:@"endDate"];
    [coder encodeInteger:_priority forKey:@"priority"];
    [coder encodeInteger:_state forKey:@"state"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    if((self = [super init]))
    {
        _name = [coder decodeObjectOfClass:[NSString class] forKey:@"name"];
        _descript = [coder decodeObjectOfClass:[NSString class] forKey:@"descript"];
        _endDate = [coder decodeObjectOfClass:[NSString class] forKey:@"endDate"];
        _state = [coder decodeIntForKey:@"state"];
        _priority = [coder decodeIntForKey:@"priority"];
    }
    return self;
}

+(BOOL) supportsSecureCoding
{
    return YES;
}

@end
