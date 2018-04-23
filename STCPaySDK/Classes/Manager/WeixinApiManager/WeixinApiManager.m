//
//  WeixinApiManager.m
//  MagicBabyAppClient
//
//  Created by 庄小先生丶 on 15/10/22.
//  Copyright © 2015年 庄小先生丶. All rights reserved.
//

#import "WeixinApiManager.h"


/*
 =============================================================================================
 =======================================GetMessageFromWXResp======================================
 =============================================================================================
 */

@interface GetMessageFromWXResp (responseWithTextOrMediaMessage)

+ (GetMessageFromWXResp *)responseWithText:(NSString *)text
                            OrMediaMessage:(WXMediaMessage *)message
                                     bText:(BOOL)bText;
@end

@implementation GetMessageFromWXResp (responseWithTextOrMediaMessage)

+ (GetMessageFromWXResp *)responseWithText:(NSString *)text
                            OrMediaMessage:(WXMediaMessage *)message
                                     bText:(BOOL)bText {
    GetMessageFromWXResp *resp = [[GetMessageFromWXResp alloc] init] ;
    resp.bText = bText;
    if (bText)
        resp.text = text;
    else
        resp.message = message;
    return resp;
}

@end

/*
 =============================================================================================
 =======================================SendMessageToWXReq======================================
 =============================================================================================
 */

@interface SendMessageToWXReq (requestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene;
@end


@implementation SendMessageToWXReq (requestWithTextOrMediaMessage)

+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

@end


/*
 =============================================================================================
 =======================================WXMediaMessage======================================
 =============================================================================================
 */
@interface WXMediaMessage (messageConstruct)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName;
@end

@implementation WXMediaMessage (messageConstruct)

+ (WXMediaMessage *)messageWithTitle:(NSString *)title
                         Description:(NSString *)description
                              Object:(id)mediaObject
                          MessageExt:(NSString *)messageExt
                       MessageAction:(NSString *)action
                          ThumbImage:(UIImage *)thumbImage
                            MediaTag:(NSString *)tagName {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = mediaObject;
    message.messageExt = messageExt;
    message.messageAction = action;
    message.mediaTagName = tagName;
    [message setThumbImage:thumbImage];
    return message;
}

@end


/*
 =============================================================================================
 =======================================WeixinApiManager======================================
 =============================================================================================
 */
@interface WeixinApiManager ()

@end
@implementation WeixinApiManager
@synthesize shareReponseCallBack=_shareReponseCallBack;
@synthesize authResponseCallback=_authResponseCallback;
@synthesize payReponseCallback=_payReponseCallback;

#pragma mark - LifeCycle
+(instancetype)instance {
    static dispatch_once_t onceToken;
    static WeixinApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeixinApiManager alloc] init];
    });
    return instance;
}
-(void)setWeiXinID:(NSString *)weiXinID
{
    _weiXinID = [weiXinID copy];
    [WXApi registerApp:_weiXinID ];
}

- (void)dealloc {
    self.delegate = nil;
}
#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        if(_shareReponseCallBack)
        {
            _shareReponseCallBack(resp.errCode,resp.errStr,resp.type);
            _shareReponseCallBack=nil;
        }
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvMessageResponse:)]) {
            SendMessageToWXResp *messageResp = (SendMessageToWXResp *)resp;
            [_delegate weixinApiManagerDidRecvMessageResponse:messageResp];
        }
    } else if ([resp isKindOfClass:[SendAuthResp class]]) {
        
        
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        [WeixinApiManager getWeixinUserInfo:authResp.code state:authResp.state errorCode:authResp.errCode];
        
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvAuthResponse:)]) {
            [_delegate weixinApiManagerDidRecvAuthResponse:authResp];
        }
    } else if ([resp isKindOfClass:[AddCardToWXCardPackageResp class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvAddCardResponse:)]) {
            AddCardToWXCardPackageResp *addCardResp = (AddCardToWXCardPackageResp *)resp;
            [_delegate weixinApiManagerDidRecvAddCardResponse:addCardResp];
        }
    }else if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        
        switch (resp.errCode) {
            case WXSuccess:
                if(_payReponseCallback)
                {
                    _payReponseCallback(resp.errCode,resp.errStr,resp.type);
                    _payReponseCallback=nil;
                }
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                break;
                
            default:
                if(_payReponseCallback)
                {
                    _payReponseCallback(resp.errCode,resp.errStr,resp.type);
                    _payReponseCallback=nil;
                }
                
//                NSString *strMsg= [NSString stringWithFormat:@"支付结果"];
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                break;
        }
    }
}

