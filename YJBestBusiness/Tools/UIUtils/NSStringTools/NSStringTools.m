//
//  NSStringTools.m
//  BaseProject
//
//  Created by Aranion on 2017/4/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "NSStringTools.h"

@implementation NSStringTools

//字符串转换表情
+ (NSMutableAttributedString *)changeImageWithString:(NSString *)string {
    
    //加载plist文件中的数据
    NSBundle *bundle = [NSBundle mainBundle];
    //寻找资源的路径
    NSString *path = [bundle pathForResource:@"faceMap_ch" ofType:@"plist"];
    //获取plist中的数据
    NSDictionary *face = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *arr= face.allKeys;
    
    //创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSString * pattern = @"\\[{1}([0-9]\\d*)\\]{1}";
    NSError *error = nil;
    NSRegularExpression * re = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    if (!re) {
        //        NSLog(@"%@", [error localizedDescription]);
    }
    
    //通过正则表达式来匹配字符串
    NSArray *resultArray = [re matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        
        //获取原字符串中对应的值
        NSString *subStr = [string substringWithRange:range];
        
        for (int i = 0; i < face.count; i ++) {
            if ([face.allValues[i] isEqualToString:subStr]) {
                
                //新建文字附件来存放我们的图片
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [UIImage imageNamed:arr[i]];
                textAttachment.bounds=CGRectMake(0, 0, 15, 15);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    //从后往前替换
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        [imageArray[i][@"range"] getValue:&range];
        //进行替换
        [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
    }
    
    return attributeString;
}

//符号字符编译
+ (NSString*)URLencode:(NSString *)originalString
        stringEncoding:(NSStringEncoding)stringEncoding {
    
    originalString = [NSString stringWithFormat:@"%@",originalString];
    
    //路径有'／' 保留
    NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"?", @":", @"@", @"&", @"=", @"+", @"$", @",", @"!", @"'", @"(", @")", @"*", nil];
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B", @"%3F", @"%3A", @"%40", @"%26", @"%3D", @"%2B", @"%24", @"%2C", @"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    NSMutableString *temp = [[originalString
                              stringByAddingPercentEscapesUsingEncoding:stringEncoding]
                             mutableCopy];
    
    for (NSInteger i = 0; i < [escapeChars count]; i++) {
        
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i]
                              withString:[replaceChars objectAtIndex:i]
                                 options:NSLiteralSearch
                                   range:NSMakeRange(0, [temp length])];
    }
    
    return [NSString stringWithString: temp];;
}

// 数字转中文
+ (NSString *)translation:(NSString *)arebic {
    
    if (arebic != nil && arebic.length > 0) {
        
        NSString *str = arebic;
        NSArray *arabic_numerals = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
        NSArray *chinese_numerals = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
        NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chinese_numerals forKeys:arabic_numerals];
        
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < str.length; i ++) {
            NSString *substr = [str substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[str.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chinese_numerals[9]]) {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chinese_numerals[9]]) {
                        [sums removeLastObject];
                    }
                } else {
                    sum = chinese_numerals[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum]) {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = sumStr.length > 0 ? [sumStr substringToIndex:sumStr.length-1] : @"";
        
        chinese = [chinese stringByReplacingOccurrencesOfString:@"一十" withString:@"十"];

        return chinese;
        
    }else {
        
        return @"";
    }
}

// JSon字符串转NSDictionary
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    
    // 字符串替换
    NSString *str1 = [jsonString stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    NSString *str3 = [str1 stringByReplacingOccurrencesOfString:@"\'" withString:@"\""];
    // 替换后的字符串 转字典
    NSData *jsonData = [str3 dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    return err ? nil : dic;
}

//UP云图片拼接
+ (NSString *)picWithUrl:(NSString *)urlStr {
    
    if ([urlStr rangeOfString:@"upaiyun.com"].location != NSNotFound) {
        
        NSString *tempStr = @"";
        if ([[UIScreen mainScreen] currentMode].size.width >= 750) {
            tempStr = [[UIScreen mainScreen] currentMode].size.width >= 1080 ? @"!pic1080" : @"!pic750";
        } else {
            tempStr = [[UIScreen mainScreen] currentMode].size.width >= 640 ? @"!pic640" : @"!pic480";
        }
        return tempStr = [urlStr stringByAppendingString:tempStr];
        
    }else {
        
        return urlStr;
    }
}

@end
