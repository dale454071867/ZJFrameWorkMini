//
//  BaseNavigationController.m
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "BaseNavigationController.h"
#import "BaseViewController.h"
#import "UIColor-Expanded.h"
@interface BaseNavigationController ()<UIGestureRecognizerDelegate>
@property(nonatomic,assign)BOOL isCanGestureRecognizerBack;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorWithHex:0x4c4969 alpha:1];
    self.interactivePopGestureRecognizer.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else if(self.isCanGestureRecognizerBack)
    {
        return YES;
    }else
    {
        return NO;
    }
}

-(BOOL)isCanGestureRecognizerBack
{
    UIViewController *viewController =  [self.viewControllers lastObject];
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        return ((BaseViewController*)viewController).isCanGestureRecognizerBack;
    }else
    {
        return NO;
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
