//
//  EditingDelegate.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <Foundation/Foundation.h>
#import "List.h"
NS_ASSUME_NONNULL_BEGIN

@protocol EditingDelegate <NSObject>
@required
-(void) editToTheTable : (List*) list :(NSInteger) section : (NSInteger) row;
@end

NS_ASSUME_NONNULL_END
