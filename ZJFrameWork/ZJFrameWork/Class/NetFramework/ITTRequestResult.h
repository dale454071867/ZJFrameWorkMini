//
//  HHRequestResult.h
//
//  Copyright 2010 Apple Inc. All rights reserved.
//
#import "ITTBaseModelObject.h"

@interface ITTRequestResult : NSObject

@property (nonatomic,strong) NSNumber *code;
@property(nonatomic,assign)BOOL isNULLData;
@property (nonatomic,strong) NSString *message;
@property(nonatomic,strong)id data;
- (id)initWithCode:(NSNumber*)code withMessage:(NSString*)message withHandleredResult:(NSDictionary*)dic;
- (BOOL)isSuccess;
- (void)showErrorMessage;

@end
