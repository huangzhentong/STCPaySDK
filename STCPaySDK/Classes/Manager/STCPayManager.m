//
//  STCPayManager.m
//  Pods-STCPaySDK_Example
//
//  Created by KT--stc08 on 2018/4/23.
//

#import "STCPayManager.h"
#import "STCPayWebViewController.h"
#import "WeixinApiManager.h"
#import <AlipaySDK_MI/AlipaySDK/AlipaySDK.h>
@implementation STCPayManager

+(instancetype)shareInstance
{
    static STCPayManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[STCPayManager alloc] init];
    });
    return manager;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)setAliPayScheme:(NSString *)aliPayScheme
{
    [STCPayManager shareInstance].aliPayScheme = aliPayScheme;
}


+(UIViewController*)openPayViewController:(NSString *)url
{
    STCPayWebViewController *viewController = [[STCPayWebViewController alloc] init];
    viewController.url = url;
    viewController.title = @"支付";
    viewController.UA = @"keytop.superpak.app";
    return viewController;
}

+(void)openPayViewController:(NSString *)url withViewController:(UIViewController *)vc
{
    UIViewController *viewController =  [self openPayViewController:url];
    if (vc) {
        if ([vc isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)vc pushViewController:viewController animated:YES];
        }
        else if([vc isKindOfClass:[UIViewController class]])
        {
            if(vc.navigationController)
            {
                [vc.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                UINavigationController *navi = [self getNavigation:viewController];
                [vc presentViewController:navi animated:YES completion:nil];
            }
            
        }
        else
        {
            UINavigationController *navi = [self getNavigation:viewController];
            [vc presentViewController:navi animated:YES completion:nil];
        }
    }
    else
    {
        UINavigationController *navi = [self getNavigation:viewController];
        [vc presentViewController:navi animated:YES completion:nil];
    }
}

+(UINavigationController*)getNavigation:(UIViewController*)vc
{
   return  [[UINavigationController alloc]initWithRootViewController:vc];
}
+(UIViewController *)getRootViewController
{
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    if (vc) {
        
    }
    return vc;
}


#pragma mark - UIApplication

+(BOOL)STC_application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
//     [WXApi handleOpenURL:url delegate:[WeixinApiManager instance]];
    return YES;
}
+(BOOL)STC_application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation
{
    if([WXApi handleOpenURL:url delegate:[WeixinApiManager instance]])
    {

    }
    else{

        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
+(BOOL)STC_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if([WXApi handleOpenURL:url delegate:[WeixinApiManager instance]])
    {
        
    }
    else{
        
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}


@end
