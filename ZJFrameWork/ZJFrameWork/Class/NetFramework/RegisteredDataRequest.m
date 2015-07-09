//
//  RegisteredDataRequest.m
//  anyi
//
//  Created by 周杰 on 15/6/25.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "RegisteredDataRequest.h"

@implementation RegisteredDataRequest
-(NSString*)port
{
    return @"ne/user/create.json";
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
