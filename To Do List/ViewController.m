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
    NSMutableArray<List*> * lowPriority;
    NSMutableArray<List*> * medPriority;
    NSMutableArray<List*> * highPriority;
    
    NSMutableArray<List*> * toDo;
    NSData * toDoData;
    NSString * toDoKey;

    NSMutableArray<List*> * filteredToDo;
        
    NSUserDefaults * defaults;
    NSMutableArray * sections;
    

    NSString * progressKey;
    NSString * doneKey;
}

@property (weak, nonatomic) IBOutlet UITableView *toDoTable;

@end

@implementation ViewController

-(void) arrangeWithPriorities
{
    [lowPriority removeAllObjects];
    [medPriority removeAllObjects];
    [highPriority removeAllObjects];
    for(int i = 0; i < toDo.count ; i++)
    {
        if(toDo[i].priority == 0)
        {
            [lowPriority addObject:toDo[i]];
        }
        else if (toDo[i].priority == 1)
        {
            [medPriority addObject:toDo[i]];
        }
        else
        {
            [highPriority addObject:toDo[i]];
        }
    }
}

-(void) readFromUserDefaults
{
    toDoData = [defaults objectForKey:toDoKey];
    if(toDoData)
    {
        toDo = [NSKeyedUnarchiver unarchiveObjectWithData:toDoData];
        filteredToDo = [toDo mutableCopy];
        [self arrangeWithPriorities];
    }
}

-(void) editInTheUserDefaults
{
    toDoData = [NSKeyedArchiver archivedDataWithRootObject:toDo requiringSecureCoding:YES error:nil];
    [defaults setObject:toDoData forKey:toDoKey];
    [defaults synchronize];
    [self arrangeWithPriorities];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(addToList)];
    self.tabBarController.navigationItem.rightBarButtonItem = addButton;
    
    UISearchController * searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.hidesNavigationBarDuringPresentation= YES;
    [searchController searchBar];
    searchController.searchResultsUpdater = self;
    self.tabBarController.navigationItem.searchController = searchController;
    
}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString * searchText = searchController.searchBar.text;
    if(searchText.length == 0)
    {
        [self readFromUserDefaults];
    }
    else
    {
        [self readFromUserDefaults];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@",searchText];
        toDo = [toDo filteredArrayUsingPredicate:predicate];
        [self arrangeWithPriorities];
    }
    [self.toDoTable reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _toDoTable.delegate = self;
    _toDoTable.dataSource = self;
    
    self.toDoTable.rowHeight = UITableViewAutomaticDimension;
    
    sections = [[NSMutableArray alloc] initWithObjects:@"Low Priority",@"Meduim Priority", @"High Priority",nil];
    
    toDo = [NSMutableArray new];
    
    
    filteredToDo = [NSMutableArray new];
    lowPriority = [NSMutableArray new];
    medPriority = [NSMutableArray new];
    highPriority = [NSMutableArray new];
    
    toDoData = [NSData new];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    toDoKey = @"toDoKey";
    
    
    progressKey = @"progressKey";
    doneKey = @"doneKey";
    
    toDoData = [defaults objectForKey:toDoKey];
    
    
    if(toDoData)
    {
        toDo = [NSKeyedUnarchiver unarchiveObjectWithData:toDoData];
        filteredToDo = [toDo mutableCopy];
        [self arrangeWithPriorities];
    }
}

