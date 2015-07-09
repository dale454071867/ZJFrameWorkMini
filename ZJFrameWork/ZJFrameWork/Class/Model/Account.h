//
//  Account.h
//  anyi
//
//  Created by 周杰 on 15/6/19.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  用户信息
 */
@interface Account : NSObject
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *country;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *_id;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *phone_no;
@property(nonatomic,strong)NSString *photo_address;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *username;
@end
