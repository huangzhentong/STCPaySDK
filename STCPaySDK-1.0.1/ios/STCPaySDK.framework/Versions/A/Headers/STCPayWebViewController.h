//
//  PayWebViewController.h
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <UIKit/UIKit.h>

@interface STCPayWebViewController : UIViewController
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *UA;
-(instancetype)initWithObject:(id)object;
@end
