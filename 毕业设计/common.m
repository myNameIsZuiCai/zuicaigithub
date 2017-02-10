//
//  common.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "common.h"

@implementation common
+(NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyyMMdd"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}
+(NSString *) date:(NSString *) strDate addDays:(int) nDay{
    NSDate *date=[common dateFromString:strDate];
    NSDate *newdate = [[NSDate date] initWithTimeInterval:-24 *60 * 60*nDay sinceDate:date];
    NSString *strNewDate=[common stringYYMMDDFromDate:newdate];
    return strNewDate;
}
+ (NSString *)stringMMDDFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"MM月-dd日"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
+(NSString *) stringYYMMDDFromDate:(NSDate *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}
//根据日期查询星期
+(NSString *) stringWeek:(NSDate *) date{
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
}
+(NSString *) timestampToDate:(NSInteger) ntimestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat:@"MM-dd HH:MM"];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:ntimestamp];
    NSString *destDateString = [formatter stringFromDate:confromTimesp];
    //NSLog(@"date1:%@",date);
    
    return destDateString;

}
@end
