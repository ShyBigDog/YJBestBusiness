//
//  NSString+NSString_XBExt.h
//  ChineseAndCardIDTest
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_XBExt)

- (NSString *)ifNull; // 字符串空值替换
- (BOOL)isNil; // 判断字符串是否为空

- (BOOL)includeChinese; // 判断是否含有汉字
- (BOOL)isAllChinese; // 判断字符串是否全为中文
- (BOOL)isAllNumber;  // 判断字符串是否全为数字

- (BOOL)isRealBankCardNum; // 判断字符串是否为全数字,并且是否以62开头，16-19位
- (BOOL)isRealNameAndLength; // 判断名字全是中文而且长度是2-4位

+ (NSString *)filterHTML:(NSString *)html;// 公告超链接处理
- (BOOL)isIdentityCard; // 校验身份证号码，传入18位身份证
+ (NSString *)isNullToString:(id)string;

@end
