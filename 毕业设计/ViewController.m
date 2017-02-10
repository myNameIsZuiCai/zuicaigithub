//
//  ViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import "StoriesEntity.h"
#import "baseInfo.h"
#import "common.h"
#import "newsTableViewCell.h"
#import "newsDetailViewController.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "StoryRequest.h"
#import "leftSortViewController.h"
#define Row_Height 90
#define Section_Height 45

#define rows @"Rows"
#define launchScreen @"http://news-at.zhihu.com/api/4/start-image/720*1184"
#define TopView_Top 1001
#define TopView_Top_Tag 2001
#define ScrollView_Tag 3001
#define NavTitleView_Tag 4001
#define TopView_Height [UIScreen mainScreen].bounds.size.height/3.0f

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationController.navigationBar.layer.masksToBounds=NO;
    navLable=[[UILabel alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width,self.navigationController.navigationBar.bounds.size.height)];
    navLable.backgroundColor=[UIColor clearColor];
    navLable.textColor=[UIColor blackColor];
    navLable.textAlignment=UITextAlignmentCenter;
    [navLable setFont:[UIFont systemFontOfSize:18.0]];
    [navLable setText:@"今日热闻"];
    self.navigationItem.titleView=navLable;
    
    _stories=[NSMutableArray array];
    _isNeting=FALSE;
    [self getDataFromServer];
    [self initTableView];
    [self headerOrFooterUpdate];
    [self initcycleScrollView];
    [self initNavigationBar];
    
    //上拉获取数据
    _tableView.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [_tableView.mj_footer beginRefreshing];
        
        [_tableView.mj_footer endRefreshing];
    }];

}
-(void) viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)initNavigationBar{
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(openOrCloseLeftList)];
    
    self.navigationItem.leftBarButtonItem=leftItem;
}
#pragma mark 上拉的时候请求新数据
-(void)headerOrFooterUpdate{
        [_tableView reloadData];
}
#pragma mark 获取最近指定日期的数据
-(void)AsyncRequestRecent:(NSString *)strDate {
    if (_isNeting) {
        return;
    }
    NSString *newDate=[common date:strDate addDays:ndays];
    _isNeting=YES;
    StoryRequest *sRequest=[StoryRequest sharedInstance];
    _storiesArr2=[NSMutableArray array];

    [sRequest recentStories_Request:newDate success:^(NSMutableDictionary *dStories){
        [_stories addObject:dStories];
        _storiesArr2=dStories[Stories];
        _idArr2=[NSMutableArray array];//存放上拉数据id的数组
        for (int i=0; i<_storiesArr2.count; i++) {
            StoriesEntity *sEntity=_storiesArr2[i];
            [_idArr addObject:[NSString stringWithFormat:@"%ld",sEntity.nid]];
            [_idArr2 addObject:[NSString stringWithFormat:@"%ld",sEntity.nid]];
}
        
        [_countArr addObject:[NSString stringWithFormat:@"%ld",_idArr2.count]];
        //记录当天一共有多少条新闻
        timeDate=dStories[Dateabc];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            _isNeting=FALSE;
        });
    }fail:^(NSError *error){
        _isNeting=FALSE;
        NSLog(@"error%@",error.description);
    }];
    
}
#pragma mark 上拉获取数据
-(void)RecentQuery{
    NSMutableDictionary *dDict=[_stories lastObject];
    [self AsyncRequestRecent:dDict[Dateabc]];
}
#pragma mark 请求新数据
-(void)loadNewData{
        AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
        [manager GET:server parameters:Nil success:^(AFHTTPRequestOperation *operation,id responseObject){
            //请求成功的时候
            //获取服务器返回的数据(字典)
            _dic=[NSMutableDictionary dictionary];
            _dic=operation.responseObject;
            //获取服务器返回的数据，NSData格式的
            NSData *data=operation.responseData;
            //将请求到的数据转换为字典
            NSMutableDictionary *ms=[StoriesEntity ParseData:data];
            _storiesDic=ms;
            //_storiesArr=ms[Stories];
            //获得stories相对应的值
            [_stories addObject:_storiesDic];
            NSMutableArray *_arr1=[NSMutableArray array];
            _arr1=[_dic objectForKey:@"stories"];
            //遍历_arr1得到数组的每一个元素(每一个元素又是一个字典)
            //eachElement每一条新闻
            NSMutableDictionary *eachElement=[NSMutableDictionary dictionary];
            
            for (int i=0; i<_arr1.count; i++) {
                eachElement=[_arr1 objectAtIndex:i];
                //从eachElement中剥离id,将id存放在_idArr中
                NSString  *obj=[eachElement objectForKey:@"id"];
                [_idArr addObject:obj];
            }
            _topStoriesArr=ms[TopStories];
            //获得top_stories相对应的值
            NSMutableArray *_arr2=[NSMutableArray array];
            _arr2=[_dic objectForKey:@"top_stories"];
            //剥离_arr2中的id
            NSMutableDictionary *eachElement1=[NSMutableDictionary dictionary];
            _idArr1=[NSMutableArray array];
            for (int i=0; i<_arr2.count; i++) {
                eachElement1=[_arr2 objectAtIndex:i];
                //从eachElement中剥离id,将id存放在_idArr中
                NSString  *obj=[eachElement1 objectForKey:@"id"];
                [_idArr1 addObject:obj];
            }
            //主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [self updateHeaderView];
            });
        } failure:^(AFHTTPRequestOperation *operation,NSError *error){
            //网络请求失败的时候
            NSLog(@"ERROR");
        }];
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
        [self updateHeaderView];
        [_tableView reloadData];
    });
        //终止下拉刷新的动画效果
        [_tableView.mj_header endRefreshing];
}

