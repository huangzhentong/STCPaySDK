//
//  UIImage+LoadWithBundle.m
//  
//
//  Created by KT--stc08 on 2018/4/23.
//

#import "UIImage+LoadWithBundle.h"

@implementation UIImage (LoadWithBundle)

+(UIImage*)imageWithBundle:(NSBundle*)bundle withName:(NSString*)name
{
    if (bundle) {
      return  [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    }
    return nil;
}
@end
