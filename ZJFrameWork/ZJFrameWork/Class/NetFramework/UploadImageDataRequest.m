//
//  UploadImageDataRequest.m
//  anyi
//
//  Created by 周杰 on 15/6/26.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "UploadImageDataRequest.h"

@implementation UploadImageDataRequest
-(NSString*)port
{
    return @"ne/file/upload_img.json";
}
-(ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodMultipartPost;
}
-(NSNumber*)timeoutInterval
{
    return @120;
}
@end
