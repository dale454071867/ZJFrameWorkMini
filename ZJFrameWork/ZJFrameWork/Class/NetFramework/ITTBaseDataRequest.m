//
//  ITTBaseDataRequest.m
//  
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ITTBaseDataRequest.h"
#import "ITTDataCacheManager.h"
#import "ITTDataRequestManager.h"
#import "ITTMaskActivityView.h"
#import "ITTRequestJsonDataHandler.h"
#import "ITTDataEnvironment.h"
#import "ITTDebug.h"
#import "ZJHeader.h"
#define DEFAULT_LOADING_MESSAGE  @"正在加载..."
//
//#if !__has_feature(objc_arc)
//#error AFNetworking must be built with ARC.
//// You can turn on ARC for only AFNetworking files by adding -fobjc-arc to the build phase for each of its files.
//#endif

@interface ITTBaseDataRequest()
{
}

@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSString *loadingMessage;

@end

@implementation ITTBaseDataRequest

#pragma mark - init methods using delegate

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cacheKey
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    
    return [self initWithDelegate:delegate
                   withRequestUrl:nil
                   withParameters:params
                withIndicatorView:indiView
               withLoadingMessage:nil
                withCancelSubject:cancelSubject
                  withSilentAlert:silent
                     withCacheKey:cacheKey
                    withCacheType:cacheType
                     withFilePath:localFilePath];
}

- (id)initWithDelegate:(id<DataRequestDelegate>)delegate
        withRequestUrl:(NSString*)url
        withParameters:(NSDictionary*)params
     withIndicatorView:(UIView*)indiView
    withLoadingMessage:(NSString*)loadingMessage
     withCancelSubject:(NSString*)cancelSubject
       withSilentAlert:(BOOL)silent
          withCacheKey:(NSString*)cache
         withCacheType:(DataCacheManagerCacheType)cacheType
          withFilePath:(NSString*)localFilePath
{
    self = [super init];
    if(self) {
        _parmaterEncoding = ITTURLParameterEncoding;
        _totalData = NSIntegerMax;
        _downloadedData = 0;
        _currentProgress = 0;
        _requestStartDate = [NSDate date];
        _isLoading = NO;
        _handleredResult = nil;
        _result = nil;
        
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
        _indicatorView = indiView;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        _userinfo = [[NSDictionary alloc] initWithDictionary:params];
        BOOL useCurrentCache = NO;
        if (localFilePath) {
            _filePath = localFilePath;
        }
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        NSObject *cacheData = [[ITTDataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }
        else {
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
    }
    return self;
}

#pragma mark - init methods using delegate
+(id)requestCommentWithParameters:(NSDictionary*)params onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                               suffixParam:nil
                                                         withIndicatorView:nil
                                                        withLoadingMessage:nil
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                                  withData:nil
                                                                  downPath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}
+(id)requestCommentWithParameters:(NSDictionary*)params withIndicatorView:(UIView*)IndicatorView onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                            withRequestUrl:nil
                                                               suffixParam:nil
                                                         withIndicatorView:IndicatorView
                                                        withLoadingMessage:nil
                                                         withCancelSubject:nil
                                                           withSilentAlert:YES
                                                              withCacheKey:nil
                                                             withCacheType:DataCacheManagerCacheTypeMemory
                                                              withFilePath:nil
                                                                  withData:nil
                                                                  downPath:nil
                                                            onRequestStart:nil
                                                         onRequestFinished:onFinishedBlock
                                                         onRequestCanceled:nil
                                                           onRequestFailed:onFailedBlock
                                                         onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestCommentWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:nil
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
    
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:nil
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}
+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}
+ (id)requestWithSuffixParam:(NSString*)suffixParam
                  parameters:(NSDictionary*)params
           withIndicatorView:(UIView*)indiView
           withCancelSubject:(NSString*)cancelSubject
           onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
             onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:params
                                                           withRequestUrl:nil
                                                              suffixParam:suffixParam
                                                        withIndicatorView:indiView
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:nil
                                                           onRequestStart:nil
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:nil
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}
//上传
+(id)requestWithUpLoadDataPath:(NSString*)dataPath
             withCancelSubject:(NSString*)cancelSubject
                onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
             onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
             onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
               onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
       onRequestProgressUpdate:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:dataPath
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    request.onRequestProgressUpdateBlock = [onRequestProgress copy];
    request.upLoadDataType = ITTUpLoadDataPath;
    request.updata = dataPath;
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
    
}


