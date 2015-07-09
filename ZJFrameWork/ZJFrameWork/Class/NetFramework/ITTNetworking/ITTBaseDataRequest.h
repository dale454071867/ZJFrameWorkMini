//
//  ITTBaseDataRequest.h
//  
//
//  Created by lian jie on 6/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "ITTRequestResult.h"
#import "ITTDataCacheManager.h"
#import "ITTMaskActivityView.h"
#import "ITTNetwork.h"

typedef enum : NSUInteger{
    ITTRequestMethodGet = 0,
    ITTRequestMethodPost = 1,           // content type = @"application/x-www-form-urlencoded"
    ITTRequestMethodMultipartPost = 2,   // content type = @"multipart/form-data"//用于文件相关
    ITTRequestMethodPut, //暂缓开通
    ITTRequestMethodDelete,//暂缓开通
} ITTRequestMethod;

typedef enum {
    ITTUpLoadData,
    ITTUpLoadDataPath
}ITTUpLoadDataType;


@class ITTRequestDataHandler;
@class ITTBaseDataRequest;

@protocol DataRequestDelegate <NSObject>

@optional
- (void)requestDidStartLoad:(ITTBaseDataRequest*)request;
- (void)requestDidFinishLoad:(ITTBaseDataRequest*)request;
- (void)requestDidCancelLoad:(ITTBaseDataRequest*)request;
- (void)request:(ITTBaseDataRequest*)request progressChanged:(float)progress;
- (void)request:(ITTBaseDataRequest*)request didFailLoadWithError:(NSError*)error;

@end

@interface ITTBaseDataRequest : NSObject
{
    NSString    *_cancelSubject;
    NSString    *_cacheKey;
    NSString    *_filePath;
    NSDate      *_requestStartDate;
    
    BOOL        _useSilentAlert;
    BOOL        _usingCacheData;
    
    DataCacheManagerCacheType _cacheType;
    ITTMaskActivityView       *_maskActivityView;
    
    void (^_onRequestStartBlock)(ITTBaseDataRequest *);
    void (^_onRequestFinishBlock)(ITTBaseDataRequest *);
    void (^_onRequestCanceled)(ITTBaseDataRequest *);
    void (^_onRequestFailedBlock)(ITTBaseDataRequest *, NSError *);
    void (^_onRequestProgressChangedBlock)(ITTBaseDataRequest *, float);
    void (^_onRequestProgressUpdateBlock)(ITTBaseDataRequest *,float);
    
    //progress related
    long long _totalData;
    long long _downloadedData;
    CGFloat   _currentProgress;
    CGFloat   _updateProgress;
}




@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) CGFloat currentProgress;
@property (nonatomic, assign) CGFloat updateProgress;
@property (nonatomic, assign) ITTParameterEncoding parmaterEncoding;
@property (nonatomic, strong) id handleredResult;
@property (nonatomic, strong) NSString *requestUrl;
@property (nonatomic, strong) NSString *rawResultString;
@property (nonatomic, strong) ITTRequestResult *result;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic,assign)BOOL isNULLData;
@property (nonatomic, strong, readonly) ITTRequestDataHandler *requestDataHandler;
@property (nonatomic,assign) ITTUpLoadDataType upLoadDataType;
@property (nonatomic,strong)NSString *downPath;
@property (nonatomic,strong) id updata;//NSData类型或NSString类型
@property (nonatomic,strong)NSNumber *timeoutInterval;

@property(nonatomic,copy)void (^onRequestStartBlock)(ITTBaseDataRequest *);
@property(nonatomic,copy)void (^onRequestFinishBlock)(ITTBaseDataRequest *);
@property(nonatomic,copy)void (^onRequestCanceled)(ITTBaseDataRequest *);
@property(nonatomic,copy)void (^onRequestFailedBlock)(ITTBaseDataRequest *, NSError *);
@property (nonatomic,copy)void (^onRequestProgressChangedBlock)(ITTBaseDataRequest *, float);
@property (nonatomic,copy)void (^onRequestProgressUpdateBlock)(ITTBaseDataRequest *, float);

#pragma mark - init methods using delegate

#pragma mark - init methods using blocks

/**
 *  常用
 *
 *  @param params          传入字典
 *  @param onFinishedBlock 成功返回
 *  @param onFailedBlock   失败返回
 *
 *  @return self
 */
+(id)requestCommentWithParameters:(NSDictionary*)params onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;
/**
 *  常用
 *
 *  @param params          传入字典
 *  @param IndicatorView loadingView
 *  @param onFinishedBlock 成功返回
 *  @param onFailedBlock   失败返回
 *
 *  @return self
 */
