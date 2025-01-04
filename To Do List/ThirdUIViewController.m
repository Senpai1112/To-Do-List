//
//  ThirdUIViewController.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "ThirdUIViewController.h"

@interface ThirdUIViewController ()
{
    NSMutableArray * lowPriority;
    NSMutableArray * medPriority;
    NSMutableArray * highPriority;
    NSMutableArray * inProgress;
    List * list;
    
    NSData * lowPriorityData;
    NSData * medPriorityData;
    NSData * highPriorityData;
    NSData * inProgressData;
    NSData * listData;
    
    NSUserDefaults * defaults;
    NSMutableArray * sections;
    
    NSString * lowPriorityKey;
    NSString * medPriorityKey;
    NSString * highPriorityKey;
    NSString * isSortedKey;
    
    NSString * inDoneKey;
    NSString * inDoneListKey;
}
@property (weak, nonatomic) IBOutlet UITableView *inDoneTable;


@end

@implementation ThirdUIViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    lowPriorityData = [defaults objectForKey:lowPriorityKey];
    medPriorityData = [defaults objectForKey:medPriorityKey];
    highPriorityData = [defaults objectForKey:highPriorityKey];
    
    inProgressData = [defaults objectForKey:inDoneKey];
    listData = [defaults objectForKey:inDoneListKey];
    
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
    if(inProgressData)
    {
        inProgress = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
    }
    if(listData)
    {
        list = [NSKeyedUnarchiver unarchiveObjectWithData:listData];
    }
    if([defaults boolForKey:@"isThirdEdited"])
    {
        NSData * temp = [NSData new];
        [inProgress addObject:list];

        switch (list.priority)
            {
                case 0:
                    [lowPriority addObject:list];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:lowPriority requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:lowPriorityKey];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:inProgress requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:inDoneKey];
                    [defaults synchronize];
                    break;
                    
                case 1 :
                    [medPriority addObject:list];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:medPriority requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:medPriorityKey];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:inProgress requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:inDoneKey];
                    [defaults synchronize];
                    break;
                case 2:
                    [highPriority addObject:list];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:highPriority requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:highPriorityKey];
                    temp = [NSKeyedArchiver archivedDataWithRootObject:inProgress requiringSecureCoding:YES error:nil];
                    [defaults setObject:temp forKey:inDoneKey];
                    [defaults synchronize];
            }
        [defaults removeObjectForKey:inDoneListKey];
        [self.inDoneTable reloadData];
    }
    [defaults setBool:NO forKey:@"isThirdEdited"];
    UIBarButtonItem * sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortList)];
    self.tabBarController.navigationItem.rightBarButtonItem = sortButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  80;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inDoneTable.delegate = self;
    _inDoneTable.dataSource = self;
    
    self.inDoneTable.rowHeight = UITableViewAutomaticDimension;
    self.inDoneTable.estimatedRowHeight = UITableViewAutomaticDimension;
    
    list = [List new];
        
    sections = [[NSMutableArray alloc] initWithObjects:@"Low Priority",@"Meduim Priority", @"High Priority",nil];
    
    lowPriority = [NSMutableArray new];
    medPriority = [NSMutableArray new];
    highPriority = [NSMutableArray new];
    inProgress = [NSMutableArray new];
    
    lowPriorityData = [NSData new];
    medPriorityData = [NSData new];
    highPriorityData = [NSData new];
    inProgressData = [NSData new];
    listData = [NSData new];
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    lowPriorityKey = @"lowPriorityThirdKey";
    medPriorityKey = @"medPriorityThirdKey";
    highPriorityKey = @"highPriorityThirdKey";
    
    inDoneKey = @"inDoneKey";
    inDoneListKey =@"inDoneListKey";
    
    isSortedKey = @"isSortedThirdKey";
    [defaults setBool:YES forKey:isSortedKey];
    
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
    [self.inDoneTable reloadData];
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
    else
    {
        return (lowPriority.count + medPriority.count + highPriority.count) ;
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
        return @"";
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
    }
    cell.firstCustomCellImage.layer.cornerRadius = 30;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditingThirdViewController * editingThirdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdEdit"];
    editingThirdVC.editingDelegate = self;
    switch (indexPath.section)
    {
        case 0:
            [editingThirdVC setList:lowPriority[indexPath.row]];
            break;
        case 1:
            [editingThirdVC setList:medPriority[indexPath.row]];
            break;
        default:
            [editingThirdVC setList:highPriority[indexPath.row]];
            break;
    }
    [editingThirdVC setRow:indexPath.row];
    [editingThirdVC setSection:indexPath.section];
    [self.navigationController pushViewController:editingThirdVC animated:YES];
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
        [self.inDoneTable reloadData];
    }
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
