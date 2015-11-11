//
//  HomeViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "HomeViewController.h"
#import "itemViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //   onloading = NO;
    [self uiConfiguration];
    _tableView.tableFooterView = [[UIView alloc] init]; //去掉多余的tableView下划线
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestData) name:@"refreshHome" object:nil];//通知
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestData {
    PFUser *currentUser = [PFUser currentUser];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"price != 0 AND owner != %@", currentUser];// 查询owner字段为当前用户的所有商品
    PFQuery *query = [PFQuery queryWithClassName:@"Item" predicate:predicate];
    
    [query includeKey:@"owner"];//提取关联字段
    [query orderByDescending:@"price"];//排序，从高到低
    
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"售价：%@", object[@"price"]];
    
    return cell;
}

//取消选择行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"Item"]) {
        PFObject *object = [_objectsForShow objectAtIndex:[_tableView indexPathForSelectedRow].row];//获得当前tablview选中行的数据
        itemViewController *miVC = segue.destinationViewController;//目的地视图控制器
        miVC.item = object;
        miVC.hidesBottomBarWhenPushed = YES;//把切换按钮隐藏掉
    }
    
}

/*下拉刷新*/
-(void)uiConfiguration
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    NSString *title = [NSString stringWithFormat:@"下拉即可刷新"];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSDictionary *attrsDictionary = @{NSUnderlineStyleAttributeName:
                                          @(NSUnderlineStyleNone),
                                      NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                      NSParagraphStyleAttributeName:style,
                                      NSForegroundColorAttributeName:[UIColor brownColor]};
    
    
    NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
    refreshControl.attributedTitle = attributedTitle;
    //tintColor旋转的小花的颜色
    refreshControl.tintColor = [UIColor brownColor];
    //背景色 浅灰色
    refreshControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
    //执行的动作
    [refreshControl addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
    [_tableView addSubview:refreshControl];
}
- (void)refreshData:(UIRefreshControl *)rc
{
    [_tableView reloadData];
    //怎么样让方法延迟执行的
    [self performSelector:@selector(endRefreshing:) withObject:rc afterDelay:1.f];
}
//闭合
- (void)endRefreshing:(UIRefreshControl *)rc {
    [rc endRefreshing];//闭合
}
- (IBAction)menuAction:(UIBarButtonItem *)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"leftSwitch" object:self];
}
//加载消失时执行
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"enablePanGes" object:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"disablePanGes" object:self];
}
@end



