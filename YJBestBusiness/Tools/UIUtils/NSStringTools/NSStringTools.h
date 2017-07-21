//
//  NSStringTools.h
//  BaseProject
//
//  Created by Aranion on 2017/4/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSString+NSHash.h"
#import "NSString+Base64Encode.h"
#import "NSString+NSString_XBExt.h"

@interface NSStringTools : NSObject

// 字符串转表情
+ (NSMutableAttributedString *)changeImageWithString:(NSString *)string;
// 符号字符编译
+ (NSString *)URLencode:(NSString *)originalString
         stringEncoding:(NSStringEncoding)stringEncoding;
// 数字转中文
+ (NSString *)translation:(NSString *)arebic;
// JSon字符串转NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//UP云图片拼接
+ (NSString *)picWithUrl:(NSString *)urlStr;
@end