#pragma mark 打开或关闭抽屉视图
-(void)openOrCloseLeftList{
    AppDelegate *tempAppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //判断左侧试图控制器是否关闭
    if (tempAppDelegate.leftSlideVC.closed) {
        //打开视图控制器
        [tempAppDelegate.leftSlideVC openLeftView];
    }else{
        //左侧试图控制器关闭
        [tempAppDelegate.leftSlideVC closeLeftView];
    }
}

#pragma mark 初始化表格视图
-(void)initTableView{
    //表格式图的大小为整个屏幕的大小
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+20) style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark 确定分区数目
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _stories.count;
}
#pragma mark 分区中的单元格数目
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //得到所有的部分
    NSMutableDictionary *dDict=[_stories objectAtIndex:section];
    //得到每个部分所有的新闻
    NSMutableArray *newsArr=[dDict objectForKey:Stories];
    return newsArr.count;
}
#pragma mark 设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}
#pragma mark 设置头部视图的高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
#pragma mark 为每个部分的header定制标题
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableDictionary *dDict=[_stories objectAtIndex:section];
    //获得日期
    NSDate *date=[common dateFromString:dDict[Dateabc]];
    //将得到的日期转换为-月-日形式
    NSString *strDate=[common stringMMDDFromDate:date];
    //获取星期几
    NSString *strWeek=[common stringWeek:date];
    //开始定制头部视图
    
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 64)];
    headView.backgroundColor=[UIColor colorWithRed:15/255.0 green:122/255.0 blue:204/255.0 alpha:1.0];
    //标题的label
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 64)];
    title.text=[NSString stringWithFormat:@"%@ %@",strDate,strWeek];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont systemFontOfSize:18];
    title.textAlignment=NSTextAlignmentCenter;
    [headView addSubview:title];
    if (section==0) {
        headView.hidden=YES;
    }
    //终止下拉刷新的动画效果
    return headView;
}

