//
//  common.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define server @"http://news-at.zhihu.com/api/4/news/latest"
#define oldNews @"http://news.at.zhihu.com/api/4/news/before/"
#define  longComment @"http://news-at.zhihu.com/api/4/story/#{id}/long-comments"
#define  shortComment @"http://news-at.zhihu.com/api/4/story/#{id}/short-comments"
//新闻的额外信息，比如点赞的数量
#define extra @"http://news-at.zhihu.com/api/4/story-extra/#{id}"
//获取新闻详情
#define path1 @"http://news-at.zhihu.com/api/4/news/"
#define theme @"http://news-at.zhihu.com/api/4/themes"
#define theme1 @"http://news-at.zhihu.com/api/4/theme/"
#define launchScreen @"http://news-at.zhihu.com/api/4/start-image/1080*1776"
//获取最新新闻  两个字段
#define Stories @"stories"
#define TopStories @"top_stories"
#define Dateabc @"date"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define HeadViewHeight 200
#define Nav_ImageTag 1001

//枚举类型
typedef enum
{
    //以下是枚举成员
    Story_LongComment = 0,//长评论
    Story_ShortComment //短评论
}enumStoryComment;//枚举名称
@interface common : NSObject
//NSString日期转换NSDate
+(NSDate *)dateFromString:(NSString *)dateString;
//时间加减天数
+(NSString *) date:(NSString *) strDate addDays:(int) nDay;
//NSDate转换NSString日期
+ (NSString *)stringMMDDFromDate:(NSDate *)date;
//根据日期查询星期
+(NSString *) stringWeek:(NSDate *) date;
//时间戳
+(NSString *) timestampToDate:(NSInteger) ntimestamp;
//显示文本提示
+(void) showTip_MBProgressHud:(NSString *) strTitle View:(UIView *) vView;
@end
