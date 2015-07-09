//
//  WSFTabBarItem.h
//  HospitalNumeralSystem
//
//  Created by 爱康国宾 on 15/1/26.
//  Copyright (c) 2015年 爱康国宾. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WSFTabBarItemImageWidth                      20
#define WSFTabBarItemImageHeight                     20
#define WSFTabBarItemMargin                          5
#define WSFTabBarItemTitleFont                       [UIFont systemFontOfSize:13]
#define WSFTabBarItemTitleSelectedColor              [UIColor colorWithHex:0x15b6c3 alpha:1]

@interface WSFTabBarItem : UIControl

- (id)initWithFrame:(CGRect)frame
    normalImageName:(NSString *)name
  selectedImageName:(NSString *)selectedName
          withTitle:(NSString *)title;

@property (nonatomic, strong) UIImageView *itemImageView;
@property (nonatomic, strong) UILabel *itemTitle;
@property (nonatomic, strong) NSString *normalName;
@property (nonatomic, strong) NSString *selectedName;

@end
