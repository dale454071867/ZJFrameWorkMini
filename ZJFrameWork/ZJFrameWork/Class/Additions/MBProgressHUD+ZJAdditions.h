//
//  MBProgressHUD+ZJAdditions.h
//  ZJFramework
//
//  Created by 周杰 on 15/6/11.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (ZJAdditions)
+(void)showHudWithTitle:(NSString*)titleStr showHUDAddedTo:(UIView*)view;
+(void)showTitleHUDAddedTo:(UIView*)view;
+(void)showHUDAddedTo:(UIView *)view;
+(void)showHUDAddedTo:(UIView*)view text:(NSString*)text afterDelay:(NSTimeInterval)timeInt;
+(void)showText:(NSString*)text afterDelay:(NSTimeInterval)timeInt;
+(void)showText:(NSString*)text;
+(void)hideHUD;
+(void)hideHUDTo:(UIView*)view;
@end
