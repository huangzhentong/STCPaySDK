//
//  ThirdSDKManager.m
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import "STCThirdSDKManager.h"
#import <UIKit/UIkit.h>
#import "STCPayInfoModel.h"
#import "WeixinApiManager.h"
#import "STCPayManager.h"
#import <AlipaySDK/AlipaySDK.h>

 NSString * const  WeiXinPay = @"WX";
NSString * const  AirPay = @"ALI";


@implementation STCThirdSDKManager
+(void)disposePayURL:(NSString *)payUrl withPayComplete:(void(^)(NSError*error,NSString *url))block;
{
    NSString *payWeb = @"https://cloud.keytop.cn/pc/page/app_pay.html?";
  
    if ([payUrl rangeOfString:payWeb].location != NSNotFound) {
        payUrl =  [payUrl stringByReplacingOccurrencesOfString:payWeb withString:@""];
        NSRange payInfoRanage = [payUrl rangeOfString:@"pay_info="];
        if(payInfoRanage.location != NSNotFound)
        {
            NSString *payInfo = [payUrl substringFromIndex:payInfoRanage.location+payInfoRanage.length];
            NSData *data = [[NSData alloc] initWithBase64EncodedString:payInfo options:NSDataBase64DecodingIgnoreUnknownCharacters];
            NSError *error = nil;
            NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (dic) {
                STCPayInfoModel * model = [[STCPayInfoModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                
                __weak typeof(model) weakModel = model;
                
                [self payManager:model withComplete:^(NSError *error) {

                    if (block) {
                        block(error,weakModel.returnUrl);
                    }
                    
                }];
            }
            
        }
    }
}
+(void)payManager:(STCPayInfoModel *)model withComplete:(void(^)(NSError *error))block
{
    if ([model.payType isEqualToString:WeiXinPay]) {
        [self weixinPay:model.data withComplete:block];
    }
    else if([model.payType isEqualToString:AirPay])
    {
        [self airPay:model.data withComplete:block];
    }
}

//微信
+(void)weixinPay:(NSDictionary *)dic withComplete:(void(^)(NSError *error))block
{
    if (dic != nil) {
       NSString *appID = dic[@"appid"];
        [WeixinApiManager instance].weiXinID = appID;
        [WeixinApiManager  wechatPay:dic completeCallback:^(int errorCode, NSString *errorStr, int errorType) {
            NSError *error = nil;
              if(errorCode==0&&errorType==0)
              {
                  //支付成功
              }
              else{
                  //支付失败
                  error = [NSError errorWithDomain:errorStr code:errorCode userInfo:nil];
              }
            if (block) {
                block(error);
            }
                
        }];
    }
    
}
//支付宝
+(void)airPay:(NSString*)info withComplete:(void(^)(NSError *error))block
{
    
    NSString  * scheme = [STCPayManager shareInstance].aliPayScheme;
    if (scheme.length == 0) {
        NSLog(@"未添加支付宝的scheme ！！！");
    }
    [[AlipaySDK defaultService] payOrder:info fromScheme:scheme callback:^(NSDictionary *resultDic) {
        NSLog(@"reslut = %@",resultDic);
        NSString *mome=@"";
        NSError *error = nil;
        if([resultDic objectForKey:@"memo"])
        {
            mome=[resultDic objectForKey:@"memo"];
        }
        NSInteger errorCode = [resultDic[@"resultStatus"] integerValue];
        NSString * resultStr = resultDic[@"result"];
        if(errorCode==9000 && resultStr.length > 100)
        {

        }
        else
        {
            error = [NSError errorWithDomain:resultStr code:errorCode userInfo:nil];
        }
        if (block) {
            block(error);
        }

    }];
    
   

}





@end
