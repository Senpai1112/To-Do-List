//
//  AddToList.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "AddToList.h"

@interface AddToList ()
{
    NSInteger priority;
    NSInteger state;
}
@property (weak, nonatomic) IBOutlet UITextField *addToListName;
@property (weak, nonatomic) IBOutlet UITextField *addToListDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegmentOutlet;
@property (weak, nonatomic) IBOutlet UIDatePicker *addToListDate;

@end

@implementation AddToList

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    priority = 0;
    state = 0;
}
- (IBAction)addToListButton:(id)sender {
    List * list = [List new];
    list.name = _addToListName.text;
    list.descript = _addToListDescription.text;
    list.priority = priority;
    list.state = 0;
    list.endDate = _addToListDate.date;
    [_delegate addListToTheTable:list];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)prioritySegmentAction:(id)sender {
        priority = _prioritySegmentOutlet.selectedSegmentIndex;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
