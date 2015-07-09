//
//  IKTabBarController.h
//  IKTabBarDemo
//
//  Created by jiejin on 15/5/16.
//  Copyright (c) 2015年 jiejin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IKTabBar.h"

@protocol IKTabBarControllerDelegate;

@interface IKTabBarViewController : UIViewController <IKTabBarDelegate>

// 设置controoler的代理熟悉
@property (nonatomic, weak) id<IKTabBarControllerDelegate> delegate;

// viewController的集合
@property (nonatomic, copy) IBOutletCollection(UIViewController) NSArray *viewControllers;

// viewController的tabBar
@property (nonatomic, readonly) IKTabBar *tabBar;

// 当前选中的viewController
@property (nonatomic, weak) UIViewController *selectedViewController;

// 当前选中的items中对应的项
@property (nonatomic) NSUInteger selectedIndex;

// tabBar是否隐藏属性
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

/**
 @brief tabBar隐藏的方法
 @param hidden tabBar隐藏与否
 @param animated 是否设置动画
 */
- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@protocol IKTabBarControllerDelegate <NSObject>
@optional

/**
 @brief 判断是否是指定的viewController被选中
 @param tabBarController 应用中的tabBarController
 @param viewController 选中的viewController
 */
- (BOOL)tabBarController:(IKTabBarViewController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

/**
 @brief 设置tabBarController中的选中项
 @param tabBarController 应用中的tabBarController
 @param viewController 选中的viewController
 */
- (void)tabBarController:(IKTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController;

@end

@interface UIViewController (IKTabBarControllerItem)

// 当前viewController对应的iktabBarItem
@property(nonatomic, setter = ik_setTabBarItem:) IKTabBarItem *ik_tabBarItem;

// 当前的viewController
@property(nonatomic, readonly) IKTabBarViewController *ik_tabBarController;

@end