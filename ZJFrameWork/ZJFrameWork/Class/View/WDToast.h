//
//  WDToast.h
//  wdalertview
//
//  Created by wang dong on 13-11-22.
//  Copyright (c) 2013年 wang dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef void (^ComplentionBlock)();

@interface WDToast : UIView

@property (copy, nonatomic) ComplentionBlock complentionBlock;

+ (WDToast *)makeText:(NSString *)message withDuration:(CGFloat)duration;
+ (void)makeSunflowerCoverViewWithTitle:(NSString *)title;
+ (void)makeSunflowerCoverView;

- (void)show;
- (void)showWithComplention:(void (^)())complention;
+ (void)makeSunflower;
+ (void)hide;
+ (void)hideWithDelay:(CGFloat)delay duration:(CGFloat)duration;
+ (void)makeSunflowerWithTitle:(NSString *)title;

/*add by cy*/

+ (void)disAppear;
- (void)disAppear;

@end
