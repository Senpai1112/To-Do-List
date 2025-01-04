//
//  EditingSecondViewController.m
//  To Do List
//
//  Created by Youssab on 31/12/2024.
//

#import "EditingSecondViewController.h"

@interface EditingSecondViewController ()
@property (weak, nonatomic) IBOutlet UITextField *editingName;
@property (weak, nonatomic) IBOutlet UITextField *editingDescription;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editingPriorityOutlet;
@property (weak, nonatomic) IBOutlet UISegmentedControl *editingStateOutlet;
@property (weak, nonatomic) IBOutlet UIDatePicker *editingDate;
@end

@implementation EditingSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _editingName.text = _list.name;
    _editingDescription.text = _list.descript;
    _editingPriorityOutlet.selectedSegmentIndex = _list.priority;
    _editingDate.date = _list.endDate;
    _editingStateOutlet.selectedSegmentIndex = _list.state;
}
- (IBAction)editingPriorityAction:(id)sender {
    
}
- (IBAction)editingStateAction:(id)sender {
    
}
- (IBAction)confirmEditing:(id)sender {
    List * newList = [List new];
    newList.name = _editingName.text;
    newList.descript =_editingDescription.text;
    newList.priority =_editingPriorityOutlet.selectedSegmentIndex;
    newList.state =_editingStateOutlet.selectedSegmentIndex;
    newList.endDate = _editingDate.date;
    [_editingDelegate editToTheTable:newList:_section:_row];
    [self.navigationController popViewControllerAnimated:YES];
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