- (void)onReq:(BaseReq *)req {
    if ([req isKindOfClass:[GetMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvGetMessageReq:)]) {
            GetMessageFromWXReq *getMessageReq = (GetMessageFromWXReq *)req;
            [_delegate weixinApiManagerDidRecvGetMessageReq:getMessageReq];
        }
    } else if ([req isKindOfClass:[ShowMessageFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvShowMessageReq:)]) {
            ShowMessageFromWXReq *showMessageReq = (ShowMessageFromWXReq *)req;
            [_delegate weixinApiManagerDidRecvShowMessageReq:showMessageReq];
        }
    } else if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        if (_delegate
            && [_delegate respondsToSelector:@selector(weixinApiManagerDidRecvLaunchFromWXReq:)]) {
            LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
            [_delegate weixinApiManagerDidRecvLaunchFromWXReq:launchReq];
        }
    }
}

+ (void)getWeixinUserInfo:(NSString*)code
                    state:(NSString*)state
                errorCode:(NSUInteger)errorCode
                //compelete:(WeixinApiAuthResponseCompeleteCallback)compelete
{
    
    if([WeixinApiManager instance].authResponseCallback)
    {
        [WeixinApiManager instance].authResponseCallback(code,state,errorCode,nil,nil);
        [WeixinApiManager instance].authResponseCallback=nil;
    }
    return;
    
    
    
//    NSString *tokenUrl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",APP_SYSTEM_THIRD_PLATFORM_SHARE_WEIXIN_APPKEY,APP_SYSTEM_THIRD_PLATFORM_SHARE_WEIXIN_APPSECRET,code];
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL *zoneTokenUrl = [NSURL URLWithString:tokenUrl];
//        NSString *zoneTokenStr = [NSString stringWithContentsOfURL:zoneTokenUrl encoding:NSUTF8StringEncoding error:nil];
//        NSData *tokenData = [zoneTokenStr dataUsingEncoding:NSUTF8StringEncoding];
//        
//        if (tokenData) {
//            NSDictionary *tokenDic = [NSJSONSerialization JSONObjectWithData:tokenData options:NSJSONReadingMutableContainers error:nil];
//            /*
//             {
//             "access_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWiusJMZwzQU8kXcnT1hNs_ykAFDfDEuNp6waj-bDdepEzooL_k1vb7EQzhP8plTbD0AgR8zCRi1It3eNS7yRyd5A";
//             "expires_in" = 7200;
//             openid = oyAaTjsDx7pl4Q42O3sDzDtA7gZs;
//             "refresh_token" = "OezXcEiiBSKSxW0eoylIeJDUKD6z6dmr42JANLPjNN7Kaf3e4GZ2OncrCfiKnGWi2ZzH_XfVVxZbmha9oSFnKAhFsS0iyARkXCa7zPu4MqVRdwyb8J16V8cWw7oNIff0l-5F-4-GJwD8MopmjHXKiA";
//             scope = "snsapi_userinfo,snsapi_base";
//             }
//             */
//            NSString *userInfoUrl =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",tokenDic[@"access_token"],tokenDic[@"openid"]];
//            NSURL *zoneUserInfoUrl = [NSURL URLWithString:userInfoUrl];
//            NSString *zoneUserInfoStr = [NSString stringWithContentsOfURL:zoneUserInfoUrl encoding:NSUTF8StringEncoding error:nil];
//            NSData *userInfoData = [zoneUserInfoStr dataUsingEncoding:NSUTF8StringEncoding];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (userInfoData) {
//                    NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:userInfoData options:NSJSONReadingMutableContainers error:nil];
//                    /*
//                     {
//                     city = Haidian;
//                     country = CN;
//                     headimgurl = "http://wx.qlogo.cn/mmopen/FrdAUicrPIibcpGzxuD0kjfnvc2klwzQ62a1brlWq1sjNfWREia6W8Cf8kNCbErowsSUcGSIltXTqrhQgPEibYakpl5EokGMibMPU/0";
//                     language = "zh_CN";
//                     nickname = "xxx";
//                     openid = oyAaTjsDx7pl4xxxxxxx;
//                     privilege =     (
//                     );
//                     province = Beijing;
//                     sex = 1;
//                     unionid = oyAaTjsxxxxxxQ42O3xxxxxxs;
//                     }
//                     */
//                    if([WeixinApiManager instance].authResponseCallback)
//                    {
//                        [WeixinApiManager instance].authResponseCallback(code,state,errorCode,tokenDic,userInfoDic);
//                        [WeixinApiManager instance].authResponseCallback=nil;
//                    }
//                    
//                    
////                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
////                                                                    message:[NSString stringWithFormat:@"nick:%@",[dic objectForKey:@"nickname"]]
////                                                                   delegate:self
////                                                          cancelButtonTitle:@"OK"
////                                                          otherButtonTitles:nil, nil];
////                    [alert show];
////                    [alert release];
//                    //                        self.nickname.text = [dic objectForKey:@"nickname"];
//                    //                        self.wxHeadImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"headimgurl"]]]];
//                    
//                }
//            });
//        }
//    });
}




