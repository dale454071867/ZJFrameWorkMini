//
//  MBProgressHUD+ZJAdditions.m
//  ZJFramework
//
//  Created by 周杰 on 15/6/11.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import "MBProgressHUD+ZJAdditions.h"

#define SHOWTITLE @"加载中..."
#define SHOWTIME (2.0f)

@implementation MBProgressHUD (ZJAdditions)
+(void)showHudWithTitle:(NSString*)titleStr showHUDAddedTo:(UIView*)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelText = titleStr;
}
+(void)showTitleHUDAddedTo:(UIView*)view
{
    [self showHudWithTitle:SHOWTITLE showHUDAddedTo:view];
}
+(void)showHUDAddedTo:(UIView *)view
{
    [self showHudWithTitle:nil showHUDAddedTo:view];
}
+(void)showHUDAddedTo:(UIView*)view text:(NSString*)text afterDelay:(NSTimeInterval)timeInt
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:timeInt];
}
+(void)showText:(NSString*)text afterDelay:(NSTimeInterval)timeInt
{
    [self showHUDAddedTo:[UIApplication sharedApplication].delegate.window text:text afterDelay:timeInt];
}
+(void)showText:(NSString*)text
{
    [self showText:text afterDelay:SHOWTIME];
}
+(void)hideHUD
{
    [self hideAllHUDsForView:[UIApplication sharedApplication].delegate.window animated:YES];
}
+(void)hideHUDTo:(UIView*)view
{
    [self hideAllHUDsForView:view animated:YES];
//    [self hideHUDForView:view animated:YES];
}
@end
