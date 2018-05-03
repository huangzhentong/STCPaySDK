//
//  STCPayManager.h
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <Foundation/Foundation.h>
#import "STCPayWebViewController.h"
@interface STCPayManager : NSObject
@property(nonatomic,copy)NSString *aliPayScheme;
+(instancetype)shareInstance;
//如果需要支付宝支付请到 info.plist 添加相对应用的 Scheme
+(void)setAliPayScheme:(NSString*)appScheme;

//返回一个ViewController  block为返回事件 不需要返回事件的可传nil
+(STCPayWebViewController*)payViewController:(NSString *)url withBlock:(void(^)(void))block;

//传入一个viewController vc为空的话使用 windows 的 rootController
+(void)openPayViewController:(NSString *)url withViewController:(UIViewController*)vc;
//传入一个viewController vc为空的话使用 windows 的 rootController 传入一个返回事件
+(void)openPayViewController:(NSString *)url withViewController:(UIViewController*)vc withBlock:(void(^)(void))block;

//+(BOOL)STC_application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+(BOOL)STC_application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation;
+(BOOL)STC_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
@end
