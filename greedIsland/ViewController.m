//
//  ViewController.m
//  greedIsland
//
//  Created by 王 on 15/9/9.
//  Copyright (c) 2015年 王. All rights reserved.
//

#import "ViewController.h"
#import "TabViewController.h"
#import "leftViewController.h"
@interface ViewController ()

- (IBAction)signinAction:(UIButton *)sender forEvent:(UIEvent *)event;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (![[Utilities getUserDefaults:@"userName"] isKindOfClass:[NSNull class]]) {
        _usernameTF.text = [Utilities getUserDefaults:@"userName"];
    }
}

//存在时  检查指针是否存在，
- (void)viewDidAppear:(BOOL)animated {
  
    [self viewWillAppear:animated];
    if ([[[storageMgr singletonStorageMgr] objectForKey:@"signup"] integerValue] == 1) {
        [[storageMgr singletonStorageMgr]removeObjectForKey:@"signup"];//恢复成判断之前的页面
        [self popUpHomePage];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//跳转到Home页的方法
- (void)popUpHomePage
{
    
    TabViewController *tabVC = [Utilities getStoryboardInstanceByIdentity:@"Tab"];
    UINavigationController* naviVC = [[UINavigationController alloc] initWithRootViewController:tabVC];//创建一个导航控制器
    naviVC.navigationBarHidden = YES;
   
    _slidingViewController=[ECSlidingViewController slidingWithTopViewController:naviVC];//初始化并设置popview（中间页面）
    _slidingViewController.delegate=self;//初始化

//    _slidingViewController.defaultTransitionDuration = 0.25;//    滑动动画默认时间又过协议就不要
    _slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;//触摸和拖动
    [naviVC.view addGestureRecognizer:self.slidingViewController.panGesture];
    leftViewController *leftVC = [Utilities getStoryboardInstanceByIdentity:@"left"];
    _slidingViewController.underLeftViewController = leftVC;//设置作画试图
    _slidingViewController.anchorRightPeekAmount = UI_SCREEN_W / 4;//划到什么位置anchorRightPeekAmount当画出左侧菜单式中间页面左边到屏幕右边的距离anchorleftPeekAmount当画出右侧页面时中间页面右边到屏幕左边的距离

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftSwitchAction) name:@"leftSwitch" object:nil];//通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enablePanGesOnSliding) name:@"enablePanGes" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disablePanGesOnSliding) name:@"disablePanGes" object:nil];
//     [self presentViewController:naviVC animated:YES completion:nil];//Model过去
    [self presentViewController:_slidingViewController animated:YES completion:nil];//Model过去

}
//打开或关闭侧滑的页面
- (void)leftSwitchAction {
    if (_slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
        [_slidingViewController resetTopViewAnimated:YES];
    } else {
        [_slidingViewController anchorTopViewToRightAnimated:YES];
    }
}
- (void)enablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = YES;
}//手势激活

- (void)disablePanGesOnSliding {
    _slidingViewController.panGesture.enabled = NO;
}//手势关闭

#pragma mark - ECSlidingViewControllerDelegate和其他两个协议关联

- (id<UIViewControllerAnimatedTransitioning>)slidingViewController:(ECSlidingViewController *)slidingViewController animationControllerForOperation:(ECSlidingViewControllerOperation)operation topViewController:(UIViewController *)topViewController {//当你做某个操作时返回一些动画效果
   _operation = operation;
    return self;
}

- (id<ECSlidingViewControllerLayout>)slidingViewController:(ECSlidingViewController *)slidingViewController layoutControllerForTopViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {//
    return self;
}
#pragma mark - ECSlidingViewControllerLayout

