//
//  AYHUB.m
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "AYHUB.h"
#import "MBProgressHUD+ZJAdditions.h"
@implementation AYHUB
+(void)showHUDAddedTo:(UIView*)view
{
    [MBProgressHUD showHUDAddedTo:view];
}
+(void)hideHudTo:(UIView*)view
{
    [MBProgressHUD hideHUDTo:view];
}
+(void)showText:(NSString*)text
{
//    [MBProgressHUD showText:text];
    [[UIApplication sharedApplication].delegate.window makeToast:text];
}
@end
