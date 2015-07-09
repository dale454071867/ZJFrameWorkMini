//
//  IKTabBarItem.h
//  IKTabBarDemo
//
//  Created by jiejin on 15/5/16.
//  Copyright (c) 2015年 jiejin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IKTabBarItem : UIControl

// tabBar的高度 默认即可
@property CGFloat itemHeight;

#pragma mark - Title 设置

// item的文字标题
@property (nonatomic, copy) NSString *title;

// 文字标题的位置偏移量 可通过设置其offset而更改其位置
@property (nonatomic) UIOffset titlePositionAdjustment;

// 未选中状态下的文字标题样式
@property (copy) NSDictionary *unselectedTitleAttributes;

// 选中状态下的文字标题样式
@property (copy) NSDictionary *selectedTitleAttributes;

#pragma mark - Image 设置

// 图片的位置偏移量 可通过设置其offset而更改其位置
@property (nonatomic) UIOffset imagePositionAdjustment;

/**
 @brief 返回选中状态下的图片
 */
- (UIImage *)finishedSelectedImage;

/**
 @brief 返回为选中状态下的图片
 */
- (UIImage *)finishedUnselectedImage;

/**
 @brief 设置item选中和未选中状态的图片
 @param selectedImage 选中状态下的图片
 @param unselectedImage 未选中状态下的图片
 */
- (void)setFinishedSelectedImage:(UIImage *)selectedImage withFinishedUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Background 设置

/**
 @brief 返回选中状态下的背景图片
 */
- (UIImage *)backgroundSelectedImage;

/**
 @brief 返回为选中状态下的背景图片
 */
- (UIImage *)backgroundUnselectedImage;

/**
 @brief 设置选中和未选中状态下的背景图片
 @param selectedImage 选中状态下的背景图片
 @param unselectedImage 未选中状态下的背景图片
 */
- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Badge 设置

// 角标的数值
@property (nonatomic, copy) NSString *badgeValue;

// 角标的背景图片
@property (strong) UIImage *badgeBackgroundImage;

// 角标的背景颜色
@property (strong) UIColor *badgeBackgroundColor;

// 角标的文字颜色
@property (strong) UIColor *badgeTextColor;

// 角标的位置偏移量 可通过设置其offset而更改其位置
@property (nonatomic) UIOffset badgePositionAdjustment;

// 角标的字体大小
@property (nonatomic) UIFont *badgeTextFont;

@end