- (CGRect)slidingViewController:(ECSlidingViewController *)slidingViewController frameForViewController:(UIViewController *)viewController topViewPosition:(ECSlidingViewControllerTopViewPosition)topViewPosition {
    if (topViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight && viewController == slidingViewController.topViewController) {
        return [self topViewAnchoredRightFrame:slidingViewController];
    } else {
        return CGRectInfinite;
    }
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;//动画时间
}
//页与页动画转换
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *topViewController = [transitionContext viewControllerForKey:ECTransitionContextTopViewControllerKey];
    UIViewController *underLeftViewController  = [transitionContext viewControllerForKey:ECTransitionContextUnderLeftControllerKey];
    UIView *containerView = [transitionContext containerView];
    
    UIView *topView = topViewController.view;
    topView.frame = containerView.bounds;
    underLeftViewController.view.layer.transform = CATransform3DIdentity;
    
    if (_operation == ECSlidingViewControllerOperationAnchorRight) {
        [containerView insertSubview:underLeftViewController.view belowSubview:topView];
        
        [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewEndState:underLeftViewController.view];
            [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext finalFrameForViewController:topViewController]];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                underLeftViewController.view.frame = [transitionContext finalFrameForViewController:underLeftViewController];
                underLeftViewController.view.alpha = 1;
                [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
            }
            [transitionContext completeTransition:finished];
        }];
    } else if (_operation == ECSlidingViewControllerOperationResetFromRight) {
        [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
        [self underLeftViewEndState:underLeftViewController.view];
        
        NSTimeInterval duration = [self transitionDuration:transitionContext];
        [UIView animateWithDuration:duration animations:^{
            [self underLeftViewStartingState:underLeftViewController.view containerFrame:containerView.bounds];
            [self topViewStartingStateLeft:topView containerFrame:containerView.bounds];
        } completion:^(BOOL finished) {
            if ([transitionContext transitionWasCancelled]) {
                [self underLeftViewEndState:underLeftViewController.view];
                [self topViewAnchorRightEndState:topView anchoredFrame:[transitionContext initialFrameForViewController:topViewController]];
            } else {
                underLeftViewController.view.alpha = 1;
                underLeftViewController.view.layer.transform = CATransform3DIdentity;
                [underLeftViewController.view removeFromSuperview];
            }
            [transitionContext completeTransition:finished];
        }];
    }
}


#pragma mark - Private私有方法

- (CGRect)topViewAnchoredRightFrame:(ECSlidingViewController *)slidingViewController {
    CGRect frame = slidingViewController.view.bounds;
    
    frame.origin.x = slidingViewController.anchorRightRevealAmount;
    frame.size.width = frame.size.width * 0.75;
    frame.size.height = frame.size.height * 0.75;
    frame.origin.y = (slidingViewController.view.bounds.size.height - frame.size.height) / 2;
    
    return frame;
}
- (void)topViewStartingStateLeft:(UIView *)topView containerFrame:(CGRect)containerFrame {
    topView.layer.transform = CATransform3DIdentity;
    topView.layer.position = CGPointMake(containerFrame.size.width / 2, containerFrame.size.height / 2);
}

- (void)underLeftViewStartingState:(UIView *)underLeftView containerFrame:(CGRect)containerFrame {
    underLeftView.alpha = 0;
    underLeftView.frame = containerFrame;
    underLeftView.layer.transform = CATransform3DMakeScale(1.25, 1.25, 1);
}

- (void)underLeftViewEndState:(UIView *)underLeftView {
    underLeftView.alpha = 1;
    underLeftView.layer.transform = CATransform3DIdentity;
}

- (void)topViewAnchorRightEndState:(UIView *)topView anchoredFrame:(CGRect)anchoredFrame {
    topView.layer.transform = CATransform3DMakeScale(0.75, 0.75, 1);
    topView.frame = anchoredFrame;
    topView.layer.position  = CGPointMake(anchoredFrame.origin.x + ((topView.layer.bounds.size.width * 0.75) / 2), topView.layer.position.y);
}
- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
//键盘点击空白回收
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


- (IBAction)signinAction:(UIButton *)sender forEvent:(UIEvent *)event {
    
    NSString *username = _usernameTF.text;
    NSString *password = _passwordTF.text;
    
    if ([username isEqualToString:@""] || [password isEqualToString:@""]) {
        [Utilities popUpAlertViewWithMsg:@"请填写所有信息" andTitle:nil];
        return;
    }
//    
//    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    aiv.frame = self.view.bounds;
//    [self.view addSubview:aiv];
//    [aiv startAnimating];
    
    //调用菊花
    UIActivityIndicatorView *aiv = [Utilities getCoverOnView:self.view];
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        [aiv stopAnimating];
        if (user) {
            [Utilities setUserDefaults:@"userName" content:username];
     //       _usernameTF.text = @"";
            _passwordTF.text = @"";//用户退出后，首页的textfield为空
            [self popUpHomePage];
        } else if (error.code == 101) {
            [Utilities popUpAlertViewWithMsg:@"用户名或密码错误" andTitle:nil];
        } else if (error.code == 100) {
            [Utilities popUpAlertViewWithMsg:@"网络不给力，请稍后再试" andTitle:nil];
        } else {
            [Utilities popUpAlertViewWithMsg:nil andTitle:nil];
        }
    }];
   // [self popUpHomePage];
}
@end
