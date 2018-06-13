//
//  NSString+URL.h
//  Pods-STCPayCode_Example
//
//  Created by KT--stc08 on 2018/6/12.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)
/**
 *  URLEncode
 */
- (NSString *)URLEncodedString;

/**
 *  URLDecode
 */
-(NSString *)URLDecodedString;
@end
