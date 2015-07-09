//
//  UIImage+UIImageExt.h
//  cinema
//
//  Created by DL on 13-12-12.
//  Copyright (c) 2013年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageExt)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
