//
//  NSString+NSString_XBExt.m
//  ChineseAndCardIDTest
//
//  Created by apple on 16/6/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NSString+NSString_XBExt.h"

@implementation NSString (NSString_XBExt)

// 字符串空值替换
- (NSString *)ifNull {
    
    return [self isEqual:[NSNull null]] || self == nil ? @"" : self;
}

// 判断字符串是否为空
- (BOOL)isNil {
    return [self isEqualToString:@""] ? YES : NO;
}

// 判断是否含有中文
- (BOOL)includeChinese {
    
    NSInteger length = [self length];
    
    for(NSInteger i = 0; i < length;i++) {
        
        NSInteger a =[self characterAtIndex:i];
        if( a > 0x4e00 && a <0x9fff){
            
            return YES;
        }
    }
    return NO;
}

// 判断是否全是中文
- (BOOL)isAllChinese {
    
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    
    return [predicate evaluateWithObject:self];
}

// 判断字符串是否全为数字
- (BOOL)isAllNumber {
    
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    return string.length <= 0;;
}

// 判断字符串是否为全数字,并且是否以62开头
- (BOOL)isRealBankCardNum {
    
    //判断是否全数字
    if (![self isAllNumber]) {
        
        return NO;
    }
    
    // 判断是否以62开头
    if (![self hasPrefix:@"62"]){
        
        return NO;
    }
    
    //判断长度是否标准
    return self.length >= 16 && self.length <= 19;
}

// 判断名字是中文，而且长度是2-4位
- (BOOL)isRealNameAndLength {
    
    if (![self isAllChinese]) {
        
        // 如果不是全中文返回 NO
        return NO;
    }
    
    //判断长度
    return (self.length >= 2 && self.length <= 4);
}

// 公告超链接处理
+ (NSString *)filterHTML:(NSString *)html {
    
    //扫描html
    NSScanner * scanner = [NSScanner scannerWithString:html];
    
    while([scanner isAtEnd] == NO) {
        
        NSString * text = nil;
        
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

// 判断身份证号码是否合法  18位身份证号
- (BOOL)isIdentityCard {
    BOOL rst = NO;
    if (self.length != 18) return rst; // 不是18位，直接返回NO
    
    // 格式判断
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    rst = [identityCardPredicate evaluateWithObject:self];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if (!rst) return rst;  // 格式不正确直接返回No
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    // 截取前两位
    NSString *areasString = [self substringToIndex:2];
    rst = NO;
    for (NSString *str in areasArray) { // 判断省份是否合法
        if ([str isEqualToString:areasString]) {
            rst = YES;
            break;
        }
    }
    if (!rst) return rst; // 省份不合法，直接返回
    
    // 判断出生年月是否合法
    NSString *date = @"^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";
    NSPredicate *birthday = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",date];
    // 截取生日
    NSString *birthDay = [self substringWithRange:NSMakeRange(6, 8)];
    rst = NO;
    rst = [birthday evaluateWithObject:birthDay];
    if (!rst) return rst; // 生日不合法，返回NO
    
    // 将前17位加权因子保存在数组里
    NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    // 这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    // 用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    // 计算前17位各自乖以加权因子后的总和
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex   = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum % 11;
    // 获取最后一位身份证号码
    NSString * idCardLast= [self substringWithRange:NSMakeRange(17, 1)];
    if(idCardMod==2) { // 如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        rst = [idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"];
    } else {  // 用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        rst = [idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]];
    }
    
    return rst ? YES : NO;
}

+ (NSString *)isNullToString:(id)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
    } else {
        
        return (NSString *)string;
    }
}

@end
