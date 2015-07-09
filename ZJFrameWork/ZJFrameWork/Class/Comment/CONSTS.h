//
//  CONSTS.h
//  Hupan
//
//  Copyright 2010 iTotem Studio. All rights reserved.
//

#define NOTIFY_POST(NAME, ARGS) ([[NSNotificationCenter defaultCenter] postNotificationName:NAME object:nil userInfo: ARGS]);

#define NOTIFY_REMOVE(NAME, OBJ) ([[NSNotificationCenter defaultCenter] removeObserver:OBJ name:NAME object:nil]);

#define NOTIFY_REGISTER(NAME, FUNC) [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FUNC:) name:NAME object:nil];
#define REQUEST_DOMAIN @"http://cx.itotemstudio.com/api.php" // default env

//text
#define TEXT_LOAD_MORE_NORMAL_STATE @"向上拉动加载更多..."
#define TEXT_LOAD_MORE_LOADING_STATE @"更多数据加载中..."


#define USER_WM_NOTIFICATION_LOGIN     @"USER_WM_NOTIFICATION_LOGIN"
#define USER_WM_NOTIFICATION_LOGOUT    @"USER_WM_NOTIFICATION_LOGOUT"

#define KEY_BOARD_WINDOWN       [[[UIApplication sharedApplication]windows]count]>1?[[[UIApplication sharedApplication]windows]objectAtIndex:1]:nil;

#define KEY_WINDOW          [UIApplication sharedApplication].keyWindow
#define KEY_DOEN_BTN_TAG    108
#define REAL_ORIGIN_Y   ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0f)?20:0
#define REAL_ORIGIN_H    ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0f)?70:50

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion]compare:@"7.0"]!=NSOrderedAscending)

#define ScreenBoundHeight [UIScreen mainScreen].bounds.size.height
#define ScreenBoundWidth [UIScreen mainScreen].bounds.size.width
#define ScreenBound [UIScreen mainScreen].bounds
#define is4InchScreen() ([UIScreen mainScreen].bounds.size.height == SCREEN_HEIGHT_OF_IPHONE5)

//#define DATEFORMATTER @"yyyy/MM/dd HH:mm:ss"

#define kMode_Development             @"00"

#define UMENG_APPKEY @""

///AES加密 key && IV
#define AY_AES_KEY @"com.anyi.aeskey1"
#define AY_AES_IV @"anyi.aesiv.com11"
//请求链接

//#define REQUEST_BASE_URL   @"http://dz.jbwzx.com/app/server/"

#define REQUEST_BASE_URL   @"http://anyianyi.com/"


#define REQUEST_IMAGE_URL  @"http://anyianyi.com/media/"

///CacheDefaine

//版本管理//内部｛bundleArray：［“1.0”，“2.0”］｝
#define WM_CACHE_CFBundleShortVersionString @"WM_CACHE_CFBundleShortVersionString"



#define __BlockwSelf __weak __block typeof(self) wSelf = self
#define $(FORMAT,...) [NSString stringWithFormat:FORMAT,##__VA_ARGS__]
#define REQUESTURLCONNECT(interfaceName) [NSString stringWithFormat:@"%@%@",REQUEST_BASE_URL,interfaceName]

#define REQUESTIMAGEURLCONNECT(IMAGEURL) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",REQUEST_IMAGE_URL,IMAGEURL]]
//other consts

/**
 *  notificaiton
 */
///登陆成功通知
#define AY_LOGINSTATECHANGE @"AY_LOGINSTATECHANGE"
///刷新每一页的reloadSelfView
#define AY_RELOADVIEW @"AY_RELOADVIEW"
///更新社区列表
#define AY_RELOAD_COMMUNITY_LIST @"AY_RELOADLOCATION"
///刷新交易
#define AY_RELOAD_ITEM_SELECT @"AY_RELOAD_ITEM_SELECT"
///强制更新
#define AY_FORCE_UPDATA @"AY_FORCE_UPDATA"


///cache
///保存的位置信息
#define AY_SELECT_LOCATION @"AY_SELECT_LOCATION"
///保存用户token&&id
#define AY_USERLOGIN_INFO @"AY_USERLOGIN_INFO"
///保存用户信息
#define AY_USERINFO @"AY_USERINFO"


///更新地址
#define AY_APP_UPDATAURL @"http://www.pgyer.com/FOHS"

typedef enum{
	kTagWindowIndicatorView = 501,
	kTagWindowIndicator,
} WindowSubViewTag;

typedef enum{
    kTagHintView = 101
} HintViewTag;


