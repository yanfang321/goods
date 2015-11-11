//
//  ViewController.h
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIViewControllerAnimatedTransitioning, ECSlidingViewControllerDelegate, ECSlidingViewControllerLayout>//外观

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property(strong,nonatomic)ECSlidingViewController *slidingViewController;
@property(assign,nonatomic)ECSlidingViewControllerOperation operation;//枚举不加星号

@end