#pragma mark 滑动视图添加图片和标题
-(void)updateHeaderView {
    _pageController.numberOfPages=_topStoriesArr.count;
     NSMutableArray *mImgArr=[NSMutableArray array];
    NSMutableArray *mTitleArr=[NSMutableArray array];
    for (int i=0; i<[_topStoriesArr count]; i++){
        StoriesEntity *sEntity=[_topStoriesArr objectAtIndex:i];
        [mImgArr addObject: sEntity.image];
        [mTitleArr addObject:sEntity.title];
    }
    _cycleScrollView.imageURLStringsGroup=mImgArr;
    _cycleScrollView.titlesGroup=mTitleArr;
}
#pragma mark 滑动视图的自动滚动
-(void) initcycleScrollView{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _scrollViewHeight=self.view.frame.size.height*0.35;
    CGFloat screenHeight=_scrollViewHeight;
    _cycleScrollView=[[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    _cycleScrollView.infiniteLoop = true;
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _cycleScrollView.autoScrollTimeInterval = 6.0;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;

    _cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    _cycleScrollView.titleLabelHeight = 60;
    
    //alpha在未设置的状态下默认为0
    _cycleScrollView.titleLabelAlpha = 1;
    
    ParallaxHeaderView *headerView=[ParallaxHeaderView parallaxHeaderViewWithSubView:_cycleScrollView forSize:_cycleScrollView.frame.size];
    [_tableView setTableHeaderView:headerView];

}
#pragma mark cycleScrollView的delegate方法（切换到新闻详情）
-(void) cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    newsDetailViewController *detailViewController=[[newsDetailViewController alloc]initWithNibName:@"newsDetailViewController" bundle:[NSBundle mainBundle]];
    [detailViewController topStoriesidArrAndIndexPath:_idArr1 Row:index topOrBottom:NO];
    
    [self.navigationController pushViewController:detailViewController animated:YES];

}
#pragma mark 用来判断滑动的当前视图(图片)是第几个页面
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //实现顶部视图的上拉缩小下拉放大
    [(ParallaxHeaderView *)_tableView.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    NSInteger nPage=(NSInteger)(scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width);
    _pageController.currentPage=nPage;
    //设置标题栏透明度(导航条的渐变)
    float nOffsetY=scrollView.contentOffset.y;
    if (nOffsetY<_scrollViewHeight) {
        CGFloat nAlpha=nOffsetY/(_scrollViewHeight-64.0f);
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0/255.0 green:200.0/255.0 blue:255.0/255.0 alpha:nAlpha]];
    }
    
    //刷新标题栏文本
    float move=scrollView.contentOffset.y;
    [self setNavigationTitle:move];
    //获取可见单元格
    NSArray *cellIndex=[_tableView indexPathsForVisibleRows];
    if (!cellIndex|| cellIndex.count<=0) {
        return;
    }
    
    NSIndexPath *indexPath=cellIndex[0];
    if (indexPath.section+1==[_stories count] &&indexPath.row==0) {
        [self RecentQuery];
    }
    if (indexPath.section<=1) {
        if (indexPath.section==0) {
            _NavView.hidden=NO;
            [self updateNavView:@"今日热闻"];
        }
               self.navigationController.navigationBar.hidden=NO;
        if (indexPath.section==1) {

          self.navigationController.navigationBar.hidden=NO;
        }else{
            self.navigationController.navigationBar.hidden=NO;
        }
    }
    else {
        self.navigationController.navigationBar.hidden=NO;
    }

}

#pragma mark 设置表格滑动的时候标题
-(void) setNavigationTitle:(CGFloat) fOffsetY{
    if (_stories.count==0) {
        return;
    }
    NSMutableDictionary *titleDic=[_stories objectAtIndex:0];
    NSMutableArray *arr1=[titleDic objectForKey:Stories];

    float firstRowFight=TopView_Height+arr1.count*Row_Height;
    if (fOffsetY<=firstRowFight) {
        [self updateNavView:@"今日热闻"];
    }
    float totalHeight=firstRowFight;
    for (int iIndex=1; iIndex<[_stories count]; iIndex++) {
        NSMutableDictionary *dict=[_stories objectAtIndex:iIndex ];
        NSMutableArray *mArr=[dict objectForKey:Stories];
        float sections_height=Section_Height+1;
        float rows_height=mArr.count*Row_Height;
        float overFlowSection=sections_height+rows_height;
        totalHeight+=overFlowSection;
        if (totalHeight>=fOffsetY) {
            NSString *sectionTitle=[self sectionTitle:iIndex];
            [self updateNavView:sectionTitle];
            break;
        }
    }
    
}
#pragma mark 获取分区标题
-(NSString *) sectionTitle:(NSInteger) nSec{
    NSMutableDictionary *dDict=[_stories objectAtIndex:nSec];
    NSDate *date=[common dateFromString:dDict[Dateabc]];
    NSString *strDate=[common stringMMDDFromDate:date];
    NSString *strWeek=[common stringWeek:date];
    return  [NSString stringWithFormat:@"%@ %@", strDate,strWeek];
}
#pragma mark 更新导航条
-(void)updateNavView:(NSString *)strTitle {
    navLable.text=strTitle;
}

