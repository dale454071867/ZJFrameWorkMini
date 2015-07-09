//
//  AccountManager.h
//  anyi
//
//  Created by 周杰 on 15/6/19.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ITTObjectSingleton.h"
#import "Account.h"
#import "AccountLoginModel.h"
/**
 *  管理用户中心
 */
@interface AccountManager : NSObject
@property(nonatomic,strong)Account *account;
@property(nonatomic,strong)AccountLoginModel *accountLoginModel;
@property(nonatomic,assign)BOOL isLogin;
+ (AccountManager *)sharedManager;
-(void)loginCompletion:(void(^)(void))completion;

-(void)loginModel:(id)login withAccountInfo:(id)accountInfo;
-(void)logOut;
@end
