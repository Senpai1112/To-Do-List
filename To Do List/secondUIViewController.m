//
//  secondUIViewController.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "secondUIViewController.h"

@interface secondUIViewController ()
{
    NSMutableArray<List*> * progress;
    NSMutableArray<List*> * lowPriority;
    NSMutableArray<List*> * medPriority;
    NSMutableArray<List*> * highPriority;

    NSData * progressData;
    
    NSUserDefaults * defaults;
    NSMutableArray * sections;
    
    NSString * progressKey;
    NSString * doneKey;
    
    NSString * isSortedKey;
}
@property (weak, nonatomic) IBOutlet UITableView *inProgressTable;

@end

@implementation secondUIViewController

-(void) arrangeWithPriorities
{
    [lowPriority removeAllObjects];
    [medPriority removeAllObjects];
    [highPriority removeAllObjects];
    for(int i = 0; i < progress.count ; i++)
    {
        if(progress[i].priority == 0)
        {
            [lowPriority addObject:progress[i]];
        }
        else if (progress[i].priority == 1)
        {
            [medPriority addObject:progress[i]];
        }
        else
        {
            [highPriority addObject:progress[i]];
        }
    }
    
}

-(void) editInTheUserDefaults
{
    progressData = [NSKeyedArchiver archivedDataWithRootObject:progress requiringSecureCoding:YES error:nil];
    [defaults setObject:progressData forKey:progressKey];
    [defaults synchronize];
    [self arrangeWithPriorities];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    progressData = [defaults objectForKey:progressKey];
    if(progressData)
    {
        [progress removeAllObjects];
        [progress addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:progressData]];
        [self arrangeWithPriorities];
    }
    UIBarButtonItem * sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortList)];
    self.tabBarController.navigationItem.rightBarButtonItem = sortButton;
    [self.inProgressTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inProgressTable.delegate = self;
    _inProgressTable.dataSource = self;
    
    self.inProgressTable.rowHeight = UITableViewAutomaticDimension;

        
    sections = [[NSMutableArray alloc] initWithObjects:@"Low Priority",@"Meduim Priority", @"High Priority",nil];
    
    progress = [NSMutableArray new];
    
    
    lowPriority = [NSMutableArray new];
    medPriority = [NSMutableArray new];
    highPriority = [NSMutableArray new];
    
    progressData = [NSData new];
    
    defaults = [NSUserDefaults standardUserDefaults];

    progressKey = @"progressKey";
    doneKey = @"doneKey";
    
    isSortedKey = @"isSortedKey";
    [defaults setBool:YES forKey:isSortedKey];
    
    progressData = [defaults objectForKey:progressKey];
}
-(void) sortList
{
    if([defaults boolForKey:isSortedKey])
    {
        [defaults setBool:NO forKey:isSortedKey];
    }
    else
    {
        [defaults setBool:YES forKey:isSortedKey];
    }
    [self.inProgressTable reloadData];
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
            if([self->defaults boolForKey:self->isSortedKey])
            {
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
                [self->progress removeObjectIdenticalTo:list];
                [self editInTheUserDefaults];
                [self arrangeWithPriorities];
                [self.inProgressTable reloadData];
            }
            else
            {
                [self->progress removeObjectAtIndex:indexPath.row];
                [self editInTheUserDefaults];
                [self arrangeWithPriorities];
                [self.inProgressTable reloadData];
            }

        }];
        UIAlertAction * cancle = [UIAlertAction actionWithTitle:@"Cancle" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:ok];
        [alert addAction:cancle];
        [self presentViewController:alert animated:YES completion:NULL];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if([defaults boolForKey:isSortedKey])
    {
        return sections.count;
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([defaults boolForKey:isSortedKey])
    {
        switch (section)
        {
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
    else
    {
        return progress.count ;
    }
    
}
-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([defaults boolForKey:isSortedKey])
    {
        return sections[section];
    }
    else
    {
        return @"unsorted";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FirstCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    if([defaults boolForKey:isSortedKey])
    {
        switch (indexPath.section)
        {
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
    }
    else
    {
        cell.firstCustomCellLabel.text = [[progress objectAtIndex:indexPath.row] name];
        switch ([[progress objectAtIndex:indexPath.row] priority]) {
            case 0:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"1"];
                break;
                
            case 1:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"2"];
                break;
            default:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"3"];
                break;
        }
        /*
        cell.firstCustomCellLabel.text = [[inProgress objectAtIndex:indexPath.row] name];
        List * newlist = [List new];
        newlist = [inProgress objectAtIndex:indexPath.row];
        switch (newlist.priority) {
            case 0:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"1"];
                break;
                
            case 1:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"2"];
                break;
            default:
                cell.firstCustomCellImage.image = [UIImage imageNamed:@"3"];
                break;
         
        }
         */
    }
    cell.firstCustomCellImage.layer.cornerRadius = 30;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingSecondViewController * editingSecondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondEdit"];
    editingSecondVC.editingDelegate = self;
    if([defaults boolForKey:isSortedKey])
    {
        switch (indexPath.section)
        {
            case 0:
                [editingSecondVC setList:lowPriority[indexPath.row]];
                break;
            case 1:
                [editingSecondVC setList:medPriority[indexPath.row]];
                break;
            default:
                [editingSecondVC setList:highPriority[indexPath.row]];
                break;
        }
        [editingSecondVC setSection:indexPath.section];
        [editingSecondVC setRow:indexPath.row];
        [self.navigationController pushViewController:editingSecondVC animated:YES];
    }
    else
    {
        [editingSecondVC setList:progress[indexPath.row]];
        [editingSecondVC setSection:indexPath.section];
        [editingSecondVC setRow:indexPath.row];
        [self.navigationController pushViewController:editingSecondVC animated:YES];
    }
    
}

- (void)editToTheTable:(nonnull List *)list :(NSInteger)section :(NSInteger)row {
    List * tempList = [List new];
    NSData * temp = [NSData new];
    if(list.state == 0)
    {
        if([defaults boolForKey:isSortedKey])
        {
            switch (section) {
                case 0:
                    tempList = [lowPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
                    
                case 1:
                    tempList = [medPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
                    
                default:
                    tempList = [highPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
            }
            [progress addObject:list];
        }
        else
        {
            [progress removeObjectAtIndex:row];
            [progress addObject:list];
        }
    }
    else
    {
        if([defaults boolForKey:isSortedKey])
        {
            switch (section) {
                case 0:
                    tempList = [lowPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
                    
                case 1:
                    tempList = [medPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
                    
                default:
                    tempList = [highPriority objectAtIndex:row];
                    [progress removeObjectIdenticalTo:tempList];
                    break;
            }
        }
        else
        {
            [progress removeObjectAtIndex:row];
        }
        temp = [defaults objectForKey:doneKey];
        list.state = list.state-1;
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
    [self.inProgressTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
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
