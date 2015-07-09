//
//  AYTabbarViewController.m
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "AYTabbarViewController.h"
#import "IKTabBarItem.h"
#import "BaseNavigationController.h"

//#import "UserCenterViewController.h"
//#import "SellViewController.h"
//#import "DealViewController.h"
@interface AYTabbarViewController ()

@end

@implementation AYTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *vcNames = @[[UIViewController new],[UIViewController new],[UIViewController new]];
    
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [vcNames count]; i ++){
        
//        id childViewController = [[[vcNames objectAtIndex:i] alloc] init];
        
        BaseNavigationController *naVC = [[BaseNavigationController alloc] initWithRootViewController:vcNames[i]];
        
        [viewControllers addObject:naVC];
    }
    
    [self setViewControllers:viewControllers];
    
    
    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
    NSArray *tabBarItemImages = @[@"交易",@"发布",@"用户中心"];
    NSArray *normalImageArray = [NSArray arrayWithObjects:@"tabBar_1_w",@"tabBar_2_w",@"tabBar_3_w", nil];
    NSArray *selectedImageArray = [NSArray arrayWithObjects:@"tabBar_1_x",@"tabBar_2_x",@"tabBar_3_x",nil];
    
    NSInteger index = 0;
    for (IKTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
        
        [item setFinishedSelectedImage:[UIImage imageNamed:[selectedImageArray objectAtIndex:index]] withFinishedUnselectedImage:[UIImage imageNamed:[normalImageArray objectAtIndex:index]]];
        
        item.title = [tabBarItemImages objectAtIndex:index];
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        
        item.selectedTitleAttributes = @{
                                         NSFontAttributeName: [UIFont systemFontOfSize:12],
                                         NSForegroundColorAttributeName: [UIColor redColor],
                                         };
        item.unselectedTitleAttributes = @{
                                           NSFontAttributeName: [UIFont systemFontOfSize:12],
                                           NSForegroundColorAttributeName: [UIColor blueColor],
                                           };
        
        
        index++;
    }

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

@end
