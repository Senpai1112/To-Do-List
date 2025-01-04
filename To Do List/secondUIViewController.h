//
//  secondUIViewController.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "FirstCustomCell.h"
#import "List.h"
#import "EditingSecondViewController.h"
#import "EditingDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface secondUIViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EditingDelegate,EditingDelegate>
@end

NS_ASSUME_NONNULL_END
