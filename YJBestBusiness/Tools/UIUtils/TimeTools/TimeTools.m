//
//  TimeTools.m
//  BaseProject
//
//  Created by Aranion on 2017/4/18.
//  Copyright © 2017年 Jerry. All rights reserved.
//

#import "TimeTools.h"

@implementation TimeTools

//NSDate 格式化为 NSString
+ (NSString *)stringFromFomate:(NSDate *)date formate:(NSString *)formate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return [formatter stringFromDate:date];
}

//NSString 格式化为 NSDate
+ (NSDate *)dateFromFomate:(NSString *)datestring formate:(NSString *)formate {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    
    return [formatter dateFromString:datestring];
}

//计算距今时间(传入NSDate 计算与系统时间时间差)
+ (NSString *)prettyDateWithReference:(NSDate *)reference {
    
    //获得与系统时间时间差(时间戳格式)
    NSDate *nowDate = [NSDate date];
    NSTimeInterval different = [reference timeIntervalSinceDate:nowDate];
    
    //若时间差为负
    if (different < 0) {
        different = -different;
    }
    
    //将时间差(时间戳格式)向下取整(单位:天)
    float dayDifferent = floor(different / 86400);
    
    //若时间差不足一天
    if (dayDifferent <= 0) {
        
        if (different < 60) {
            return @"刚刚";
        }else if (different < 120) {
            
            return [NSString stringWithFormat:@"1分钟前"];
        }else if (different < 60 * 60) {
            
            return [NSString stringWithFormat:@"%d分钟前", (int)floor(different / 60)];
        }else if (different < 7200) {
            
            return [NSString stringWithFormat:@"1小时前"];
        }else if (different < 86400) {
            
            return [NSString stringWithFormat:@"%d小时前", (int)floor(different / 3600)];
        }
    }else {
        
        int days = (int)dayDifferent;
        return [NSString stringWithFormat:@"%d天前", days];
    }
    
    return self.description;
}

//根据NSDate获取时间(罗马数字格式)
+ (NSString *)getTimeString:(NSDate *)differtime {
    
    NSDateFormatter *dateformatter = [NSDateFormatter new];
    [dateformatter setDateFormat:@"MM/dd/yyyy\'T\'HH:mm:ss"];
    
    return [dateformatter stringFromDate:differtime];
}

//剩余几秒
//计算距今时间(传入NSDate 计算与系统时间时间差)
+ (NSInteger)prettyDateWithCreateTime:(NSDate *)currentDate {
    
    //获得与系统时间时间差(时间戳格式)
    NSDate *nowDate = [NSDate date];
//    NSTimeInterval different = [currentDate timeIntervalSinceDate:nowDate];
//    
//    //若时间差为负
//    if (different < 0) {
//        different = -different;
//    }
//    
//    //将时间差(时间戳格式)向下取整(单位:天)
//    float dayDifferent = floor(different / 86400);
//    
//    //若时间差不足一天
//    if (dayDifferent <1) {
//        return -1;
//    }else {
//        if (different > 162000 && different < 172800) {
//            NSInteger current = 172800 - different;
//            return current;
//        }
//    }
//    return -1;
//    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateCom = [calendar components:unit fromDate:currentDate toDate:nowDate options:0];
    
    NSInteger currentMinc = dateCom.day * 3600 * 24 + dateCom.hour * 3600 + dateCom.minute * 60 + dateCom.second;
    if (currentMinc > 162000 && currentMinc < 172800) {
        NSInteger realSeconds = 172800 - currentMinc;
        return realSeconds;
    }else {
        return -1;
    }
//    return  -1;

}


@end