+ (void)wechatPay:(NSDictionary*)parameters
      completeCallback:(WeixinApiPayResponseCompeleteCallback)completeCallback
{
        if(parameters != nil){
//            NSMutableString *retcode = [parameters objectForKey:@"retcode"];
//            if (retcode.intValue == 0){
            
               [WeixinApiManager instance].payReponseCallback=completeCallback;
                NSMutableString *stamp  = [parameters objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [parameters objectForKey:@"partnerid"];
                req.prepayId            = [parameters objectForKey:@"prepayid"];
                req.nonceStr            = [parameters objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [parameters objectForKey:@"package"];
                req.sign                = [parameters objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[parameters objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                
//            }
        }
}


+(BOOL)isInstallWeixinApi
{
   return [WXApi isWXAppInstalled];
}


#pragma mark - Request Methods
+ (BOOL)sendText:(NSString *)text
         InScene:(enum WXScene)scene {
    SendMessageToWXReq *req = [SendMessageToWXReq requestWithText:text
                                                   OrMediaMessage:nil
                                                            bText:YES
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendImageData:(NSData *)imageData
              TagName:(NSString *)tagName
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage
              InScene:(enum WXScene)scene {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendLinkURL:(NSString *)urlString
            TagName:(NSString *)tagName
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene
          compelete:(WeixinApiShareResponseCompeleteCallback)compelete
{
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
//    tagName=description;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    [message setThumbImage:thumbImage];

//    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
//                                                   Description:description
//                                                        Object:ext
//                                                    MessageExt:nil
//                                                 MessageAction:nil
//                                                    ThumbImage:thumbImage
//                                                      MediaTag:tagName];
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
//    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
//                                                   OrMediaMessage:message
//                                                            bText:NO
//                                                          InScene:scene];
    
    [WeixinApiManager instance].shareReponseCallBack=compelete;
    return [WXApi sendReq:req];
}

+ (BOOL)sendMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicURL;
    ext.musicDataUrl = dataURL;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    
    return [WXApi sendReq:req];
}

+ (BOOL)sendVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage
                InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             InScene:(enum WXScene)scene {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = @"pdf";
    ext.fileData = fileData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
}

+ (BOOL)sendAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage
                   InScene:(enum WXScene)scene {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    SendMessageToWXReq* req = [SendMessageToWXReq requestWithText:nil
                                                   OrMediaMessage:message
                                                            bText:NO
                                                          InScene:scene];
    return [WXApi sendReq:req];
    
}

+ (BOOL)addCardsToCardPackage:(NSArray *)cardItems {
    AddCardToWXCardPackageReq *req = [[AddCardToWXCardPackageReq alloc] init] ;
    req.cardAry = cardItems;
    return [WXApi sendReq:req];
}

+ (BOOL)sendAuthRequestScope:(NSString *)scope
                       State:(NSString *)state
                      OpenID:(NSString *)openID
            InViewController:(UIViewController *)viewController
                   compelete:(WeixinApiAuthResponseCompeleteCallback)compelete
{
    
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = scope; // @"post_timeline,sns"
    req.state = state;
    req.openID = openID;
    [WeixinApiManager instance].authResponseCallback=compelete;
    return [WXApi sendAuthReq:req
               viewController:viewController
                     delegate:[WeixinApiManager instance]];
}

+ (BOOL)jumpToBizWebviewWithAppID:(NSString *)appID
                      Description:(NSString *)description
                        tousrname:(NSString *)tousrname
                           ExtMsg:(NSString *)extMsg {
    [WXApi registerApp:appID ];
    JumpToBizWebviewReq *req = [[JumpToBizWebviewReq alloc]init];
    req.tousrname = tousrname;
    req.extMsg = extMsg;
    req.webType = WXMPWebviewType_Ad;
    return [WXApi sendReq:req];
}




#pragma mark - Response Methods
+ (BOOL)respText:(NSString *)text {
    GetMessageFromWXResp *resp = [GetMessageFromWXResp responseWithText:text
                                                         OrMediaMessage:nil
                                                                  bText:YES];
    return [WXApi sendResp:resp];
}

+ (BOOL)respImageData:(NSData *)imageData
           MessageExt:(NSString *)messageExt
               Action:(NSString *)action
           ThumbImage:(UIImage *)thumbImage {
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    
    return [WXApi sendResp:resp];
}

+ (BOOL)respLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(UIImage *)thumbImage {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    return [WXApi sendResp:resp];
}

+ (BOOL)respMusicURL:(NSString *)musicURL
             dataURL:(NSString *)dataURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage {
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicURL;
    ext.musicDataUrl = dataURL;
    
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    
    return [WXApi sendResp:resp];
}

+ (BOOL)respVideoURL:(NSString *)videoURL
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage {
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoURL;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    
    return [WXApi sendResp:resp];
}

+ (BOOL)respEmotionData:(NSData *)emotionData
             ThumbImage:(UIImage *)thumbImage {
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:nil
                                                   Description:nil
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    return [WXApi sendResp:resp];
}

+ (BOOL)respFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage {
    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:nil
                                                 MessageAction:nil
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    return [WXApi sendResp:resp];
}

+ (BOOL)respAppContentData:(NSData *)data
                   ExtInfo:(NSString *)info
                    ExtURL:(NSString *)url
                     Title:(NSString *)title
               Description:(NSString *)description
                MessageExt:(NSString *)messageExt
             MessageAction:(NSString *)action
                ThumbImage:(UIImage *)thumbImage {
    WXAppExtendObject *ext = [WXAppExtendObject object];
    ext.extInfo = info;
    ext.url = url;
    ext.fileData = data;
    
    WXMediaMessage *message = [WXMediaMessage messageWithTitle:title
                                                   Description:description
                                                        Object:ext
                                                    MessageExt:messageExt
                                                 MessageAction:action
                                                    ThumbImage:thumbImage
                                                      MediaTag:nil];
    
    GetMessageFromWXResp* resp = [GetMessageFromWXResp responseWithText:nil
                                                         OrMediaMessage:message
                                                                  bText:NO];
    
    return [WXApi sendResp:resp];
}
@end
