//
//  itemViewController.h
//  greedIsland
//
//  Created by 王 on 15/9/10.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface itemViewController : UIViewController
{
    CGFloat cost;
    BOOL onLoading;
}

@property (strong, nonatomic) PFObject *item;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UITextView *descTV;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *holderLabel;


@end
