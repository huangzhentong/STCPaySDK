//
//  STCPayManager.h
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <Foundation/Foundation.h>
#import "STCPayWebViewController.h"
extern NSString * const STCPaySuccessNotification;                  //支付成功通知
extern NSString * const STCPayFaieldNotification;                   //支付失败通知
@interface STCPayManager : NSObject
@property(nonatomic,copy)NSString *aliPayScheme;
@property(nonatomic,copy)NSString *h5Scheme;                        //使用h5支付的时候需要设置
+(instancetype)shareInstance;
//如果需要支付宝支付请到 info.plist 添加相对应用的 Scheme
+(void)setAliPayScheme:(NSString*)appScheme;
+(void)setH5Scheme:(NSString*)scheme;

//返回一个ViewController  block为返回事件 不需要返回事件的可传nil
+(STCPayWebViewController*)payViewController:(NSString *)url withBlock:(void(^)(BOOL isPaySuccess))block;

//传入一个viewController vc为空的话使用 windows 的 rootController
+(void)openPayViewController:(NSString *)url withViewController:(UIViewController*)vc;
//传入一个viewController vc为空的话使用 windows 的 rootController 传入一个返回事件
+(void)openPayViewController:(NSString *)url withViewController:(UIViewController*)vc withBlock:(void(^)(BOOL isPaySuccess))block;

//+(BOOL)STC_application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+(BOOL)STC_application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation;
+(BOOL)STC_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
@end
