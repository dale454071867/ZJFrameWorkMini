//
//  ITTXibView.m
//  iTotemFrame
//
//  Created by jack 廉洁 on 3/9/12.
//  Copyright (c) 2012 iTotemStudio. All rights reserved.
//

#import "ITTXibView.h"
#import "ITTXibViewUtils.h"
#import "ITTDebug.h"

@implementation ITTXibView

- (void)dealloc
{
    ITTDINFO(@"%@ is dealloced!", [self class]);
}

+ (id)loadFromXib
{
    id view = [ITTXibViewUtils loadViewFromXibNamed:NSStringFromClass([self class])];
//    [view initRun];
    return view;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
         [self initRun];
    }
    return self;
}
-(instancetype)init
{
    if (self = [super init]) {
         [self initRun];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initRun];
    }
    return self;
}
-(void)initRun
{
    
}
@end
