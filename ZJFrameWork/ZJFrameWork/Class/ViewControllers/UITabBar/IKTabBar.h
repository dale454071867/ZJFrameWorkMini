//
//  IKTabBar.h
//  IKTabBarDemo
//
//  Created by jiejin on 15/5/16.
//  Copyright (c) 2015年 jiejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IKTabBar, IKTabBarItem;

@protocol IKTabBarDelegate <NSObject>

/**
 @brief 判断是否是指定的item被选中
 @param tabBar 应用中的tabBar
 @param index 选中的项
 */
- (BOOL)tabBar:(IKTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index;

/**
 @brief 设置的item被选中
 @param tabBar 应用中的tabBar
 @param index 选中的项
 */
- (void)tabBar:(IKTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end

@interface IKTabBar : UIView

// 设置代理属性
@property (nonatomic, weak) id <IKTabBarDelegate> delegate;

// IKTabBar对象的集合
@property (nonatomic, copy) NSArray *items;

// 选中的item
@property (nonatomic, weak) IKTabBarItem *selectedItem;

// tabBar的背景图片 只读
@property (nonatomic, readonly) UIView *backgroundView;

// 可调整tabBar的位置
@property UIEdgeInsets contentEdgeInsets;

/**
 @brief 设置tabBar的高度
 @param heiht 设置的高度
 */
- (void)setHeight:(CGFloat)height;

/**
 @brief 返回tabBar中tabBarItem的最小高度
 */
- (CGFloat)minimumContentHeight;

// tabBar是否半透明属性 默认为no
@property (nonatomic, getter=isTranslucent) BOOL translucent;

@end
