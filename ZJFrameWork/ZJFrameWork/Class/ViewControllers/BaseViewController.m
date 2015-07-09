//
//  BaseViewController.m
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "BaseViewController.h"
#import "UIViewController+BHTKeyboardNotifications.h"
#import "AYTabbarViewController.h"
#import "HomeBaseViewController.h"
#import "CONSTS.h"
@interface BaseViewController ()
{
    UIKeyboardViewController *keyBoardController;
}
@property (nonatomic, assign) CGRect keyboardSuperViewOldFrame;
@end

@implementation BaseViewController

//-(instancetype)init
//{
//    if (self = [super init]) {
//      
//    }
//    return self;
//}
- (void)dealloc
{
    NOTIFY_REMOVE(AY_RELOADVIEW, nil);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setKeyBoard];
    if (![self isKindOfClass:[HomeBaseViewController class]]){
        [[self aytabBarController] setTabBarHidden:YES animated:YES];
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self isKindOfClass:[HomeBaseViewController class]]) {
        [[self aytabBarController] setTabBarHidden:NO animated:YES];
    }
}
-(void)setKeyBoard
{
    keyBoardController=[[UIKeyboardViewController alloc] initWithControllerDelegate:self];
}
-(AYTabbarViewController*)aytabBarController
{
    AYTabbarViewController *ayTableVC = (AYTabbarViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;
    return ayTableVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[self aytabBarController] setTabBarHidden:YES];
//      self.navigationController.navigationBar.translucent = NO;
   
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.viewControllers.count>1) {
        [self setLeftButtonNormalImageName:@"back_arrow" highlighted:@"back_arrow_highlighted"];
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [self setGestureBack];
   
    NOTIFY_REGISTER(AY_RELOADVIEW, reloadSelfView);
    // Do any additional setup after loading the view.
}

-(void)reloadSelfView:(NSNotification*)notification
{
    
}

//设置手势返回
-(void)setGestureBack
{
    self.isCanGestureRecognizerBack = YES;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0f) {
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}
//默认返回按钮
-(void)leftEvent:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}
//轻拍view
-(void)tapOfView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoader)];
    [self.view addGestureRecognizer:tap];
}
-(void)hideKeyBoader
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self hideKeyBoader];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTitle:(NSString *)title
{
    [self createTitleViewWithTitle:title];
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
