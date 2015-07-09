//
//  AccountManager.m
//  anyi
//
//  Created by 周杰 on 15/6/19.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "AccountManager.h"
#import "Utils.h"
#import "CONSTS.h"
@interface AccountManager()
@property(nonatomic,copy)void (^completionBlock)(void);
@end

@implementation AccountManager
//ITTOBJECT_SINGLETON_BOILERPLATE(AccountManager, sharedManager);
+(AccountManager*)sharedManager
{
    static dispatch_once_t onceToken;
    static AccountManager *shareManager;
    dispatch_once(&onceToken, ^{
        shareManager = [[AccountManager alloc] init];
    });
    return shareManager;
}
-(void)setIsLogin:(BOOL)isLogin
{
    _isLogin = isLogin;
    NOTIFY_POST(AY_LOGINSTATECHANGE, nil)
}
-(void)loginCompletion:(void(^)(void))completion
{
    
}
-(void)loginModel:(id)login withAccountInfo:(id)accountInfo
{
    }
-(void)logOut
{

    self.isLogin = NO;
    _accountLoginModel = nil;
}
@end
