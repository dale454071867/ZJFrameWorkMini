//
//  UIViewController+CustomItem.h
//  FashionAndHealth
//
//  Created by DL on 15/5/11.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationItem+CustomItem.h"
@interface UIViewController (CustomItem)
-(CustomBarItem*)setRightButtonNormalImageName:(NSString*)imageName highlighted:(NSString*)highlightedImage;
-(CustomBarItem*)setLeftButtonNormalImageName:(NSString*)imageName  highlighted:(NSString*)highlightedImage;
-(CustomBarItem*)setRightButtonTitle:(NSString*)title;


-(CustomBarItem*)setLeftTitle:(NSString*)title;
-(CustomBarItem*)setCenterView:(UIView*)centerView;
-(CustomBarItem *)createTitleViewWithTitle:(NSString *)title ;

-(void)leftEvent:(UIButton*)button;
-(void)rightEvent:(UIButton*)button;
@end
