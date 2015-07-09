//
//  LocationMander.h
//  anyi
//
//  Created by 周杰 on 15/6/18.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZJLocationCoordinate2D.h"
@interface LocationUtils : NSObject
+(void)starLocationResutl:(void (^)(ZJLocationCoordinate2D *location, NSError *error))locationResultBlock;
@end
