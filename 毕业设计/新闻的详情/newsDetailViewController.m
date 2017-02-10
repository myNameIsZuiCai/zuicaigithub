//
//  newsDetailViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/22.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "newsDetailViewController.h"
#import "common.h"
#import "themeViewController.h"
#import "StoriesEntity.h"
#import "StoryDetailRequest.h"
#import "ParallaxHeaderView.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "commentViewController.h"
#import "UINavigationBar+Awesome.h"
@interface newsDetailViewController ()

@end

@implementation newsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view from its nib.
    [self initWebView];
    [self textOfLable];
}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
-(void)initWebView{
    _webView.backgroundColor=[UIColor orangeColor];
    _webView.userInteractionEnabled=YES;
    _webView.scrollView.delegate=self;
    
}
#pragma mark lable的文本即点赞数量
-(void)textOfLable{
    //判断从哪里打开的新闻
    if (_themeOpen==YES) {
        NSString *newid=[_idArr3 objectAtIndex:_n];
        NSMutableString *format=[NSMutableString stringWithFormat:@"%@",extra];
        //评论页面最终的地址
        NSString *extraPath=[format stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",newid]];
        [self parseExtraInformation:extraPath];
    }
    
    else if (_whereOpen==YES) {
        NSString *newid=[_idArr1 objectAtIndex:_n];
        NSMutableString *format=[NSMutableString stringWithFormat:@"%@",extra];
        //评论页面最终的地址
        NSString *extraPath=[format stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",newid]];
        [self parseExtraInformation:extraPath];
        if (_themeOpen==NO) {
             [self parseExtraInformation:extraPath];
        }
    }
    
    else{
        NSString *newid=[_idArr2 objectAtIndex:_n];
        NSMutableString *format=[NSMutableString stringWithFormat:@"%@",extra];
        //评论页面最终的地址
        NSString *extraPath=[format stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",newid]];
        if (_themeOpen==NO) {
            [self parseExtraInformation:extraPath];
        }
        [self parseExtraInformation:extraPath];
    }
}
#pragma mark 解析点赞数量以及评论数
-(void)parseExtraInformation:(NSString*)para{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:para parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        NSMutableDictionary *_dicExtra1=[NSMutableDictionary dictionary];
        _dicExtra1=operation.responseObject;
        
        popularity=_dicExtra1[@"popularity"];
        comments=_dicExtra1[@"comments"];
        _totalLikes.text=[NSString stringWithFormat:@"%@",popularity];
        _commentLable.text=[NSString stringWithFormat:@"%@",comments];
        totalLikes=[[NSString stringWithFormat:@"%@",popularity] integerValue];
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.description);
    }];
}
#pragma mark 从表格打开的新闻
-(void)receiveidArrAndIndexPath1:(NSMutableArray *)idArr number:(NSInteger)num Row:(NSIndexPath*)index topOrBottom:(BOOL)tob{
    _n=num;//行号
    //将id与字符串组合起来形成新闻的链接的数组
    _pathArr=[NSMutableArray array];
    for (int i=0; i<idArr.count; i++) {
        //从idArr中剥离id
        NSString *str1=[NSString stringWithFormat:@"%@",[idArr objectAtIndex:i]];
        //path追加id 最终形成字符串
        NSString *str2=[path1 stringByAppendingString:str1];
        [_pathArr addObject:str2];
    }
    //在数组中提取出位于index.row的元素
    _newsDetail=[_pathArr objectAtIndex:num];
    _newsID=[idArr objectAtIndex:num];
    //请求数据
    [self parseHTML:_newsDetail];
    _whereOpen=tob;
    _idArr1=[NSMutableArray array];
    _idArr1=idArr;
}