- (void)addListToTheTable :(List*) list
{
    NSData * temp = [NSData new];
    switch (list.priority)
    {
        case 0:
            [toDo addObject:list];
            break;
            
        case 1 :
            [toDo addObject:list];
            break;
        case 2:
            [toDo addObject:list];
    }
    /*filteredLowPriority = [lowPriority mutableCopy];
    filteredMedPriority = [medPriority mutableCopy];
    filteredHighPriority = [highPriority mutableCopy];*/
    [self editInTheUserDefaults];
    [self.toDoTable reloadData];
}
-(void) addToList
{
    AddToList * add = [self.storyboard instantiateViewControllerWithIdentifier:@"addToList"];
    add.delegate = self;
    [self presentViewController:add animated:YES completion:nil];
}
- (void)editToTheTable:(nonnull List *)list :(NSInteger)section :(NSInteger)row {
    List * tempList = [List new];
    NSData * temp = [NSData new];
    if(list.state == 0)
    {
        switch (section) {
            case 0:
                tempList = [lowPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            case 1:
                tempList = [medPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            default:
                tempList = [highPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
        }
        [toDo addObject:list];
    }
    else if(list.state == 1)
    {
        switch (section)
        {
            case 0:
                tempList = [lowPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            case 1:
                tempList = [medPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            default:
                tempList = [highPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
        }
        /*
        toDoData = [NSKeyedArchiver archivedDataWithRootObject:toDo requiringSecureCoding:YES error:nil];
        [defaults setObject:toDoData forKey:toDoKey];
        [defaults synchronize];
        [self arrangeWithPriorities];
        */
        temp = [defaults objectForKey:progressKey];
        list.state = list.state-1;
        if (temp != nil)
        {
            NSMutableArray<List*> * arr = [NSMutableArray new];
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:temp];
            [arr addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:progressKey];
            [defaults synchronize];
        }
        else
        {
            NSMutableArray<List*> * arr = [[NSMutableArray alloc] initWithObjects:list, nil];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:progressKey];
            [defaults synchronize];
        }
    }
    else
    {
        switch (section) {
            case 0:
                tempList = [lowPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            case 1:
                tempList = [medPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
                
            default:
                tempList = [highPriority objectAtIndex:row];
                [toDo removeObjectIdenticalTo:tempList];
                break;
        }
        temp = [defaults objectForKey:doneKey];
        list.state = list.state-2;
        if (temp != nil)
        {
            NSMutableArray<List*> * arr = [NSMutableArray new];
            arr = [NSKeyedUnarchiver unarchiveObjectWithData:temp];
            [arr addObject:list];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:doneKey];
            [defaults synchronize];
        }
        else
        {
            NSMutableArray<List*> * arr = [[NSMutableArray alloc] initWithObjects:list, nil];
            temp = [NSKeyedArchiver archivedDataWithRootObject:arr requiringSecureCoding:YES error:nil];
            [defaults setObject:temp forKey:doneKey];
            [defaults synchronize];
        }
    }
    [self editInTheUserDefaults];
    [self arrangeWithPriorities];
    [self.toDoTable reloadData];
    /*filteredLowPriority = [lowPriority mutableCopy];
    filteredMedPriority = [medPriority mutableCopy];
    filteredHighPriority = [highPriority mutableCopy];*/
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
            List * list = [List new];
            switch (indexPath.section) {
                case 0:
                    list = [self->lowPriority objectAtIndex:indexPath.row];
                    [self->lowPriority removeObjectAtIndex:indexPath.row];
                    break;
                    
                case 1:
                    list = [self->medPriority objectAtIndex:indexPath.row];
                    [self->medPriority removeObjectAtIndex:indexPath.row];
                    break;
                    
                default:
                    list = [self->highPriority objectAtIndex:indexPath.row];
                    [self->highPriority removeObjectAtIndex:indexPath.row];
                    break;
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            /*self->filteredLowPriority = [self->lowPriority mutableCopy];
            self->filteredMedPriority = [self->medPriority mutableCopy];
            self->filteredHighPriority = [self->highPriority mutableCopy];*/
            [self->toDo removeObjectIdenticalTo:list];
            [self editInTheUserDefaults];
            [self arrangeWithPriorities];
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
            //return filteredLowPriority.count;
            break;
        case 1:
            return medPriority.count;
            //return filteredMedPriority.count;
            break;
        default:
            return highPriority.count;
            //return filteredHighPriority.count;
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
            break;
           
        case 1:
            cell.firstCustomCellLabel.text = [[medPriority objectAtIndex:indexPath.row] name];
            cell.firstCustomCellImage.image = [UIImage imageNamed:@"2"];
            break;
            
        default:
            cell.firstCustomCellLabel.text = [[highPriority objectAtIndex:indexPath.row] name];
            cell.firstCustomCellImage.image = [UIImage imageNamed:@"3"];
            break;
    }
    cell.firstCustomCellImage.layer.cornerRadius = 30;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if([view isKindOfClass:[UITableViewHeaderFooterView class]])
    {
        UITableViewHeaderFooterView * headerView = (UITableViewHeaderFooterView *) view;
        switch (section) {
            case 0:
                headerView.textLabel.textColor  = [UIColor systemGreenColor];
                break;
            case 1:
                headerView.textLabel.textColor = [UIColor systemYellowColor];
                break;
            default:
                headerView.textLabel.textColor  = [UIColor systemRedColor];
                break;
        }
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
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
