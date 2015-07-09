//
//  UIView+Masonry.h
//  ZJFramework
//
//  Created by DL on 15/4/21.
//  Copyright (c) 2015年 DL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Masonry)
//横向均分
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;
//纵向均分
- (void) distributeSpacingVerticallyWith:(NSArray*)views;
@end