#pragma mark 从主题打开的新闻
-(void)receiveNewsPath:(NSMutableArray*)news number:(NSIndexPath*)num buer:(BOOL)click{
    _n=num.row;
    NSString *str1=[news objectAtIndex:num.row];
    _newsDetail=[path1 stringByAppendingString:[NSString stringWithFormat:@"%@",str1]];
    
    [self parseHTML:_newsDetail];
    NSString *newid=[news objectAtIndex:num.row];
    NSMutableString *format=[NSMutableString stringWithFormat:@"%@",extra];
    //评论页面最终的地址
    NSString *extraPath=[format stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",newid]];
    [self parseExtraInformation:extraPath];
    _idArr3=[NSMutableArray array];
    _idArr3=news;
    _themeOpen=click;
}

#pragma mark 从顶部新闻打开新闻
-(void)topStoriesidArrAndIndexPath:(NSMutableArray *)idArr Row:(NSInteger)index topOrBottom:(BOOL)tob{
    _pathArr1=[NSMutableArray array];
    for (int i=0; i<idArr.count; i++) {
        //动idArr中剥离id
        NSString *str1=[NSString stringWithFormat:@"%@",[idArr objectAtIndex:i]];
        //path追加id 最终形成字符串
        NSString *str2=[path1 stringByAppendingString:str1];
        [_pathArr1 addObject:str2];
    }
    _newsDetail=[_pathArr1 objectAtIndex:index];
    _newsID=[idArr objectAtIndex:index];
    [self parseHTML:_newsDetail];
    _whereOpen=tob;
    _idArr2=[NSMutableArray array];
    _idArr2=idArr;
    _n=index;
}
#pragma mark 解析HTML数据
-(void)parseHTML:(NSString *)para{
    //请求数据
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:para parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        _dic=[NSMutableDictionary dictionary];
        _dic=operation.responseObject;
        
        //新闻详情页面的图片
        NSString *headPicture=_dic[@"image"];
        NSString *headTitle=_dic[@"title"];
        NSString *imageSource=_dic[@"img_source"];
        if ([headPicture length]>0) {
            [self loadParallaxHeader:headPicture Title:headTitle ImageSource:imageSource];
        }
        //获取HTML代码
        NSString *body=_dic[@"body"];
        //加载css格式
        NSString *cssURL=_dic[@"css"][0];
        NSString *linkString=[NSString stringWithFormat:@"<link rel=\"Stylesheet\" type=\"text/css\" href=\"%@\" />",cssURL];
        //拼接包含css的HTML代码
        newsDeta=[NSString stringWithFormat:@"%@%@",linkString,body];
        [_webView loadHTMLString:newsDeta baseURL:nil];
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.description);
    }];

}


