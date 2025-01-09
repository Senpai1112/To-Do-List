//
//  ThirdUIViewController.m
//  To Do List
//
//  Created by Youssab on 30/12/2024.
//

#import "ThirdUIViewController.h"

@interface ThirdUIViewController ()
{
    NSMutableArray<List*> * done;
    NSMutableArray<List*> * lowPriority;
    NSMutableArray<List*> * medPriority;
    NSMutableArray<List*> * highPriority;

    NSData * doneData;
    
    NSUserDefaults * defaults;
    NSMutableArray * sections;
    
    NSString * doneKey;
    
    NSString * isSortedKey;
}
@property (weak, nonatomic) IBOutlet UITableView *inDoneTable;


@end

@implementation ThirdUIViewController

-(void) arrangeWithPriorities
{
    [lowPriority removeAllObjects];
    [medPriority removeAllObjects];
    [highPriority removeAllObjects];
    for(int i = 0; i < done.count ; i++)
    {
        if(done[i].priority == 0)
        {
            [lowPriority addObject:done[i]];
        }
        else if (done[i].priority == 1)
        {
            [medPriority addObject:done[i]];
        }
        else
        {
            [highPriority addObject:done[i]];
        }
    }
    
}

-(void) editInTheUserDefaults
{
    doneData = [NSKeyedArchiver archivedDataWithRootObject:done requiringSecureCoding:YES error:nil];
    [defaults setObject:doneData forKey:doneKey];
    [defaults synchronize];
    [self arrangeWithPriorities];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    doneData = [defaults objectForKey:doneKey];
    if(doneData)
    {
        [done removeAllObjects];
        [done addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:doneData]];
        [self arrangeWithPriorities];
    }
    UIBarButtonItem * sortButton = [[UIBarButtonItem alloc] initWithTitle:@"Sort" style:UIBarButtonItemStylePlain target:self action:@selector(sortList)];
    self.tabBarController.navigationItem.rightBarButtonItem = sortButton;
    [self.inDoneTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _inDoneTable.delegate = self;
    _inDoneTable.dataSource = self;
    
    self.inDoneTable.rowHeight = UITableViewAutomaticDimension;

        
    sections = [[NSMutableArray alloc] initWithObjects:@"Low Priority",@"Meduim Priority", @"High Priority",nil];
    
    done = [NSMutableArray new];
    
    
    lowPriority = [NSMutableArray new];
    medPriority = [NSMutableArray new];
    highPriority = [NSMutableArray new];
    
    doneData = [NSData new];
    
    defaults = [NSUserDefaults standardUserDefaults];

    doneKey = @"doneKey";
    
    isSortedKey = @"isSortedKey";
    [defaults setBool:YES forKey:isSortedKey];
    
    doneData = [defaults objectForKey:doneKey];
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
                [self->done removeObjectIdenticalTo:list];
                [self editInTheUserDefaults];
                [self arrangeWithPriorities];
                [self.inDoneTable reloadData];
            }
            else
            {
                [self->done removeObjectAtIndex:indexPath.row];
                [self editInTheUserDefaults];
                [self arrangeWithPriorities];
                [self.inDoneTable reloadData];
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
        return done.count ;
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
        cell.firstCustomCellLabel.text = [[done objectAtIndex:indexPath.row] name];
        switch ([[done objectAtIndex:indexPath.row] priority]) {
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
    if([defaults boolForKey:isSortedKey])
    {
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
        [editingThirdVC setSection:indexPath.section];
        [editingThirdVC setRow:indexPath.row];
        [self.navigationController pushViewController:editingThirdVC animated:YES];
    }
    else
    {
        [editingThirdVC setList:done[indexPath.row]];
        [editingThirdVC setSection:indexPath.section];
        [editingThirdVC setRow:indexPath.row];
        [self.navigationController pushViewController:editingThirdVC animated:YES];
    }
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
