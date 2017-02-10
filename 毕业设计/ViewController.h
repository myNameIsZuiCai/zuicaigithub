//
//  ViewController.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "ParallaxHeaderView.h"
#import "UIScrollView+VGParallaxHeader.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate,ParallaxHeaderViewDelegate,SDCycleScrollViewDelegate>

{

    
    UIImageView *_imageView;//启动动画的视图
    NSString *strURL;//启动
    UILabel *navLable;
    NSMutableDictionary *_dic;//从服务器解析下来的字典
    NSMutableDictionary *_dic1;
    NSMutableArray *_dataArr;//存放所有新闻的数组
    UITableView *_tableView;//存放新闻的表格
    NSMutableDictionary *_storiesDic;//剥离stories
    NSMutableDictionary *_storiesDic1;//剥离stories

    NSMutableArray *_storiesArr;//剥离出来新闻
    NSMutableArray *_storiesArr1;//剥离出来新闻

    NSMutableArray *_topStoriesArr;//顶部视图的新闻
    UIScrollView *_scrollView;//滑动视图
    UIPageControl *_pageController;//页码控制
    UIView *_headerView;
    NSMutableArray *_idArr;//新闻的id数组


    
    UIImageView *_topImage;//顶部新闻的图片
    UITapGestureRecognizer *tap;
    NSTimer *_timer;//计时器
    UIProgressView *_progressView;//进度栏
    NSInteger _progressValue;//进度值
    NSString *timeDate;
    NSMutableArray *_timeArr;//放置新闻时间的数组
    NSMutableArray *_countArr;//计算每次得到了多少条新闻的数组
    NSMutableArray *_tempArr;
    NSMutableArray *_stories;
    SDCycleScrollView *_cycleScrollView;
    BOOL _bflag;

    BOOL _isNeting;
    
    NSMutableArray *_storiesArr2;//剥离旧新闻需要用的数组
    NSInteger countID1;//第一批id
    NSInteger countID2;//第二批ID
    NSMutableArray *_idArr2;
    NSMutableArray *_idArr1;//顶部新闻的id数组
    NSMutableArray *_idAll;
    int ndays;
    int _scrollViewHeight;//滑动视图的高度
    UIView *_NavView;//导航视图
}
-(void)sender:(BOOL)flag;
@end

