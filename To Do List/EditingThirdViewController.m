//
//  EditingThirdViewController.m
//  To Do List
//
//  Created by Youssab on 31/12/2024.
//

#import "EditingThirdViewController.h"

@interface EditingThirdViewController ()
@property (weak, nonatomic) IBOutlet UILabel *editingName;
@property (weak, nonatomic) IBOutlet UILabel *editingDescription;
@property (weak, nonatomic) IBOutlet UILabel *editingPriority;
@property (weak, nonatomic) IBOutlet UILabel *editingDone;
@property (weak, nonatomic) IBOutlet UIDatePicker *editingDate;




@end

@implementation EditingThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _editingName.text = _list.name;
    _editingDescription.text = _list.descript;
    switch (_list.priority) {
        case 0:
            _editingPriority.text = @"Low";
            break;
        case 1:
            _editingPriority.text = @"Meduim";
            break;
        default:
            _editingPriority.text =@"High";
            break;
    }
    _editingDone.text = @"Done";
    _editingDate.date = _list.endDate;
    _editingDate.enabled = NO;
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
