//
//  ITTAFNBaseDataRequest.m
//  iTotemFramework
//
//  Created by Sword Zhou on 7/18/13.
//  Copyright (c) 2013 iTotemStudio. All rights reserved.
//

#import "ITTAFNBaseDataRequest.h"
#import "ITTNetworkTrafficManager.h"
#import "AFHTTPRequestOperation.h"
#import "ITTAFQueryStringPair.h"
#import "ITTDataRequestManager.h"
#import "AFURLRequestSerialization.h"
#import "NSJSONSerialization+ITTAdditions.h"
//#import "AFHTTPClient.h"
#import "AFHTTPRequestOperationManager.h"
#import "ZJHeader.h"

#define outTime 20.f


@interface ITTAFNBaseDataRequest()
{
    AFHTTPRequestOperation  *_requestOperation;
}

@end

@implementation ITTAFNBaseDataRequest
- (NSString *)contentType
{
    NSString *charset = @"utf-8";// (NSString*)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    NSString *contentType = [NSString stringWithFormat:@"application/json; charset=%@", charset];
    return contentType;
}
-(CGFloat)timeOut
{
    return 15;
}


+ (void)showNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)hideNetworkActivityIndicator
{
#if TARGET_OS_IPHONE
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}

- (void)networkingOperationDidStart:(NSNotification *)notification
{
//    ITTDINFO(@"- (void)networkingOperationDidStart:(NSNotification *)notification");
    //    AFURLConnectionOperation *connectionOperation = [notification object];
    //    if (connectionOperation.request.URL) {
    [[self class] showNetworkActivityIndicator];
    [self showIndicator:TRUE];
    //    }
}

- (void)networkingOperationDidFinish:(NSNotification *)notification
{
//    ITTDINFO(@"- (void)networkingOperationDidFinish:(NSNotification *)notification");
    //    AFURLConnectionOperation *connectionOperation = [notification object];
    //    if (connectionOperation.request.URL) {
    [[self class] hideNetworkActivityIndicator];
    [self showIndicator:FALSE];
    //    }
}

- (void)notifyDelegateDownloadProgress
{
    //using block
    if (_onRequestProgressChangedBlock) {
        _onRequestProgressChangedBlock(self, self.currentProgress);
    }
}
- (void)notifyDelegateUpdateProgress
{
    if (_onRequestProgressUpdateBlock) {
        _onRequestProgressUpdateBlock(self,self.updateProgress);
    }
}

//报文头子类可重写已改变报文头信息
-(NSDictionary*)setHeadDataDic
{
    NSMutableDictionary *headParams = [NSMutableDictionary dictionary];
    [headParams setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [headParams setObject:$(@"JWT %@",[AccountManager sharedManager].accountLoginModel.token) forKey:@"Authorization"];
    return headParams;
}
- (void)generateRequestWithUrl:(NSString*)url withParameters:(NSDictionary*)params
{
    // process params
    NSMutableDictionary *allParams = [NSMutableDictionary dictionaryWithCapacity:10];
    [allParams addEntriesFromDictionary: params];
    NSDictionary *staticParams = [self getStaticParams];
    if (staticParams != nil) {
        [allParams addEntriesFromDictionary:staticParams];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    //开始请求
    [self networkingOperationDidStart:nil];
    if (ITTRequestMethodGet == [self getRequestMethod]){
        manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
        [self setHeadWithAFManager:manager];
        _requestOperation = [manager GET:url parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self requestSuccess:operation responseObject:responseObject];
            [self networkingOperationDidFinish:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self requestFailure:operation error:error];
            [self networkingOperationDidFinish:nil];
        }];
        [self progressBlock:_requestOperation];
    }else if(ITTRequestMethodPost == [self getRequestMethod])
    {
        switch (self.parmaterEncoding) {
            case ITTURLParameterEncoding:
            {
                manager.requestSerializer=[AFHTTPRequestSerializer serializer];
                manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
                [self setHeadWithAFManager:manager];
                _requestOperation = [manager POST:url parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestSuccess:operation responseObject:responseObject];
                    [self networkingOperationDidFinish:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self requestFailure:operation error:error];
                    [self networkingOperationDidFinish:nil];
                }];
                [self progressBlock:_requestOperation];
                
            }
                break;
            case ITTJSONParameterEncoding:
            {
                manager.requestSerializer=[AFJSONRequestSerializer serializer];
                manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
                [self setHeadWithAFManager:manager];
                _requestOperation = [manager POST:url parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestSuccess:operation responseObject:responseObject];
                    [self networkingOperationDidFinish:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self networkingOperationDidFinish:nil];
                    [self requestFailure:operation error:error];
                }];
                [self progressBlock:_requestOperation];
            }
                break;
            case ITTPropertyListParameterEncoding:
            {
                manager.requestSerializer=[AFPropertyListRequestSerializer serializer];
                manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
                [self setHeadWithAFManager:manager];
                _requestOperation = [manager POST:url parameters:allParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self requestSuccess:operation responseObject:responseObject];
                    [self networkingOperationDidFinish:nil];
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self requestFailure:operation error:error];
                    [self networkingOperationDidFinish:nil];
                }];
                [self progressBlock:_requestOperation];
            }
                break;
                
            default:
                break;
        }
    }else if(ITTRequestMethodMultipartPost == [self getRequestMethod])
    {
        
        switch (self.parmaterEncoding) {
                //上传
            case ITTURLParameterEncoding:
            {
                manager.requestSerializer = [AFHTTPRequestSerializer serializer];
                manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                manager.requestSerializer.timeoutInterval = self.timeoutInterval?[self.timeoutInterval floatValue]:outTime;
                [self setHeadWithAFManager:manager];
                _requestOperation =   [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    
                    if (self.upLoadDataType == ITTUpLoadData) {
                        [formData appendPartWithFileData:self.updata name:@"data" fileName:@"user_item.jpg" mimeType:@"image/jpeg"];
                    }else if(self.upLoadDataType == ITTUpLoadDataPath)
                    {
                        NSURL *fileURL = [NSURL URLWithString:[self updata]];
                        [formData appendPartWithFileURL:fileURL name:@"data" fileName:@"user_item.jpg" mimeType:@"image/jpeg" error:nil];
                    }
                    
                } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"OK");
                    [self requestSuccess:operation responseObject:responseObject];
                    [self networkingOperationDidFinish:nil];
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"error");
                    //                        error.code == NSURLErrorCancelled;
                    //                        时是取消
                    [self requestFailure:operation error:error];
                    [self networkingOperationDidFinish:nil];
                }];
                [self progressBlock:_requestOperation];
            }
                
                break;
            case ITTDownParameterEncoding:
            {
                //下载
                
                NSURL *URL = [NSURL URLWithString:url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
                [self setHeadWithAFManager:request];
                _requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                _requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
                __weak __block typeof(self) wself = self;
                
                
                
                _requestOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:[self downPath] append:NO];
                
                
                [_requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    [wself networkingOperationDidFinish:nil];
                    wself.handleredResult = responseObject;
                    wself.isSuccess = YES;
                    if (wself.onRequestFinishBlock) {
                        wself.onRequestFinishBlock(wself);
                    }
                    
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    NSLog(@"Image error: %@", error);
                    wself.isSuccess = NO;
                    if (wself.onRequestFailedBlock) {
                        wself.onRequestFailedBlock(wself,error);
                    }
                    [wself networkingOperationDidFinish:nil];
                }];
                [self progressBlock:_requestOperation];
                
            }
            default:
                break;
        }
    }
    
}


