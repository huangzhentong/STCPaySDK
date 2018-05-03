//
//  PayWebViewController.h
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <UIKit/UIKit.h>

//typedef void(^Block)(void);

@interface STCPayWebViewController : UIViewController
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *UA;
@property(nonatomic,copy)void(^block)(void);
-(instancetype)initWithObject:(id)object;
@end
