//
//  ViewController.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "ViewController.h"
#import "FirstCustomCell.h"
#import "List.h"
#import "AddToList.h"
#import "EditingViewController.h"
#import "secondUIViewController.h"

@interface ViewController ()
{
    NSMutableArray * lowPriority;
    NSMutableArray * medPriority;
    NSMutableArray * highPriority;
    
    NSData * lowPriorityData;
    NSData * medPriorityData;
    NSData * highPriorityData;
    
    NSData * inProgressData;
    
    NSUserDefaults * defaults;
    NSMutableArray * sections;
    
    NSString * lowPriorityKey;
    NSString * medPriorityKey;
    NSString * highPriorityKey;
    NSString * inProgressListKey;
    NSString * inDoneListKey;

}

@property (weak, nonatomic) IBOutlet UITableView *toDoTable;

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addToList)];
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _toDoTable.delegate = self;
    _toDoTable.dataSource = self;
    self.toDoTable.rowHeight = UITableViewAutomaticDimension;
    self.toDoTable.estimatedRowHeight = UITableViewAutomaticDimension;
    

    sections = [[NSMutableArray alloc] initWithObjects:@"Low Priority",@"Meduim Priority", @"High Priority",nil];
    
    lowPriority = [NSMutableArray new];
    medPriority = [NSMutableArray new];
    highPriority = [NSMutableArray new];
    
    lowPriorityData = [NSData new];
    medPriorityData = [NSData new];
    highPriorityData = [NSData new];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    lowPriorityKey = @"lowPriorityKey";
    medPriorityKey = @"medPriorityKey";
    highPriorityKey = @"highPriorityKey";
    
    inProgressListKey = @"inProgressListKey";
    inDoneListKey = @"inDoneListKey";
    inProgressData = [NSData new];
    
    lowPriorityData = [defaults objectForKey:lowPriorityKey];
    medPriorityData = [defaults objectForKey:medPriorityKey];
    highPriorityData = [defaults objectForKey:highPriorityKey];
    
    if(lowPriorityData)
    {
        lowPriority = [NSKeyedUnarchiver unarchiveObjectWithData:lowPriorityData];
    }
    if(medPriorityData)
    {
        medPriority = [NSKeyedUnarchiver unarchiveObjectWithData:medPriorityData];
    }
    if(highPriorityData)
    {
        highPriority = [NSKeyedUnarchiver unarchiveObjectWithData:highPriorityData];
    }
}


