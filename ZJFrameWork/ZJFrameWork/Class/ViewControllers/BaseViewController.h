//
//  BaseViewController.h
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CustomItem.h"
#import "BaseNavigationController.h"
#import "UIKeyboardViewController.h"
#import  "AYTabbarViewController.h"
@interface BaseViewController : UIViewController<UIKeyboardViewControllerDelegate>
@property(nonatomic,assign)BOOL isCanGestureRecognizerBack ;

/**
 *  键盘上toolBar的高度
 */
@property (nonatomic, assign) CGFloat toolBarHeight;
/**
 *  textField 高于键盘的高度
 */
@property (nonatomic, assign) CGFloat higherThanKeyboard;

-(AYTabbarViewController*)aytabBarController;
-(void)tapOfView;
@end
