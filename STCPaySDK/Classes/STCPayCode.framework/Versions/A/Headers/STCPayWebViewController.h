//
//  PayWebViewController.h
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <UIKit/UIKit.h>

//typedef void(^Block)(void);
//1.0.8 2018-05-18-10-33
@interface STCPayWebViewController : UIViewController
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *UA;
@property(nonatomic,copy)void(^block)(BOOL isPaySuccess);
-(instancetype)initWithObject:(id)object;
@end
