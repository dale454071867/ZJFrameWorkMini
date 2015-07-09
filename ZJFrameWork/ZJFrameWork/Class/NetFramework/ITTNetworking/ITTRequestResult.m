//
//  HHRequestResult
//
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "ITTRequestResult.h"
#import <UIKit/UIKit.h>
@interface ITTRequestResult()<UIAlertViewDelegate>
@property(nonatomic,strong)NSString *upUrl;
@end

@implementation ITTRequestResult
///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

-(id)initWithCode:(NSNumber*)code withMessage:(NSString*)message withHandleredResult:(NSDictionary*)dic
{
    self = [super init];
    if (self) {
        _code = @([code integerValue]);
        _message = message;
        _data = dic[@"data"];
    }
    return self;
}

-(BOOL)isSuccess
{
    return (_code && [_code intValue] == 0);
}
-(BOOL)isNULLData
{
    return (_code && [_code intValue] == -6);
}
-(void)showErrorMessage
{
    if (_message && _message.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:_message
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end