//
//  Utils.h
//  anyi
//
//  Created by 周杰 on 15/6/24.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AYTabbarViewController.h"
@interface Utils : NSObject



+(BOOL) isUserLoggedIn;
+(BOOL)validateCode:(NSString*)code;
+(BOOL) validateUsername: (NSString *)username;
+(BOOL) validateEmail: (NSString *)email;
+(BOOL) validatePassword: (NSString *)password;

+ (UIViewController *)appRootViewController;

+(NSDictionary*)getDictionaryPlistName:(NSString*)name;
+(NSArray*)getArrayPlistName:(NSString*)name;
@end
