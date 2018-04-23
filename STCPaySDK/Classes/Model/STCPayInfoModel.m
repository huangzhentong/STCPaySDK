//
//  PayInfoModel.m
//  Pods
//
//  Created by KT--stc08 on 2018/4/23.
//

#import "STCPayInfoModel.h"

@implementation STCPayInfoModel

//-(void)setData:(id)data
//{
//    if (self.dataType.length>0) {
//
//        if ([self.dataType isEqualToString:@"JSON"]) {
//            NSData *jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
//           _data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//
//        }
//        else if([self.dataType isEqualToString:@""])
//        {
//            _data = [data copy];
//        }
//
//    }
//    else
//    {
//        _data = [data copy];
//    }
//}
-(id)data
{
    if ([self.dataType isEqualToString:@"JSON"])
    {
         if([_data isKindOfClass:[NSDictionary class]])
         {
             return _data;
         }
        else
        {
            NSData *jsonData = [_data dataUsingEncoding:NSUTF8StringEncoding];
            _data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            return _data;

        }
    }
    else if([self.dataType isEqualToString:@"String"])
    {
        return _data;
    }
    return _data;
}
@end
