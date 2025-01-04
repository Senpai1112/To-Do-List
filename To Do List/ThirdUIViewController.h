//
//  ThirdUIViewController.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "FirstCustomCell.h"
#import "List.h"
#import "EditingSecondViewController.h"
#import "EditingDelegate.h"
#import "EditingThirdViewController.h"
#import "Delegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface ThirdUIViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,EditingDelegate,Delegate>

@end

NS_ASSUME_NONNULL_END
