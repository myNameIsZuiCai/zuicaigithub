//
//  newsDetailViewController.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/22.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoriesEntity.h"
#import "ParallaxHeaderView.h"
#import "DetailFooterView.h"
#import "commentViewController.h"
@interface newsDetailViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,ParallaxHeaderViewDelegate>
{
    IBOutlet UIWebView *_webView;
    NSString *newsDeta;
    
    NSMutableArray *_storiesArr;
    NSMutableArray *_topStoriesArr;
    NSInteger _n;//行号
    NSInteger _m;//行号
    NSMutableArray *_pathArr;//链接数组
    NSMutableArray *_pathArr1;
    
    NSMutableArray *_idArr1;//表格打开的新闻
    NSMutableArray *_idArr2;//顶部打开的新闻
    NSMutableArray *_idArr3;//从主题打开新闻
    
    UIBarButtonItem *_leftItem;
    UIBarButtonItem *_rightItem;
    NSString *_newsID;//新闻的id
    NSString *_newsDetail;
    NSInteger _currentIndex;
    BOOL _whereOpen;
    BOOL _themeOpen;
    NSMutableDictionary *_dic;//新闻的HTML
    UIImageView *_headView;//顶部图像视图
    float _orginallImgHeight;
    ParallaxHeaderView *_webHeadView;
    UILabel *_titleLab;//标题
    UILabel *_imgSourceLab;//图片来源
    IBOutlet UILabel *_totalLikes;//点赞的数量
    IBOutlet UILabel *_commentLable;//评论的数量
    
    NSMutableArray *_longCommentList;//长评论
    NSMutableArray *_shortCommentList;//短评论
    NSMutableArray *_tempLong;
    NSMutableArray *_tempShort;
    
    
    NSMutableArray *_storiesArr1;
    NSMutableArray *_topStoriesArr1;
    commentViewController *_newsCommentViewController;
    NSInteger totalLikes;
    NSInteger n;
    
    commentViewController *_commentViewController;
    NSString *popularity;
    NSString *comments;
}
@property (copy)void (^completion)();
#pragma mark 接收单元格的id数组与索引
-(void)receiveidArrAndIndexPath:(NSMutableArray *)idArr Row:(NSIndexPath*)index topOrBottom:(BOOL)tob;

#pragma mark 接收单元格的id数组与索引
-(void)receiveidArrAndIndexPath1:(NSMutableArray *)idArr number:(NSInteger)num Row:(NSIndexPath*)index topOrBottom:(BOOL)tob;
#pragma mark 接收单元格的链接
-(void)receiveNewsPath:(NSMutableArray*)news number:(NSIndexPath*)num buer:(BOOL)click;
#pragma mark接收topStories的id数组与索引
-(void)topStoriesidArrAndIndexPath:(NSMutableArray *)idArr Row:(NSInteger)index topOrBottom:(BOOL)tob;

#pragma mark toolBar上的对应事件
-(IBAction)backToRoot:(id)sender;
-(IBAction)nextClick:(id)sender;
-(IBAction)likeClick:(id)sender;
-(IBAction)shareClick:(id)sender;
-(IBAction)commentClick:(id)sender;

@end
