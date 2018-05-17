//
//  PayWebViewController.h
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <UIKit/UIKit.h>

//typedef void(^Block)(void);
//1.0.9
@interface STCPayWebViewController : UIViewController
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *UA;
@property(nonatomic,copy)void(^block)(BOOL isPaySuccess);
-(instancetype)initWithObject:(id)object;
@end
