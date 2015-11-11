//
//  HomeViewController.h
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
- (IBAction)menuAction:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *objectsForShow;
@end
