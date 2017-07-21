//
//  TimeTools.h
//  BaseProject
//
//  Created by Aranion on 2017/4/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTools : NSObject

//NSDate 格式化为 NSString
+ (NSString*)stringFromFomate:(NSDate *)date formate:(NSString *)formate;
//NSString 格式化为 NSDate
+ (NSDate *)dateFromFomate:(NSString *)datestring formate:(NSString *)formate;
//计算距今时间(传入NSDate 计算与系统时间时间差)
+ (NSString *)prettyDateWithReference:(NSDate *)reference;
//根据NSDate获取时间(罗马数字格式)
+ (NSString *)getTimeString:(NSDate *)differtime;
//计算剩余几秒
+ (NSInteger)prettyDateWithCreateTime:(NSDate *)currentDate;
@end
