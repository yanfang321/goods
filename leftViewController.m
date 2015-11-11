//
//  leftViewController.m
//  greedIsland
//
//  Created by  张艳芳 on 15/9/14.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "leftViewController.h"

@interface leftViewController ()
- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation leftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    _tableView.tableFooterView=[[UIView alloc]init];
    PFUser *currentUser=[PFUser currentUser];
    _usernamelabel.text=currentUser.username;
    _greedcoinlabel.text=[NSString stringWithFormat:@"贪婪币：%@",currentUser[@"greedCoin"]];
   
}
-(void)requestdata
{
    PFQuery *query=[PFUser query];
    [query orderByAscending:@"greedCoin"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *re,NSError *error){
        if (!error) {
            _objectsForShow=re;
            [_tableView reloadData];
        }else
        {
            NSLog(@"error:%@ %@",error,[error userInfo]);
        }
    }];
}
/*viewdidload第一次出现
 viewwillAppear每次出现
 viewDidAppear每次出现
 viewwilldisAppear每次消失
 viewDiddisAppear每次消失*/

-(void)viewWillAppear:(BOOL)animated//
{
    [super viewWillAppear:animated];
    [self requestdata];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objectsForShow.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
   PFUser *user = [_objectsForShow objectAtIndex:indexPath.row];
    cell.textLabel.text =user.username;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", user[@"greedCoin"]];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)logoutAction:(UIButton *)sender forEvent:(UIEvent *)event {
    [PFUser logOut];//parse退出
     [self dismissViewControllerAnimated:YES completion:nil];//点击退出返回首页
}
@end
