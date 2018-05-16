//
//  ThirdSDKManager.h
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <Foundation/Foundation.h>

extern NSString * const  WeiXinPay;
extern NSString * const  AirPay;

@interface STCThirdSDKManager : NSObject
+(BOOL)disposePayURL:(NSString *)payUrl withPayComplete:(void(^)(NSError*error,NSString *url))block;
//+(void)weixinPay:(NSDictionary *)dic withComplete:(void(^)(NSError *error))block;
@end
