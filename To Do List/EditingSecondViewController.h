//
//  EditingSecondViewController.h
//  To Do List
//
//  Created by Youssab on 31/12/2024.
//

#import <UIKit/UIKit.h>
#import "EditingDelegate.h"
#import "List.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditingSecondViewController : UIViewController
@property id<EditingDelegate> editingDelegate;
@property List * list;
@property NSInteger section;
@property NSInteger row;
@end

NS_ASSUME_NONNULL_END
