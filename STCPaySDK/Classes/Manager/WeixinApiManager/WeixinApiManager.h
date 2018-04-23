//
//  WeixinApiManager.h
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 15/10/22.
//  Copyright © 2015年 庄小先生丶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WXApi.h>
typedef void(^WeixinApiAuthResponseCompeleteCallback)(NSString* code,NSString *state,NSUInteger errorCode,  NSDictionary* refreshTokenData, NSDictionary *userInfo);
typedef void(^WeixinApiPayResponseCompeleteCallback)(int errorCode,NSString *errorStr,int errorType);

typedef void(^WeixinApiShareResponseCompeleteCallback)(int errorCode,NSString *errorStr,int errorType);

@protocol WeixinApiManagerDelegate <NSObject>

@optional

- (void)weixinApiManagerDidRecvGetMessageReq:(GetMessageFromWXReq *)request;

- (void)weixinApiManagerDidRecvShowMessageReq:(ShowMessageFromWXReq *)request;

- (void)weixinApiManagerDidRecvLaunchFromWXReq:(LaunchFromWXReq *)request;

- (void)weixinApiManagerDidRecvMessageResponse:(SendMessageToWXResp *)response;

- (void)weixinApiManagerDidRecvAuthResponse:(SendAuthResp *)response;

- (void)weixinApiManagerDidRecvAddCardResponse:(AddCardToWXCardPackageResp *)response;

@end

@interface WeixinApiManager : NSObject<WXApiDelegate>
@property(nonatomic,assign)BOOL isLogin;
@property (nonatomic, assign) id<WeixinApiManagerDelegate> delegate;
@property(nonatomic,copy)WeixinApiAuthResponseCompeleteCallback  authResponseCallback;
@property(nonatomic,copy)WeixinApiPayResponseCompeleteCallback payReponseCallback;
@property(nonatomic,copy)WeixinApiShareResponseCompeleteCallback shareReponseCallBack;
@property(nonatomic,copy)NSString *weiXinID;

+ (instancetype)instance;


+ (void)getWeixinUserInfo:(NSString*)code
                    state:(NSString*)state
                errorCode:(NSUInteger)errorCode;
                //compelete:(WeixinApiAuthResponseCompeleteCallback)compelete;

+ (void)wechatPay:(NSDictionary*)parameters
 completeCallback:(WeixinApiPayResponseCompeleteCallback)completeCallback;

+ (BOOL)isInstallWeixinApi;


+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene;

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene;

+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene
          compelete:(WeixinApiShareResponseCompeleteCallback)compelete;;

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene;

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene;

+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene;

+ (BOOL)addCardsToCardPackage:(NSArray *)cardIds;

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController
                   compelete:(WeixinApiAuthResponseCompeleteCallback)compelete;

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg;


+ (BOOL)respText:(NSString *)text;

+ (BOOL)respImageData:(NSData *)imageData
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage;

+ (BOOL)respAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage;
@end
