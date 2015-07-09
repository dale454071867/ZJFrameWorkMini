//
//  ZJDB.h
//  waimai
//
//  Created by DL on 14/11/18.
//
//

#import <Foundation/Foundation.h>
#import "QueryModelObject.h"
@interface ZJDB : NSObject
+(ZJDB*)db;


//打开数据库
-(BOOL)openDB;
//关闭数据库
-(BOOL)close;
//创建表
-(BOOL)createShopConfigure;


@end
