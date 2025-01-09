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
        _name = [coder decodeObjectForKey:@"name"];
        _descript = [coder decodeObjectForKey:@"descript"];
        _endDate = [coder decodeObjectForKey:@"endDate"];
        _state = [coder decodeIntegerForKey:@"state"];
        _priority = [coder decodeIntegerForKey:@"priority"];
    }
    return self;
}

+(BOOL) supportsSecureCoding
{
    return YES;
}

@end
