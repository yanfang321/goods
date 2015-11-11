//
//  MineViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "MineViewController.h"
#import "myitemViewController.h"

@interface MineViewController ()

- (IBAction)addAction:(UIBarButtonItem *)sender;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 //   onloading = NO;
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshMine" object:nil];//通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addAction:(UIBarButtonItem *)sender {
   // [self performSegueWithIdentifier:@"Add" sender:self];
    
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner == %@", currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            if (count < 5) {
                [self performSegueWithIdentifier:@"Add" sender:self];
            } else {
                [Utilities popUpAlertViewWithMsg:@"您当前的贪婪卡张数已达到上限" andTitle:nil];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)requestData {
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"owner == %@", currentUser];// 查询owner字段为当前用户的所有商品
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    [query findObjectsInBackgroundWithBlock:^(NSArray *returnedObjects, NSError *error) {
        [aiv stopAnimating];
        if (!error) {
            _objectsForShow = returnedObjects;
            NSLog(@"%@", _objectsForShow);
            [_tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

//返回tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];//复用Cell
    
    PFObject *object = [_objectsForShow objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"贪婪%@", object[@"name"]];
    NSInteger price = [object[@"price"] integerValue];
    if (price == 0) {
        cell.detailTextLabel.text = @"未上架";
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"售价：%@", object[@"price"]];
    }
    
    return cell;
}

//取消选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     
     if ([segue.identifier isEqualToString:@"MyItem"]) {
         PFObject *object = [_objectsForShow objectAtIndex:[_tableView indexPathForSelectedRow].row];//获得当前tablview选中行的数据
         myitemViewController *miVC = segue.destinationViewController;//目的地视图控制器
         miVC.item = object;
         miVC.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
     }
     
 }



@end
