//
//  AddToList.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "Delegate.h"
#import "List.h"
NS_ASSUME_NONNULL_BEGIN

@interface AddToList : UIViewController
@property id<Delegate> delegate;
@end

NS_ASSUME_NONNULL_END