- (void)addListToTheTable :(List*) list
{
    NSData * temp = [NSData new];
    switch (list.priority)
    {
        case 0:
            [lowPriority addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:lowPriorityKey];
            [defaults synchronize];
            break;
            
        case 1 :
            [medPriority addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:medPriorityKey];
            [defaults synchronize];
            break;
        case 2:
            [highPriority addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:highPriorityKey];
            [defaults synchronize];
    }
    [self.toDoTable reloadData];
}
-(void) addToList
{
    AddToList * add = [self.storyboard instantiateViewControllerWithIdentifier:@"addToList"];
    add.delegate = self;
    [self presentViewController:add animated:YES completion:nil];
}
- (void)editToTheTable:(nonnull List *)list :(NSInteger)section :(NSInteger)row {
    NSData * temp = [NSData new];
    if(list.state == 0)
    {
        switch (section) {
            case 0:
                [lowPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:lowPriorityKey];
                [defaults synchronize];
                break;
                
            case 1:
                [medPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:medPriorityKey];
                [defaults synchronize];
                break;
                
            default:
                [highPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:highPriorityKey];
                [defaults synchronize];
                break;
        }
        switch (list.priority)
        {
            case 0:
                [lowPriority addObject:list];
                temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:lowPriorityKey];
                [defaults synchronize];
                break;
                
            case 1 :
                [medPriority addObject:list];
                temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:medPriorityKey];
                [defaults synchronize];
                break;
                
            default:
                [highPriority addObject:list];
                temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:highPriorityKey];
                [defaults synchronize];
                break;
        }
        [self.toDoTable reloadData];
    }
    else if(list.state == 1)
    {
        switch (section) {
            case 0:
                [lowPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:lowPriorityKey];
                [defaults synchronize];
                break;
                
            case 1:
                [medPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:medPriorityKey];
                [defaults synchronize];
                break;
                
            default:
                [highPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:highPriorityKey];
                [defaults synchronize];
                break;
        }
        /*if([defaults boolForKey:@"isSecondEdited"])
         {
         NSMutableArray * newarray = [[NSMutableArray alloc]initWithObjects:list,inProgressData, nil];
         NSData * newdata = [NSData new];
         
         }*/
        if([defaults boolForKey:@"isSecondEdited"])
        {
            NSMutableArray * arr = [NSMutableArray new];
            temp = [defaults objectForKey:inProgressListKey];
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:temp];
            [arr addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
        }
        else
        {
            list.state = list.state-1;
            temp = [NSKeyedArchiver archivedDataWithRootObject:list];
            [defaults setObject:temp forKey:inProgressListKey];
        }
        [self.toDoTable reloadData];
        [defaults setBool:YES forKey:@"isSecondEdited"];
    }
    else
    {
        switch (section) {
            case 0:
                [lowPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:lowPriorityKey];
                [defaults synchronize];
                break;
                
            case 1:
                [medPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:medPriorityKey];
                [defaults synchronize];
                break;
                
            default:
                [highPriority removeObjectAtIndex:row];
                temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
                [defaults setObject:temp forKey:highPriorityKey];
                [defaults synchronize];
                break;
        }
        /*if([defaults boolForKey:@"isSecondEdited"])
         {
         NSMutableArray * newarray = [[NSMutableArray alloc]initWithObjects:list,inProgressData, nil];
         NSData * newdata = [NSData new];
         
         }*/
        if([defaults boolForKey:@"isThirdEdited"])
        {
            NSMutableArray * arr = [NSMutableArray new];
            temp = [defaults objectForKey:inProgressListKey];
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:temp];
            [arr addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
        }
        else
        {
            list.state = list.state-2;
            temp = [NSKeyedArchiver archivedDataWithRootObject:list];
            [defaults setObject:temp forKey:inDoneListKey];
        }
        [self.toDoTable reloadData];
        [defaults setBool:YES forKey:@"isThirdEdited"];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you Sure you want to delete this cell ?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSData * temp = [NSData new];
            switch (indexPath.section) {
                case 0:
                    [self->lowPriority removeObjectAtIndex:indexPath.row];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:self->lowPriority requiringSecureCoding:YES error:nil];
                    [self->defaults setObject:temp forKey:self->lowPriorityKey];
                    [self->defaults synchronize];
                    break;
                    
                case 1:
                    [self->medPriority removeObjectAtIndex:indexPath.row];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:self->medPriority requiringSecureCoding:YES error:nil];
                    [self->defaults setObject:temp forKey:self->medPriorityKey];
                    [self->defaults synchronize];
                    break;
                    
                default:
                    [self->highPriority removeObjectAtIndex:indexPath.row];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:self->highPriority requiringSecureCoding:YES error:nil];
                    [self->defaults setObject:temp forKey:self->highPriorityKey];
                    [self->defaults synchronize];
                    break;
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:NULL];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return lowPriority.count;
            break;
        case 1:
            return medPriority.count;
            break;
        default:
            return highPriority.count;
            break;
    }
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sections[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    switch (indexPath.section) {
        case 0:
            cell.firstCustomCellLabel.text = [[lowPriority objectAtIndex:indexPath.row] name];
            cell.firstCustomCellImage.image = [UIImage imageNamed:@"1"];
            cell.firstCustomCellImage.layer.cornerRadius = 30;
            break;
           
        case 1:
            cell.firstCustomCellLabel.text = [[medPriority objectAtIndex:indexPath.row] name];
            cell.firstCustomCellImage.image = [UIImage imageNamed:@"2"];
            cell.firstCustomCellImage.layer.cornerRadius = 30;
            break;
            
        default:
            cell.firstCustomCellLabel.text = [[highPriority objectAtIndex:indexPath.row] name];
            cell.firstCustomCellImage.image = [UIImage imageNamed:@"3"];
            cell.firstCustomCellImage.layer.cornerRadius = 30;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingViewController * editingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    editingVC.editingDelegate = self;
    switch (indexPath.section)
    {
        case 0:
            [editingVC setList:lowPriority[indexPath.row]];
            break;
        case 1:
            [editingVC setList:medPriority[indexPath.row]];
            break;
        default:
            [editingVC setList:highPriority[indexPath.row]];
            break;
    }
    [editingVC setRow:indexPath.row];
    [editingVC setSection:indexPath.section];
    [self.navigationController pushViewController:editingVC animated:YES];
}

/*
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    <#code#>
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    <#code#>
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    <#code#>
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    <#code#>
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    <#code#>
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
    <#code#>
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    <#code#>
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    <#code#>
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    <#code#>
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    <#code#>
}

- (void)setNeedsFocusUpdate { 
    <#code#>
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
    <#code#>
}

- (void)updateFocusIfNeeded { 
    <#code#>
}
*/

@end