-(void)progressBlock:(AFHTTPRequestOperation*)requstOperation
{
    [requstOperation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //        weakSelf.currentProgress = 1.0*totalBytesRead/totalBytesExpectedToRead;
        //如果需要统计进度在这里添加进度block
        _currentProgress = 1.0*totalBytesRead/totalBytesExpectedToRead;
        [self notifyDelegateDownloadProgress];
    }];
    __BlockwSelf;
    [requstOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        wSelf.updateProgress = 1.0*totalBytesWritten/totalBytesExpectedToWrite;
        [wSelf notifyDelegateUpdateProgress];
    }];
    
}

-(void)requestSuccess:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject
{
    [self handleResultString:operation.responseString];
    //         [self unregisterRequestNotification];
    [self doRelease];
}
-(void)requestFailure:(AFHTTPRequestOperation *)operation error:(NSError*) error
{
    [self handleError:error];
    [self notifyDelegateRequestDidErrorWithError:error];
    //         [self unregisterRequestNotification];
    [self doRelease];
}
-(void)setHeadWithAFManager:(id)manager
{
    NSDictionary *headDic = [self setHeadDataDic];
    if ([manager isKindOfClass:[AFHTTPRequestOperationManager class]]) {
        for (NSString *key in headDic) {
            [((AFHTTPRequestOperationManager*)manager).requestSerializer setValue:[self setHeadDataDic][key] forHTTPHeaderField:key];
        }
    }else if([manager isKindOfClass:[NSMutableURLRequest class]])
    {
        for (NSString *key in headDic) {
            [((NSMutableURLRequest*)manager) setValue:[self setHeadDataDic][key] forHTTPHeaderField:key];
        }
    }
}
- (void)doRequestWithParams:(NSDictionary*)params
{
    [self generateRequestWithUrl:self.requestUrl withParameters:params];
    //    [_requestOperation start];
}

- (void)handleError:(NSError*)error
{
    if (error) {
        NSString *errorMsg = nil;
        if ([NSURLErrorDomain isEqualToString:error.domain]) {
            errorMsg = @"无法连接到网络";
        }
        if (_useSilentAlert) {
            //            [self showNetowrkUnavailableAlertView:errorMsg];
            
            [self showNetError:@"无法连接到网络"];
        }
    }
}
-(void)showNetError:(NSString*)error
{
//    [[WDToast makeText:error withDuration:1.5] show];
    [AYHUB showText:error];
}

- (void)cancelRequest
{
    ITTDINFO(@"%@ request is cancled", [self class]);
    [_requestOperation cancel];
    //to cancel here
    if (_onRequestCanceled) {
        _onRequestCanceled(self);
    }
    [self showIndicator:FALSE];
    [self doRelease];
}
- (NSString*)getRequestUrl
{
    return [NSString stringWithFormat:@"%@%@",REQUEST_BASE_URL,self.port];
}
- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodPost;
}
@end
