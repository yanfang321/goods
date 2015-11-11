//
//  myitemViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/10.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "myitemViewController.h"
#import "MineViewController.h"

@interface myitemViewController ()
- (IBAction)sellAction:(UIButton *)sender forEvent:(UIEvent *)event;

@end

@implementation myitemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = [NSString stringWithFormat:@"贪婪%@", _item[@"name"]];
    
    //设置图片的内容
    PFFile *photo = _item[@"photo"];
    [photo getDataInBackgroundWithBlock:^(NSData *photoData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:photoData];
            dispatch_async(dispatch_get_main_queue(), ^{
                _photoIV.image = image;
            });
        }
    }];
    //设置描述的内容
    _descTV.text = _item[@"description"];
    //
    price = [_item[@"price"] floatValue];
    if (price == 0) {
        _priceLabel.text = @"未上架";
        [_sellButton setTitle:@"上架" forState:UIControlStateNormal];
    } else {
        _priceLabel.text = [NSString stringWithFormat:@"售价：%@", _item[@"price"]];
        [_sellButton setTitle:@"调价" forState:UIControlStateNormal];
    }
    _costLabel.text = [NSString stringWithFormat:@"成本：%@",_item[@"cost"]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//上架按钮
- (IBAction)sellAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    UIAlertView *sellView = [[UIAlertView alloc]initWithTitle:price == 0 ? @"上架" : @"调价" message:@"请输入价格" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [sellView setAlertViewStyle:UIAlertViewStylePlainTextInput];//设置弹出框的样式
    UITextField *textField = [sellView textFieldAtIndex:0];
    if (price != 0) {
        textField.text = [Utilities notRounding:price afterPoint:2];//价格保留两位，四舍五入，然后小数点是零则不显示
        
        
    }
    [sellView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
 
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
    
        if ([textField.text isEqualToString:@""]) {
            [Utilities popUpAlertViewWithMsg:@"请填写价格" andTitle:nil];
            return;//终止该方法，下面的代码不会被执行
        }
        //判断某一个东西是否是数字
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];//得到所有不是数字的字符
        if ([textField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound) /*判断某一个字符串里面不是数字的字符串是否存在*/ {
            //发现不是数字
            [Utilities popUpAlertViewWithMsg:@"无效价格" andTitle:nil];
            return;
        }
        
        //把用户输入的东西转化为数字，  价格
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *priceNum = [formatter numberFromString:textField.text];
        
        if ([priceNum floatValue] < 0) {
            [Utilities popUpAlertViewWithMsg:@"售价不能为负数" andTitle:nil];
            return;
        }
        
        //更新出新的数据
        _item[@"price"] = priceNum;
        
        UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
        [_item saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [aiv stopAnimating];
            if (succeeded) {
                [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:[NSNotification notificationWithName:@"refreshMine" object:self] waitUntilDone:YES];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
            }
        }];
    
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