+(id)requestWithUpLoadData:(NSData*)data
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                           withRequestUrl:nil
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:data
                                                                 downPath:nil
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    request.onRequestProgressUpdateBlock = [onRequestProgress copy];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

//下载
+(id)requestDownUrlString:(NSString*)url
                 downPath:(NSString*)downPath
            cancelSubject:(NSString*)cancelSubject
           onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
        onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
        onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
          onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
 onRequestProgressChanged:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress
{
    ITTBaseDataRequest *request = [[[self class] alloc] initWithParameters:nil
                                                           withRequestUrl:url
                                                              suffixParam:nil
                                                        withIndicatorView:nil
                                                       withLoadingMessage:nil
                                                        withCancelSubject:cancelSubject
                                                          withSilentAlert:YES
                                                             withCacheKey:nil
                                                            withCacheType:DataCacheManagerCacheTypeMemory
                                                             withFilePath:nil
                                                                 withData:nil
                                                                 downPath:downPath
                                                           onRequestStart:onStartBlock
                                                        onRequestFinished:onFinishedBlock
                                                        onRequestCanceled:onCanceledBlock
                                                          onRequestFailed:onFailedBlock
                                                        onProgressChanged:nil];
    
    request.onRequestProgressChangedBlock = [onRequestProgress copy];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}
- (id)initWithParameters:(NSDictionary*)params
          withRequestUrl:(NSString*)url
             suffixParam:(NSString*)suffixParam
       withIndicatorView:(UIView*)indiView
      withLoadingMessage:(NSString*)loadingMessage
       withCancelSubject:(NSString*)cancelSubject
         withSilentAlert:(BOOL)silent
            withCacheKey:(NSString*)cache
           withCacheType:(DataCacheManagerCacheType)cacheType
            withFilePath:(NSString*)localFilePath
                withData:(id)data
                downPath:(NSString*)downPath
          onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
       onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
       onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
         onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock

{
    self = [super init];
    if(self) {
        if ([data isKindOfClass:[NSString class]]) {
            self.upLoadDataType = ITTUpLoadDataPath;
        }else
        {
            self.upLoadDataType = ITTUpLoadData;
        }
        _downPath = downPath;
        _updata = data;
        _parmaterEncoding = ITTURLParameterEncoding;
        _isLoading = NO;
        _handleredResult = nil;
        _result = nil;
        
        _requestUrl = url;
        if (!_requestUrl) {
            _requestUrl = [self getRequestUrl];
        }
        if (suffixParam) {
            _requestUrl = [_requestUrl stringByAppendingFormat:@"/%@",suffixParam];
        }
        _indicatorView = indiView;
        _useSilentAlert = silent;
        _cacheKey = cache;
        if (_cacheKey && [_cacheKey length] > 0) {
            _usingCacheData = YES;
        }
        _cacheType = cacheType;
        if (cancelSubject && cancelSubject.length > 0) {
            _cancelSubject = cancelSubject;
        }
        
        if (_cancelSubject && _cancelSubject) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelRequest) name:_cancelSubject object:nil];
        }
        if (onStartBlock) {
            _onRequestStartBlock = [onStartBlock copy];
        }
        if (onFinishedBlock) {
            _onRequestFinishBlock = [onFinishedBlock copy];
        }
        if (onCanceledBlock) {
            _onRequestCanceled = [onCanceledBlock copy];
        }
        if (onFailedBlock) {
            _onRequestFailedBlock = [onFailedBlock copy];
        }
        if (onProgressChangedBlock) {
            _onRequestProgressChangedBlock = [onProgressChangedBlock copy];
        }
        if (localFilePath) {
            _filePath = localFilePath;
        }
        self.loadingMessage = loadingMessage;
        if (!self.loadingMessage) {
            self.loadingMessage = DEFAULT_LOADING_MESSAGE;
        }
        _requestStartDate = [NSDate date];
        _userinfo = [[NSDictionary alloc] initWithDictionary:params];
        BOOL useCurrentCache = NO;
        NSObject *cacheData = [[ITTDataCacheManager sharedManager] getCachedObjectByKey:_cacheKey];
        if (cacheData) {
            useCurrentCache = [self onReceivedCacheData:cacheData];
        }
        if (!useCurrentCache) {
            _usingCacheData = NO;
            [self doRequestWithParams:params];
            ITTDINFO(@"request %@ is created", [self class]);
        }else{
            _usingCacheData = YES;
            [self performSelector:@selector(doRelease) withObject:nil afterDelay:0.1f];
        }
    }
    return self;
}

