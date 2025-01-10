//
//  ViewController.h
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import <UIKit/UIKit.h>
#import "Delegate.h"
#import "EditingDelegate.h"

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,Delegate,EditingDelegate,UISearchControllerDelegate>


@end

