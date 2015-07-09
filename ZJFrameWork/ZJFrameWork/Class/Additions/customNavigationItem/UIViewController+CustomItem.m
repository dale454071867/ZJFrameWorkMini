//
//  UIViewController+CustomItem.m
//  FashionAndHealth
//
//  Created by DL on 15/5/11.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import "UIViewController+CustomItem.h"
#import "UIView+ITTAdditions.h"
@implementation UIViewController (CustomItem)
-(CustomBarItem*)setRightButtonNormalImageName:(NSString*)imageName  highlighted:(NSString*)highlightedImage
{
    CustomBarItem *customBarItem = [self.navigationItem setItemWithImage:imageName size:CGSizeMake(40, 40) itemType:right];
    [customBarItem.contentBarItem addTarget:self action:@selector(rightEvent:) forControlEvents:UIControlEventTouchUpInside];
    [customBarItem.contentBarItem setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [customBarItem setOffset:0];
    return customBarItem;
}
-(CustomBarItem*)setRightButtonTitle:(NSString*)title
{
    CustomBarItem *customBarItem = [self.navigationItem setItemWithTitle:title textColor:[UIColor whiteColor] fontSize:18 itemType:right];
    customBarItem.contentBarItem.width = 55;
    [customBarItem addTarget:self selector:@selector(rightEvent:) event:UIControlEventTouchUpInside];
    return customBarItem;
}
-(void)rightEvent:(UIButton*)button
{
    //子类重写
}
-(CustomBarItem*)setLeftButtonNormalImageName:(NSString*)imageName  highlighted:(NSString*)highlightedImage
{
    CustomBarItem *customBarItem = [self.navigationItem setItemWithImage:imageName size:CGSizeMake(40, 40) itemType:left];
    [customBarItem.contentBarItem addTarget:self action:@selector(leftEvent:) forControlEvents:UIControlEventTouchUpInside];
    [customBarItem.contentBarItem setImage:[UIImage imageNamed:highlightedImage] forState:UIControlStateHighlighted];
    [customBarItem setOffset:0];
    return customBarItem;
}
-(CustomBarItem*)setLeftTitle:(NSString*)title
{
    CustomBarItem *customBarItem = [self.navigationItem setItemWithTitle:title textColor:[UIColor blackColor] fontSize:16 itemType:left];
    [customBarItem addTarget:self selector:@selector(leftEvent:) event:UIControlEventTouchUpInside];
    return customBarItem;
}
-(void)leftEvent:(UIButton*)button
{
    //子类重写
}


-(void)setTitle:(NSString *)title
{
    [self createTitleViewWithTitle:title];
}
-(CustomBarItem *)createTitleViewWithTitle:(NSString *)title {
    CustomBarItem *customBarItem = [self.navigationItem setItemWithTitle:title textColor:[UIColor whiteColor] fontSize:22 itemType:center];
    
    return customBarItem;
}
-(CustomBarItem*)setCenterView:(UIView*)centerView
{
    return [self.navigationItem setItemWithCustomView:centerView itemType:center];
    
}

@end