#pragma mark 每一行单元格所显示的数据
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    newsTableViewCell *cell=(newsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    //更新表格
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"newsTableViewCell" owner:self options:nil] lastObject];
    }
    NSMutableDictionary *dDict=[_stories objectAtIndex:indexPath.section];
    NSMutableArray *dStoriesArr=[dDict objectForKey:Stories];
    //更新新闻cell的内容以及图片
    [cell updateCell:[dStoriesArr objectAtIndex:indexPath.row] date:timeDate];
    //计算目前的新闻总数，即_storiesArr.count    
    return cell;
}
#pragma mark 从服务器获得数据
-(void)getDataFromServer{
    //异步解析
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:server parameters:Nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        //请求成功的时候
        //获取服务器返回的数据(字典)
        _dic=[NSMutableDictionary dictionary];
        _dic=operation.responseObject;
        //获取服务器返回的数据，NSData格式的
        NSData *data=operation.responseData;
        //将请求到的数据转换为字典
        NSMutableDictionary *ms=[StoriesEntity ParseData:data];
        _storiesDic=ms;
        timeDate=ms[Dateabc];
        _storiesArr=ms[Stories];
        _stories=[NSMutableArray array];
        [_stories addObject:_storiesDic];
        //获得stories相对应的值
        NSMutableArray *_arr1=[NSMutableArray array];
        _arr1=[_dic objectForKey:@"stories"];
        //遍历_arr1得到数组的每一个元素(每一个元素又是一个字典)
        //eachElement每一条新闻
        NSMutableDictionary *eachElement=[NSMutableDictionary dictionary];
        
        _idArr=[NSMutableArray array];//第一批数据的id
        _idAll=[NSMutableArray array];//存放id数组的数组
        _countArr=[NSMutableArray array];
        _tempArr=[NSMutableArray array];//临时的数组
        for (int i=0; i<_arr1.count; i++) {
            eachElement=[_arr1 objectAtIndex:i];
            //从eachElement中剥离id,将id存放在_idArr中
            NSString  *obj=[eachElement objectForKey:@"id"];
            [_idArr addObject:obj];
            [_tempArr addObject:obj];
        }
        //_tempArr的数量
        [_countArr addObject:[NSString stringWithFormat:@"%ld",_tempArr.count]];
        
        _topStoriesArr=ms[TopStories];
        //获得top_stories相对应的值
        NSMutableArray *_arr2=[NSMutableArray array];
        _arr2=[_dic objectForKey:@"top_stories"];
        //剥离_arr2中的id
        NSMutableDictionary *eachElement1=[NSMutableDictionary dictionary];
        _idArr1=[NSMutableArray array];
        for (int i=0; i<_arr2.count; i++) {
            eachElement1=[_arr2 objectAtIndex:i];
            //从eachElement中剥离id,将id存放在_idArr中
            NSString  *obj=[eachElement1 objectForKey:@"id"];
            [_idArr1 addObject:obj];
        }
        
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateHeaderView];
            [_tableView reloadData];
            
        });
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        //网络请求失败的时候
        NSLog(@"ERROR");
    }];
}
#pragma mark 点击跳转新视图
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    newsDetailViewController *newsDetail=[[newsDetailViewController alloc]initWithNibName:@"newsDetailViewController" bundle:[NSBundle mainBundle]];
    NSInteger n;
    NSInteger m=indexPath.section;
    NSInteger total=0;
    NSString *str;
    
    
    //计算当前点击新闻是数组中的第几个
    if (indexPath.section==0) {
        n=indexPath.row;
    }else{
        for (int i=0; i<m; i++) {
            //取得数组_countArr中的前m-1个元素
            str=[_countArr objectAtIndex:i];
            NSInteger jiashu=[str integerValue];
            total += jiashu;
        }
    }
    total=total+indexPath.row;
    [newsDetail receiveidArrAndIndexPath1:_idArr number:total Row:indexPath topOrBottom:YES];
    //将导航栏隐藏
    self.navigationController.navigationBar.hidden=NO;
    //跳转新视图
    newsDetail.navigationController.navigationBar.hidden=YES;
//    [self presentViewController:newsDetail animated:YES completion:nil];
    [self.navigationController pushViewController:newsDetail animated:YES];
    
    
}
-(void)sender:(BOOL)flag{
    _bflag=flag;
}

#pragma mark 请求主题数据
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
