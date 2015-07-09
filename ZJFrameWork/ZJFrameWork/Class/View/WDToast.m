//
//  WDToast.m
//  wdalertview
//
//  Created by wang dong on 13-11-22.
//  Copyright (c) 2013年 wang dong. All rights reserved.
//

#import "WDToast.h"
#import "AppDelegate.h"
#import "UIView+ITTAdditions.h"
@interface WDToast()
{
    float _duration;
}

@property (strong, nonatomic) UILabel *messageLabel;
@property (strong, nonatomic) CAKeyframeAnimation *showAnimation;
@property (assign, nonatomic) BOOL isSunflower;
@property (assign, nonatomic) BOOL showCover;
@property (strong, nonatomic) NSString *message;

@end

@implementation WDToast

+ (WDToast *)makeText:(NSString *)message withDuration:(CGFloat)duration
{
    WDToast *toast = [[WDToast alloc] initWithMessage:message duration:duration];
    toast.tag = 800;
    
    toast.backgroundColor = [UIColor grayColor];
    toast.alpha = 0.8;
    toast.layer.cornerRadius = 8;
    toast.layer.masksToBounds = YES;
    return toast;
}

- (void)showWithComplention:(void (^)())complention
{
    self.complentionBlock = complention;
    [self show];
}

+ (WDToast *)createToast
{
    WDToast *toast = [[WDToast alloc] init];
    toast.tag = 800;
    toast.backgroundColor = [UIColor grayColor];
    toast.alpha = 0.8;
    toast.layer.cornerRadius = 8;
    toast.layer.masksToBounds = YES;
    return toast;
}

+ (void)makeSunflowerCoverViewWithTitle:(NSString *)title
{
    WDToast *toast = [WDToast createToast];
    toast.message = title;
    toast.isSunflower = YES;
    toast.showCover = YES;
    [toast show];
}

+ (void)makeSunflowerWithTitle:(NSString *)title
{
    WDToast *toast = [WDToast createToast];
    toast.message = title;
    toast.isSunflower = YES;
    [toast show];
}

+ (void)makeSunflowerCoverView
{
    [WDToast makeSunflowerCoverViewWithTitle:@"    加载中..."];
}

+ (void)makeSunflower
{
    [WDToast makeSunflowerWithTitle:@"    加载中..."];
}

+ (void)hide
{
    [WDToast hideWithDelay:0 duration:0];
}

+ (void)hideWithDelay:(CGFloat)delay duration:(CGFloat)duration
{
    NSArray *array  =[UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    UIView *view = nil;
    view = [window viewWithTag:800];
    
    if (view) {
        NSAssert([view isKindOfClass:[WDToast class]], @"tag重复了!");
        if (view) {
            [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionTransitionNone animations:^{
                view.alpha = 0.f;
                view.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
            } completion:^(BOOL finished) {
                [WDToast hideCoverView];
                [view removeFromSuperview];
            }];
        }
    }
}

+ (void)disAppear
{
    NSArray *array  =[UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    UIView *view = nil;
    view = [window viewWithTag:800];
    [view removeFromSuperview];
    [WDToast hideCoverView];
}

- (void)disAppear
{
    [WDToast disAppear];
}

- (id)initWithMessage:(NSString *)message duration:(float)duration
{
    if (self = [super init]) {
        _message = message;
        _duration = duration;
    }
    return self;
}

- (void)show
{
    
    NSArray *array  =[UIApplication sharedApplication].windows;

    UIWindow *window = [array objectAtIndex:0];

    
    if ([window viewWithTag:800]) {
        return;
    }
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.text = _message;
    _messageLabel.font = [UIFont boldSystemFontOfSize:13.f];
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.f];
    
    CGSize size = [_message sizeWithAttributes:@{NSAttachmentAttributeName:font}];
    
    if (size.width > 260.f) {
        _messageLabel.numberOfLines = 2;
        _messageLabel.bounds = CGRectMake(0, 0, 250, 17 * 2);
    } else {
        [_messageLabel sizeToFit];
    }
    
    self.frame = _messageLabel.bounds;
    
    float spaceHeight = 20.f;
    
    if (_isSunflower) {
        spaceHeight = 40;
    }
    
    self.frame = CGRectMake(0, 0, _messageLabel.bounds.size.width + 60, _messageLabel.bounds.size.height + spaceHeight);
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    self.center = CGPointMake(bounds.size.width / 2, bounds.size.height / 2);
    
    float topPadding = 3.f;
    
    float leftPadding = 3.f;
    
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, topPadding, self.frame.size.width - leftPadding * 2, self.frame.size.height - topPadding * 2)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.8;
    [self addSubview:blackView];
    
    if (_isSunflower) {
        UIActivityIndicatorView *asshole = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        asshole.centerX = blackView.centerX;
        asshole.centerY = blackView.centerY - 12;
        [blackView addSubview:asshole];
        [asshole startAnimating];
        _messageLabel.center = CGPointMake(blackView.centerX, blackView.centerY + 10);
    } else {
        _messageLabel.center = blackView.center;
    }
    
    blackView.layer.cornerRadius = 8;
    blackView.layer.masksToBounds = YES;
    [self addSubview:_messageLabel];
    
    [window addSubview:self];
    if (_showCover) {
        [self showCoverView];
    }
    
    _showAnimation = [self showAnimation];
    
    [self.layer addAnimation:_showAnimation forKey:nil];
}

- (CAKeyframeAnimation *)showAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.delegate = self;
    [animation setDuration:0.3];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSNumber numberWithFloat:0.4]];
    [values addObject:[NSNumber numberWithFloat:1.2]];
    [values addObject:[NSNumber numberWithFloat:1]];
    [animation setValues:values];
    [animation setDelegate:self];
    return animation;
}

- (void)hide
{
    NSArray *array  =[UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    UIView *view = nil;
    view = [window viewWithTag:800];
    
    if (view) {
        NSAssert([view isKindOfClass:[WDToast class]], @"tag重复了!");
        [UIView animateWithDuration:0.3 animations:^{
            view.alpha = 0.f;
            view.layer.transform = CATransform3DMakeScale(0.5f, 0.5f, 1.f);
        } completion:^(BOOL finished) {
            [WDToast hideCoverView];
            if (_complentionBlock) {
                _complentionBlock();
            }
            [view removeFromSuperview];
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_duration > 0) {
        [self performSelector:@selector(hide) withObject:nil afterDelay:_duration];
    }
}

- (void)showCoverView
{
    NSArray *array  =[UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, window.width, window.height)];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.2;
    view.tag = 805;
    [window addSubview:view];
}

+ (void)hideCoverView
{
    NSArray *array  =[UIApplication sharedApplication].windows;
    UIWindow *window = [array objectAtIndex:0];
    UIView *view = nil;
    
    view = [window viewWithTag:805];
    if (view) {
        [view removeFromSuperview];
    }
}

@end
