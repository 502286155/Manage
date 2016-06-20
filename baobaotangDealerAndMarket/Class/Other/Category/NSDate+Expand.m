//
//  NSDate+Expand.m
//  
//
//  Created by Eric on 15/7/7.
//
//

#import "NSDate+Expand.h"

static NSDateFormatter *dateForMatter;
@implementation NSDate (Expand)

+ (NSString *)getTime {
    
    // 今天日期
    NSDate * today = [NSDate date];
    
    // 获取系统时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    // 得到源日期与世界标准时间的偏移量
    NSInteger interval = [zone secondsFromGMTForDate:today];
    
    // 偏移多少秒后得到的新NSDate对象
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    
    // 时间转换成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[localeDate timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSDate *)getLocalTimeDate
{
    // 今天日期
    NSDate * today = [NSDate date];
    
    // 获取系统时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    // 得到源日期与世界标准时间的偏移量
    NSInteger interval = [zone secondsFromGMTForDate:today];
    // 偏移多少秒后得到的新NSDate对象
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    
    return localeDate;
}

/**
 *  获取当前的时间 不带时间戳
 */
+ (NSString *)getTimeNotSp {
    // 今天日期
    NSDate * today = [NSDate date];
    
    // 获取系统时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    // 得到源日期与世界标准时间的偏移量
    NSInteger interval = [zone secondsFromGMTForDate:today];
    
    // 偏移多少秒后得到的新NSDate对象
    NSDate *localeDate = [today dateByAddingTimeInterval:interval];
    
    NSString *timeSp = [NSString stringWithFormat:@"%@", localeDate];
    
    return timeSp;
}

- (NSString *)getDateTime {
    
    if (dateForMatter == nil) {
        
        // 获取系统时区
        NSTimeZone *zone   = [NSTimeZone systemTimeZone];
        dateForMatter      = [[NSDateFormatter alloc] init];
        
        [dateForMatter setTimeZone:zone];
    }
    
    [dateForMatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSString *nowtimeStr = [dateForMatter stringFromDate:self];
    return nowtimeStr;
}

- (NSString *)getDateTimeString {
    
    if (dateForMatter == nil) {
        
        // 获取系统时区
        NSTimeZone *zone   = [NSTimeZone systemTimeZone];
        
        dateForMatter      = [[NSDateFormatter alloc] init];
        
        [dateForMatter setTimeZone:zone];
    }
    
    [dateForMatter setDateFormat:@"EE MM月dd HH:mm"];
    
    NSString *nowtimeStr = [dateForMatter stringFromDate:self];
    return nowtimeStr;
}

- (NSString *)getDate{
    
    if (dateForMatter == nil) {
        
        // 获取系统时区
        NSTimeZone *zone   = [NSTimeZone systemTimeZone];
        dateForMatter      = [[NSDateFormatter alloc] init];
        
        [dateForMatter setTimeZone:zone];
    }
    
    [dateForMatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *nowtimeStr = [dateForMatter stringFromDate:self];
    return nowtimeStr;
}

- (NSString *)getDateYYYYMMddHHmm{
    
    if (dateForMatter == nil) {
        
        // 获取系统时区
        NSTimeZone *zone   = [NSTimeZone systemTimeZone];
        dateForMatter      = [[NSDateFormatter alloc] init];
        
        [dateForMatter setTimeZone:zone];
    }
    
    [dateForMatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    NSString *nowtimeStr = [dateForMatter stringFromDate:self];
    return nowtimeStr;
}

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    // 1.获得当前时间的年月日
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    
    // 2.获得self的年与日
    NSString *selfDateString = [dateFormatter stringFromDate:self];
    
    return [dateString isEqual:selfDateString];

    
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 1.获得当前时间的年月日
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得 nowDate 和 selfDate 的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setDateFormat:@"yyyy-MM-dd"];
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    
    // 1.获得当前时间的年月日
    NSDate *now = [NSDate date];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:now];
    
    
    // 2.获得self的年与日
    NSString *selfDateString = [dateFormatter stringFromDate:self];
    
    return [dateString isEqual:selfDateString];
}



- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];// 计算两个时间的差距
}

/**
 *  获取距离当前时间的任意一段时间的日期
 */
+ (NSDate *)beforeTime:(NSTimeInterval)seconds
{
    NSDate *currentDate = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:currentDate];
    NSDate *localeDate = [currentDate dateByAddingTimeInterval:interval];
    NSTimeInterval currentTime = [localeDate timeIntervalSince1970];
    NSTimeInterval beforeTime = currentTime - seconds;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:beforeTime];
    return date;
}

@end
