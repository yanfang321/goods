//
//  Utilities.m
//  Utility
//
//  Created by ZIYAO YANG on 15/8/20.
//  Copyright (c) 2015年 Zhong Rui. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (id)getUserDefaults:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setUserDefaults:(NSString *)key content:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeUserDefaults:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getStoryboardInstanceByIdentity:(NSString*)identity
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return [storyboard instantiateViewControllerWithIdentifier:identity];
}

+ (void)popUpAlertViewWithMsg:(NSString *)msg andTitle:(NSString* )title
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title == nil ? @"提示" : title
                                                        message:msg == nil ? @"操作失败" : msg
                                                       delegate:self
                                              cancelButtonTitle:@"确认"
                                              otherButtonTitles:nil];
    [alertView show];
}

//获得保护膜
+ (UIActivityIndicatorView *)getCoverOnView:(UIView *)view {
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aiv.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.4];
    aiv.frame = view.bounds;
    [view addSubview:aiv];
    [aiv startAnimating];
    return aiv;
}

+ (NSString *)notRounding:(float)price afterPoint:(int)position
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
