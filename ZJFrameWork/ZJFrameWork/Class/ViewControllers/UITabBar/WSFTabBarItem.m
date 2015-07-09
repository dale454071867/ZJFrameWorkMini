//
//  WSFTabBarItem.m
//  HospitalNumeralSystem
//
//  Created by 爱康国宾 on 15/1/26.
//  Copyright (c) 2015年 爱康国宾. All rights reserved.
//

#import "WSFTabBarItem.h"
#import <UIKit/UIKit.h>
#import "UIView+ITTAdditions.h"
@implementation WSFTabBarItem

- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString *)name
  selectedImageName:(NSString *)selectedName
          withTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.normalName = name;
        self.selectedName = selectedName;
        
        self.itemImageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - WSFTabBarItemImageWidth)/2, WSFTabBarItemMargin, WSFTabBarItemImageWidth, WSFTabBarItemImageHeight)];
        self.itemImageView.image = [UIImage imageNamed:name];
        self.itemImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.itemImageView];
        
        self.itemTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, self.itemImageView.bottom, self.width, self.height - WSFTabBarItemImageHeight - WSFTabBarItemMargin)];
        self.itemTitle.textAlignment = NSTextAlignmentCenter;
        self.itemTitle.backgroundColor = [UIColor clearColor];
        self.itemTitle.text = title;
        self.itemTitle.font = WSFTabBarItemTitleFont;
        self.itemTitle.textColor = [UIColor whiteColor];
        [self addSubview:self.itemTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.itemTitle.textColor = [UIColor redColor];
        self.itemImageView.image = [UIImage imageNamed:self.selectedName];
    }else {
        self.itemTitle.textColor = [UIColor whiteColor];
        self.itemImageView.image = [UIImage imageNamed:self.normalName];
    }
}

@end
