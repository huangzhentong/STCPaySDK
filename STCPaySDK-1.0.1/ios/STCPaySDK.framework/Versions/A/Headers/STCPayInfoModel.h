//
//  PayInfoModel.h
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import <Foundation/Foundation.h>

@interface STCPayInfoModel : NSObject
//@pro
@property(nonatomic,copy)NSString *payType;                 //类型
@property(nonatomic,copy)NSString *returnUrl;               //返回数据
@property(nonatomic,copy)NSString *dataType;                //数据类型
@property(nonatomic,copy)id data;                           //支付数据

@end
