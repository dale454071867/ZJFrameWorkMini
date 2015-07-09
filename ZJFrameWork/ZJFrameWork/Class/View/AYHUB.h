//
//  AYHUB.h
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD+ZJAdditions.h"
#import "UIView+Toast.h"
@interface AYHUB : NSObject
+(void)showHUDAddedTo:(UIView*)view;
+(void)hideHudTo:(UIView*)view;
+(void)showText:(NSString*)text;
@end
