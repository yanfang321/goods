//
//  RegisterViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()
- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//键盘点击空白回收
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (IBAction)signupAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _usernameTF.text;
    NSString *email = _emailTF.text;
    NSString *password = _passwordTF.text;
    NSString *confirmPwd = _confirmPwdTF.text;
    
    if ([username isEqualToString:@""] || [email isEqualToString:@""] || [password isEqualToString:@""] || [confirmPwd isEqualToString:@""] ) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
    
    if (![password isEqualToString:confirmPwd]) {
        [Utilities popUpAlertViewWithMsg:@"确认密码必须与密码保持一致" andTitle:nil];
    }
    
    //创建用户
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = email;
    user[@"greedCoin"] = @10000;
    
//    //增加一个保护膜
//    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    aiv.frame = self.view.bounds;
//    [self.view addSubview:aiv];
//    [aiv startAnimating];
    
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    //把创建的用户插入数据库
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [aiv stopAnimating];//菊花停止转动
        if (!error) {
            [Utilities setUserDefaults:@"userName" content:username];
            [[storageMgr singletonStorageMgr] addKeyAndValue:@"signUp" And:@1];
            [self.navigationController popViewControllerAnimated:YES];
//            [[storageMgr singletonStorageMgr]addKeyAndValue:@"signup" And:@1];//注册成功后，在单例化全局变量中插入键值对，是1就跳转，跳转到首页
        } else if (error.code == 202) {
            [Utilities popUpAlertViewWithMsg:@"该用户名已被使用，请尝试其它名称" andTitle:nil];
        } else if (error.code == 203) {
            [Utilities popUpAlertViewWithMsg:@"该电子邮箱已被使用，请尝试其它名称" andTitle:nil];
        } else if (error.code == 125) {
            [Utilities popUpAlertViewWithMsg:@"该邮箱地址为非法地址" andTitle:nil];
        }else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
    
    
   // [self.navigationController popViewControllerAnimated:YES];//注册成功后跳转登陆页面
    
}
@end
