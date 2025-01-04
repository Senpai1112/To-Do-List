//
//  EditingViewController.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "List.h"
#import "EditingDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditingViewController : UIViewController
@property id<EditingDelegate> editingDelegate;
@property List * list;
@property NSInteger section;
@property NSInteger row;
@end

NS_ASSUME_NONNULL_END
