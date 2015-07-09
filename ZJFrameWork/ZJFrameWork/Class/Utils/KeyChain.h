//
//  KeyChain.h
//  ZJFramework
//
//  Created by DL on 15/4/13.
//  Copyright (c) 2015年 DL. All rights reserved.
//
//删除应用后还能保存的东西
#import <Foundation/Foundation.h>

@interface KeyChain : NSObject
// 保存数据

+ (void)save:(NSString *)key data:(id)data;

// 加载数据

+ (id)load:(NSString *)key;

// 删除数据

+ (void)delete:(NSString *)key;

@end