+(id)requestCommentWithParameters:(NSDictionary*)params withIndicatorView:(UIView*)indicatorView onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;


+ (id)requestCommentWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;




+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
             withRequestUrl:(NSString*)url
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
             onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
          onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

+ (id)requestWithParameters:(NSDictionary*)params
          withIndicatorView:(UIView*)indiView
          withCancelSubject:(NSString*)cancelSubject
          onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
            onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

+ (id)requestWithSuffixParam:(NSString*)suffixParam
                  parameters:(NSDictionary*)params
           withIndicatorView:(UIView*)indiView
           withCancelSubject:(NSString*)cancelSubject
           onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
             onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock;

//上传
+(id)requestWithUpLoadDataPath:(NSString*)dataPath
             withCancelSubject:(NSString*)cancelSubject
                onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
             onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
             onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
               onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
       onRequestProgressUpdate:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress;


+(id)requestWithUpLoadData:(NSData*)data
         withCancelSubject:(NSString*)cancelSubject
            onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
         onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
         onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
           onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
   onRequestProgressUpdate:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress;

//下载
+(id)requestDownUrlString:(NSString*)url
                 downPath:(NSString*)downPath
            cancelSubject:(NSString*)cancelSubject
           onRequestStart:(void(^)(ITTBaseDataRequest *request))onStartBlock
        onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
        onRequestCanceled:(void(^)(ITTBaseDataRequest *request))onCanceledBlock
          onRequestFailed:(void(^)(ITTBaseDataRequest *request))onFailedBlock
 onRequestProgressChanged:(void(^)(ITTBaseDataRequest *request,CGFloat progress))onRequestProgress;
/**
 *  核心方法
 *
 *  @param params                 传入字典
 *  @param url                    访问url
 *  @param indiView               如果有loading放置view
 *  @param loadingMessage         loading文字
 *  @param cancelSubject          取消的标志
 *  @param silent                 是否隐藏网络错误提示
 *  @param cache                  缓存标示
 *  @param cacheType              缓存类型
 *  @param localFilePath          文件路径
 *  @param onStartBlock           开始请求的block
 *  @param onFinishedBlock        正确返回的block
 *  @param onCanceledBlock        取消请求的block
 *  @param onFailedBlock          请求失败的block
 *  @param onProgressChangedBlock 请求网络的进度
 *
 *  @return self
 */
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
       onProgressChanged:(void(^)(ITTBaseDataRequest *request,float))onProgressChangedBlock;


#pragma mark - file download related init methods
//+ (id)requestWithDelegate:(id<DataRequestDelegate>)delegate
//             withParameters:(NSDictionary*)params
//          withIndicatorView:(UIView*)indiView
//          withCancelSubject:(NSString*)cancelSubject
//               withFilePath:(NSString*)localFilePath;
//
//+ (id)requestWithParameters:(NSDictionary*)params
//            withIndicatorView:(UIView*)indiView
//            withCancelSubject:(NSString*)cancelSubject
//                 withFilePath:(NSString*)localFilePath
//            onRequestFinished:(void(^)(ITTBaseDataRequest *request))onFinishedBlock
//            onProgressChanged:(void(^)(ITTBaseDataRequest *request,float progress))onProgressChangedBlock;

// request identifier userinfo
@property (nonatomic, strong) NSDictionary *userinfo;

- (void)notifyDelegateRequestDidErrorWithError:(NSError*)error;
- (void)notifyDelegateRequestDidSuccess;
- (void)doRelease;
//对于结果的处理
- (void)processResult;
- (void)showIndicator:(BOOL)bshow;
- (void)doRequestWithParams:(NSDictionary*)params;
- (void)cancelRequest;                                     //subclass should override the method to cancel its request
- (void)showNetowrkUnavailableAlertView:(NSString*)message;

- (BOOL)onReceivedCacheData:(NSObject*)cacheData;
- (BOOL)isSuccess;
- (BOOL)handleResultString:(NSString*)resultString;
- (BOOL)processDownloadFile;
/**
 *  请求方式
 *
 *  @return ITTRequestMethod
 */
- (ITTRequestMethod)getRequestMethod;                       //default method is GET
/**
 *  编码格式
 *
 *  @return NSStringEncoding
 */
- (NSStringEncoding)getResponseEncoding;

- (NSString*)encodeURL:(NSString *)string;
- (NSString*)getRequestUrl;
- (NSString*)getRequestHost;

- (NSDictionary*)getStaticParams;

+ (NSDictionary*)getDicFromString:(NSString*)cachedResponse;
-(NSString*)downPath;
@end
