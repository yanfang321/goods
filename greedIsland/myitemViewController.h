//
//  myitemViewController.h
//  greedIsland
//
//  Created by 王 on 15/9/10.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface myitemViewController : UIViewController {
    CGFloat price;
}
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UITextView *descTV;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sellButton;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;

@property (strong, nonatomic) PFObject *item;

@end
