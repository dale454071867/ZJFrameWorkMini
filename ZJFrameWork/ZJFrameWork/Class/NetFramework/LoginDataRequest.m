//
//  LoginDataRequest.m
//  anyi
//
//  Created by 周杰 on 15/6/25.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "LoginDataRequest.h"

@implementation LoginDataRequest
-(NSString*)port
{
    return @"ne/user/auth.json";
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
