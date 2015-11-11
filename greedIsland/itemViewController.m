//
//  itemViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/10.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "itemViewController.h"

@interface itemViewController ()
- (IBAction)buyAction:(UIBarButtonItem *)sender;

@end

@implementation itemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    onLoading = NO;
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = [NSString stringWithFormat:@"贪婪%@", _item[@"name"]];
    
    PFFile *photo = _item[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoIV.image = image;
            });
        }
    }];
    _descTV.text = _item[@"description"];
    
    //市场价
    cost = [_item[@"cost"] floatValue];
    if (cost == 0) {
        _marketLabel.text = @"首次上架贪婪卡";
    } else {
        CGFloat market = [_item[@"cost"] floatValue] + [_item[@"range"] floatValue];
        NSString *marketStr = [Utilities notRounding:market afterPoint:2];
        _marketLabel.text = [NSString stringWithFormat:@"市场价：%@", marketStr];

     //   _marketLabel.text = [NSString stringWithFormat:@"市场价：%@", [Utilities notRounding:([_item[@"cost"] floatValue] + [_item[@"range"] floatValue]) afterPoint:2]];
    }
    _priceLabel.text = [NSString stringWithFormat:@"售价：%@", _item[@"price"]];
    
    PFUser *ownerUser = _item[@"owner"];
    _holderLabel.text = [NSString stringWithFormat:@"持卡人：%@", ownerUser.username];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)buyAction:(UIBarButtonItem *)sender {
    
    NSString *msg = [[NSString alloc]initWithFormat:@"售价: %@\n是否确认支付？", _item[@"price"]];
    UIAlertView *confirmView = [[UIAlertView alloc]initWithTitle:@"购买" message:msg delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [confirmView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (!onLoading) {
            onLoading = YES;
            
            NSNumber *price = _item[@"price"];
            
            _item[@"cost"] =price;//买完之后，当时卖的价格就是现在自己的成本价
            if (cost != 0)/*cost是之前的成本*/ {
                CGFloat range = [_item[@"price"]floatValue] - cost;
                NSString *rangeStr = [Utilities notRounding:range afterPoint:2];
                
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                formatter.numberStyle = NSNumberFormatterDecimalStyle;
                NSNumber *rangeNum = [formatter numberFromString:rangeStr];
                
                _item[@"range"] = rangeNum;
            }
            _item[@"price"] = @0;
            
            PFObject *currentUser = [PFUser currentUser];
            _item[@"owner"] = currentUser;
            
            UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
            //执行保存操作
            [_item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                [aiv stopAnimating];
                    onLoading = NO;
                if (succeeded) {
                    
                    CGFloat currentCoin = [currentUser[@"greedCoin"] floatValue] - [price floatValue];//用户当前贪婪币减去价格
                    NSString *coinStr = [Utilities notRounding:currentCoin afterPoint:2];
                    
                    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                    formatter.numberStyle = NSNumberFormatterDecimalStyle;
                    NSNumber *coinNum = [formatter numberFromString:coinStr];
                    
                    currentUser[@"greedCoin"] = coinNum;
                    [currentUser saveInBackground];
                    
                    //更新前一页列表的数据
                    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshHome" object:self] waitUntilDone:YES];
                    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
                }
            }];

            
        }
        
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
