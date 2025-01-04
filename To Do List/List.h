//
//  List.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface List : NSObject <NSCoding,NSSecureCoding>
@property NSString * name;
@property NSString * descript;
@property NSDate * endDate;
@property NSInteger priority;
@property NSInteger state;

@end

NS_ASSUME_NONNULL_END