#pragma mark 设置头部的图片
-(void)loadParallaxHeader:(NSString *)strImgUrl Title:(NSString *)strTitle ImageSource:(NSString *)strImgSource {
    _headView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, HeadViewHeight)];
    _headView.contentMode=UIViewContentModeScaleAspectFill;
    [_headView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    //保存初始frame
    _orginallImgHeight=_headView.frame.size.height;
    //将其添加到ParallaxView
    _webHeadView=[ParallaxHeaderView parallaxHeaderViewWithSubView:_headView forSize:CGSizeMake(Screen_Width, HeadViewHeight)];
    _webHeadView.delegate=self;
    //设置Image上的titleLable
    _titleLab=[[UILabel alloc] initWithFrame:CGRectMake(15, _orginallImgHeight-80, self.view.self.frame.size.width-30, 60)];
    _titleLab.font=[UIFont systemFontOfSize:21];
    _titleLab.textColor=[UIColor whiteColor];
    _titleLab.shadowColor=[UIColor blackColor];
    _titleLab.shadowOffset=CGSizeMake(0, 1);
    _titleLab.numberOfLines=0;
    _titleLab.text=strTitle;
    [_headView addSubview:_titleLab];
    
    //设置Image上的Image_sourceLabel
    _imgSourceLab=[[UILabel alloc] initWithFrame:CGRectMake(15, _orginallImgHeight-22, self.view.frame.size.width-30, 15)];
    _imgSourceLab.font=[UIFont systemFontOfSize:9];
    _imgSourceLab.textColor=[UIColor lightGrayColor];
    _imgSourceLab.textAlignment=NSTextAlignmentRight;
    _imgSourceLab.text=[NSString stringWithFormat:@"图片%@",strImgSource];
    [_headView addSubview:_imgSourceLab];
    //将ParallaxView添加到webView下层的scrollView上
    [_webView.scrollView addSubview:_webHeadView];
}
#pragma mark 设置图片下拉放大的效果
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;//调整后初始值为0
    CGRect rect = _headView.frame;
    if (offsetY<0) {
        rect.origin.y = 0;
        rect.size.height = HeadViewHeight - offsetY;
        
        //不断设置titleLabel及sourceLabel以保证frame正确
        _titleLab.frame = CGRectMake(15, _orginallImgHeight - 80 - offsetY,Screen_Width - 30, 60);
        _imgSourceLab.frame=CGRectMake(15, _orginallImgHeight-20-offsetY, Screen_Width - 30, 15);
        _headView.frame = rect;
        
        [_webHeadView layoutWebHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }else{
        
    }
}
#pragma mark 设置滑动极限 修改该值需要一并更改
-(void)lockDirection {
    _webView.scrollView.contentOffset=CGPointMake(0, -85);
}
#pragma mark 返回按钮的响应方法
-(IBAction)backToRoot:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden=NO;

    if (_themeOpen==YES) {
        self.completion();
    }
    

}
#pragma mark 下一跳响应方法
-(IBAction)nextClick:(id)sender{
    if (_themeOpen==YES) {
        if (_n<_idArr3.count-1) {
            _n+=1;
            NSString *str1=[_idArr3 objectAtIndex:_n];
            NSString *strDetail=[path1 stringByAppendingString:[NSString stringWithFormat:@"%@",str1]];
            [self parseHTML:strDetail];
            [self textOfLable];
        }
    }
    
    
    
    //首先判断是从那里进的新闻详情
    else if (_whereOpen==NO) {
        if (_n<_pathArr1.count-1) {
            //新闻详情页面的图片
            //行号+1
            _n+=1;
            //挑选出_pathArr1中的第m个元素
            NSString *strDetail=[_pathArr1 objectAtIndex:_n];
            //解析strDetail
            [self parseHTML:strDetail];
            [self textOfLable];
        }
        
    }
    //YES
    else{
        //行号+1
        _n+=1;
        if (_n<_pathArr.count-1) {
                //挑选出_pathArr1中的第m个元素
            NSString *strDetail=[_pathArr objectAtIndex:_n];
            //解析strDetail
            [self parseHTML:strDetail];
            [self textOfLable];
        }
    }
}
#pragma mark 解析字符串 得到点赞的数量
-(IBAction)likeClick:(id)sender{
    n++;
    if (n%2==1) {
        NSInteger q=totalLikes+1;
        _totalLikes.text=[NSString stringWithFormat:@"%ld",(long)q];
    }
    if (n%2==0) {
        _totalLikes.text=[NSString stringWithFormat:@"%ld",totalLikes];
    }
    
}

-(IBAction)shareClick:(id)sender{
    
}
#pragma mark 跳转至评论界面
-(IBAction)commentClick:(id)sender{
    //当前新闻的id
    if (_whereOpen==YES) {
        _newsID=[_idArr1 objectAtIndex:_n];
    }else{
        _newsID=[_idArr2 objectAtIndex:_n];
    }
    if (_themeOpen==YES) {
        _newsID=[_idArr3 objectAtIndex:_n];
    }
    
    commentViewController *comment=[[commentViewController alloc]init];
    [comment getNewsID:_newsID];
    [self.navigationController pushViewController:comment animated:YES];
    self.navigationController.navigationBar.hidden=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
