//
//  IssueItemViewController.h
//  greedIsland
//
//  Created by 王 on 15/9/10.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IssueItemViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextView *descTV;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end
