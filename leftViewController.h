//
//  leftViewController.h
//  greedIsland
//
//  Created by  张艳芳 on 15/9/14.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface leftViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernamelabel;
@property (weak, nonatomic) IBOutlet UILabel *greedcoinlabel;
@property (strong,nonatomic)NSArray *objectsForShow;


@end