#pragma mark - file download related init methods
+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
           withParameters:(NSDictionary*)params
        withIndicatorView:(UIView*)indiView
        withCancelSubject:(NSString*)cancelSubject
             withFilePath:(NSString*)localFilePath
{
    
    ITTBaseDataRequest *request = [[[self class] alloc] initWithDelegate:delegate
                                                         withParameters:params
                                                      withIndicatorView:indiView
                                                      withCancelSubject:cancelSubject
                                                        withSilentAlert:NO
                                                           withCacheKey:nil
                                                          withCacheType:DataCacheManagerCacheTypeMemory
                                                           withFilePath:localFilePath];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
               withFilePath:(NSString*)localFilePath
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock
{
    
    ITTBaseDataRequest *request = [[[self class] alloc]initWithParameters:params
                                                          withRequestUrl:nil
                                                             suffixParam:nil
                                                       withIndicatorView:indiView
                                                      withLoadingMessage:nil
                                                       withCancelSubject:cancelSubject
                                                         withSilentAlert:YES
                                                            withCacheKey:nil
                                                           withCacheType:DataCacheManagerCacheTypeMemory
                                                            withFilePath:localFilePath
                                                                withData:nil
                                                                downPath:nil
                                                          onRequestStart:nil
                                                       onRequestFinished:onFinishedBlock
                                                       onRequestCanceled:nil
                                                         onRequestFailed:nil
                                                       onProgressChanged:onProgressChangedBlock];
    [[ITTDataRequestManager sharedManager] addRequest:request];
    return request;
}

#pragma mark - lifecycle methods

- (void)doRelease
{
    //remove self from Request Manager to release self;
    [[ITTDataRequestManager sharedManager] removeRequest:self];
}

- (void)dealloc
{
    ITTDINFO(@"request %@ is released, time spend on this request:%f seconds",
            [self class],[[NSDate date] timeIntervalSinceDate:_requestStartDate]);
    if (_indicatorView) {
        //make sure indicator is closed
        [self showIndicator:NO];
    }
    if (_cancelSubject && _cancelSubject) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:_cancelSubject
                                                      object:nil];
    }
}

