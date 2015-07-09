//
//  Utils.m
//  anyi
//
//  Created by 周杰 on 15/6/24.
//  Copyright (c) 2015年 周杰. All rights reserved.
//

#import "Utils.h"

@implementation Utils



+(BOOL) isUserLoggedIn{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [userDefaults stringForKey:@"username"];
    
    if(  username == nil || [username isEqualToString: @""] ) {
        return false;
    }
    else{
        return true;
    }
};


+(BOOL)validateUsername: (NSString *)username{
    NSString *regEx = @"^1[0-9]{10}$";
    NSRange r = [username rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location == NSNotFound) {
        return false;
    }
    return true;
}
+(BOOL)validateCode:(NSString*)code
{
    NSString *regEx = @"^[0-9]{6}$";
    NSRange r = [code rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location == NSNotFound) {
        return false;
    }
    return true;
}

+(BOOL) validateEmail: (NSString *)email{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(BOOL) validatePassword: (NSString *)password{
    //pure digit number will return false
    NSString *regEx = @"^\\d*$";
    NSRange r = [password rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location != NSNotFound) {
        return false;
    }
    //if password no more long than 6
    if([password length] < 6){
        return  false;
    }
    return true;
}
+ (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}
+(NSDictionary*)getDictionaryPlistName:(NSString*)name
{
     NSString *sellFinenessPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSDictionary *rootDic = [NSDictionary dictionaryWithContentsOfFile:sellFinenessPath];
    return rootDic;
}
+(NSArray*)getArrayPlistName:(NSString*)name
{
    NSString *sellFinenessPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSArray *rootArr = [NSArray arrayWithContentsOfFile:sellFinenessPath];
    return rootArr;
}
@end
