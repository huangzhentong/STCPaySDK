//
//  STCPayManager.h
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <Foundation/Foundation.h>

@interface STCPayManager : NSObject
@property(nonatomic,copy)NSString *aliPayScheme;
+(instancetype)shareInstance;
//如果需要支付宝支付请到 info.plist 添加相对应用的 Scheme
+(void)setAliPayScheme:(NSString*)appScheme;
//返回一个ViewController 
+(UIViewController *)openPayViewController:(NSString *)url;
//传入一个viewController
+(void)openPayViewController:(NSString *)url withViewController:(UIViewController*)vc;

//+(BOOL)STC_application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+(BOOL)STC_application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation;
+(BOOL)STC_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;
@end