#pragma mark - util methods

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse
{
    NSData *jsonData = [cachedResponse dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
}

- (void)generateRequestHandler
{
    _requestDataHandler = [[ITTRequestJsonDataHandler alloc] init];
}

- (BOOL)onReceivedCacheData:(NSObject*)cacheData
{
    // handle cache data in subclass
    // return yes to finish request, return no to continue request from server
    return NO;
}
//可以子类重写
- (void)processResult
{
    NSDictionary *resultDic = (self.handleredResult);
    _result = [[ITTRequestResult alloc] initWithCode:resultDic[@"err_cd"] withMessage:resultDic[@"err_desc"] withHandleredResult:resultDic];
    if (![_result isSuccess]) {
        ITTDERROR(@"request[%@] failed with message %@",self,_result.code);
    }else {
        ITTDINFO(@"request[%@] :%@" ,self ,@"success");
    }
}

//- (BOOL)isSuccess
//{
//    if (_result && [_result isSuccess]) {
//        return YES;
//    }
//    return NO;
//}

- (BOOL)processDownloadFile
{
    return FALSE;
}

- (NSString*)encodeURL:(NSString *)string
{
    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`"), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)));
    if (newString) {
        return newString;
    }
    return @"";
}

- (void)cancelRequest
{
}

- (void)showNetowrkUnavailableAlertView:(NSString*)message
{
    if (message && [message length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)showIndicator:(BOOL)bshow
{
    _isLoading = bshow;
    if (bshow && _indicatorView) {
//        if (!_maskActivityView) {
//            _maskActivityView = [ITTMaskActivityView loadFromXib];
//            [_maskActivityView showInView:self.indicatorView withHintMessage:self.loadingMessage onCancleRequest:^(ITTMaskActivityView *hintView){
//                [self cancelRequest];
//            }];
//        }
        [AYHUB showHUDAddedTo:_indicatorView];
    }else {
        [AYHUB hideHudTo:_indicatorView];
//        if (_maskActivityView) {
//            [_maskActivityView hide];
//            _maskActivityView = nil;
//        }
    }
}

- (void)cacheResult
{
    if ([self.result isSuccess] && _cacheKey) {
        if (DataCacheManagerCacheTypeMemory == _cacheType) {
            [[ITTDataCacheManager sharedManager] addObjectToMemory:self.handleredResult forKey:_cacheKey];
        }
        else{
            [[ITTDataCacheManager sharedManager] addObject:self.handleredResult forKey:_cacheKey];
        }
    }
}

- (void)notifyDelegateRequestDidSuccess
{
    if (_onRequestFinishBlock) {
        _onRequestFinishBlock(self);
    }
}

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error
{
    //using block callback
    if (_onRequestFailedBlock) {
        _onRequestFailedBlock(self, error);
    }
}

- (BOOL)isDownloadFileRequest
{
    return _filePath && [_filePath length];
}

- (BOOL)handleResultString:(NSString*)resultString
{
    BOOL success = FALSE;
    NSError *error = nil;
    if([self isDownloadFileRequest]) {
        success = [self processDownloadFile];
    }
    else {
        self.rawResultString = resultString;
        ITTDINFO(@"raw response string:%@", self.rawResultString);
        //add callback here
        if (!self.rawResultString || ![self.rawResultString length]) {
            ITTDERROR(@"!empty response error with request:%@", [self class]);
            [self notifyDelegateRequestDidErrorWithError:nil];
            return NO;
        }
        [self generateRequestHandler];
        self.handleredResult = [self.requestDataHandler handleResultString:self.rawResultString error:&error];
        if(self.handleredResult) {
            success = TRUE;
            [self processResult];
        }
        else {
            success = FALSE;
        }
    }
    if (success) {
        [self cacheResult];
        [self notifyDelegateRequestDidSuccess];
    }
    else {
        ITTDERROR(@"parse error %@", error);
        [self notifyDelegateRequestDidErrorWithError:error];
    }
    return success;
}
-(BOOL)isSuccess
{
    if (self.result) {
        return self.result.isSuccess;
    }else
    {
        return _isSuccess;
    }
}
-(BOOL)isNULLData
{
    if (self.result) {
        return self.result.isNULLData;
    }else
    {
        return _isNULLData;
    }
}
#pragma mark - hook methods
- (void)doRequestWithParams:(NSDictionary*)params
{
    SHOULDOVERRIDE(@"ITTBaseDataRequest", NSStringFromClass([self class]));
    ITTDERROR(@"should implement request logic here!");
}

- (NSStringEncoding)getResponseEncoding
{
    return NSUTF8StringEncoding;
    //return CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
}

- (NSDictionary*)getStaticParams
{
    return nil;
}

- (ITTRequestMethod)getRequestMethod
{
    return ITTRequestMethodGet;
}

- (NSString*)getRequestUrl
{
    if (!_requestUrl||![_requestUrl length]) {
        SHOULDOVERRIDE(@"ITTBaseDataRequest", NSStringFromClass([self class]));
    }
    return @"";
}
-(NSString*)downPath
{
    if (!_downPath) {
        
        return [self dataFilePath];
    }
    return _downPath;
}
//创建默认路径
-(NSString *)dataFilePath {
    NSArray * myPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
    NSString * myDocPath = [myPaths objectAtIndex:0];
    NSString *myfileGroup = [myDocPath stringByAppendingString:@"/ITTAFNet"];
    [self createFolder:myfileGroup];
    
    NSString *filename = [myfileGroup stringByAppendingFormat:@"/%@",@"downData"];
    
    return filename;
}
- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
- (NSString*)getRequestHost
{
    return DATA_ENV.urlRequestHost;
}
@end
