//
//  themeViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/2/16.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "themeViewController.h"
#import "AppDelegate.h"
#import "UINavigationBar+Awesome.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "thenemTableViewCell.h"
#import "common.h"
#import "newsDetailViewController.h"
#import "BlurImage.h"
#define MAX_BLUR 0.2 //图片模糊最大值
#define Nav_Height 64 //导航条高度
//主题列表视图控制器

@interface themeViewController ()
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) UIImage * originImage;
@property (nonatomic, strong) UIImageView * headerImage;
@end

@implementation themeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.translucent=YES;
        [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [self initTableView];
    [self barButtonItem];
    // Do any additional setup after loading the view from its nib.
    dispatch_async(dispatch_get_main_queue(), ^{
        [_tableView reloadData];
    });
}
-(void) viewDidAppear:(BOOL)animated{
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:0/255.0 green:200.0/255.0 blue:255.0/255.0 alpha:0]];

}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)barButtonItem{
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu@2x.png"]style:UIBarButtonItemStyleDone target:self action:@selector(showLeftVC)];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)showLeftVC{
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
-(void)initTableView{
    //获取导航条的高度
    CGRect navHeight=self.navigationController.navigationBar.frame;
    NSInteger n=navHeight.size.height;
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, n+20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
-(void)getTitle:(NSString*)para{
    self.navigationItem.title=[NSString stringWithFormat:@"%@",para];
    
//    self.navigationController.navigationBar.titleTextAttributes=@{UITextAttributeFont:[UIFont boldSystemFontOfSize:20] };
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
-(void)getTheme:(NSString*)para{
    [self request:para];
    
}
-(void)request:(NSString*)para{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:para parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        _dic=[NSMutableDictionary dictionary];
        NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
        _dic=operation.responseObject;
        
        _idArr=[NSMutableArray array];
        _titleArr=[NSMutableArray array];
        
        //剥离标题
        _titleArr=[_dic objectForKey:@"stories"];
        //剥离id
        for (int i=0; i<_titleArr.count; i++) {
            dic1=[_titleArr objectAtIndex:i];
            NSString *str1=[dic1 objectForKey:@"id"];
            [_idArr addObject:[NSString stringWithFormat:@"%@",str1]];
            
    }
        //剥离主题的背景图片
        _backGround=[_dic objectForKey:@"background"];
           [self setNavigationBar];
        //主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        //网络请求失败的时候
        NSLog(@"ERROR");
    }];
 
    
}
-(void)setNavigationBar{
    //设置UINavigationBar全透明，此处随便设置一张图片即可
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bigShadow.png"] forBarMetrics:UIBarMetricsCompact];
    //裁剪多余的图片
    self.navigationController.navigationBar.layer.masksToBounds=YES;
    //当 automaticallyAdjustsScrollViewInsets 为 NO 时，视图 是从屏幕的最上边开始，也就是被导航栏 & 状态栏覆盖
    // 为YES时，视图从导航条的下方位置开始
    self.automaticallyAdjustsScrollViewInsets=YES;
    CGFloat imageWidth=CGRectGetWidth(self.view.bounds);
    _imageHeight=Nav_Height;
    //图像视图 UIImage对象 初始化
    if (_headerImage==nil) {
        _originImage=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_backGround]]];
        NSLog(@"~~~%@",_backGround);
        [_headerImage sd_setImageWithURL:[NSURL URLWithString:_backGround] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageUrl){
            [self imagefileHandle:image path:_backGround.lastPathComponent];
        }];
        
        _headerImage=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWidth, _imageHeight)];
    }
    _headerImage.image=_originImage;
    _headerImage.contentMode=UIViewContentModeScaleAspectFill;
    _headerImage.clipsToBounds=YES;
    //sd_webImage 异步加载网络图片
    self.headerImage.tag=Nav_ImageTag;
    //导航栏添加图像视图
    [self.navigationController.view insertSubview:self.headerImage belowSubview:self.navigationController.navigationBar];

}
//图片文件保存读取操作
//image 图片对象
//fileName 图片文件名
-(void)imagefileHandle:(UIImage *)image path:(NSString *)fileName {
    //将图片文件保存至本地
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];//保存文件的名称
    BOOL result=[UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    //读取图片文件
    _originImage=[UIImage imageNamed:filePath];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>-Nav_Height) {
        return;
    }
    if (_originImage==nil){
        return;}
    //fabs 取绝对值
    CGFloat offsetY=fabs(Nav_Height-fabs(_tableView.contentOffset.y));
    CGRect frame=_headerImage.frame;
    frame.size.height=Nav_Height+offsetY;
    _headerImage.frame=frame;
    //计算显示毛玻璃效果的透明度
    float delta=(fabs(250-offsetY)/250*MAX_BLUR);
    if (offsetY>250) {
        delta=0;
    }
    _headerImage.image=[BlurImage blurryImage:_originImage withBlurLevel:delta];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    newsDetailViewController *news=[[newsDetailViewController alloc]init];
    newsDetailViewController *detailViewCon=[[newsDetailViewController alloc]initWithNibName:@"newsDetailViewController" bundle:[NSBundle mainBundle]];
    [detailViewCon receiveNewsPath:_idArr number:indexPath buer:YES];
    [self.navigationController pushViewController:detailViewCon animated:YES];
    [self deleteNavigationImage];
    detailViewCon.completion=^(){
        //重置导航条图片
        [self setNavigationBar];
        //将导航栏隐藏
        self.navigationController.navigationBar.hidden=NO;
        //导航栏隐藏后顶部会留出空白问题。设置为no，让顶部不留空白
        self.automaticallyAdjustsScrollViewInsets=YES;
    };

}
-(void)deleteNavigationImage{
    //打开首页的时候将所有打开过的主题试图控制器关闭
    for (int i=0; i<[self.navigationController.viewControllers count]; i++) {
        UIViewController *vc=[self.navigationController.viewControllers objectAtIndex:i];
        //将导航条上的图片删除
        UIImageView *imageView=[vc.navigationController.view viewWithTag:Nav_ImageTag];
        [imageView removeFromSuperview];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titleArr.count;
}
//获取分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cell";
    thenemTableViewCell *cell=(thenemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:ID];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic=[_titleArr objectAtIndex:indexPath.row];
    //更新表格
    if (cell==nil&&dic.count==3) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"thenemTableViewCell" owner:self options:nil] lastObject];
        [cell updateCell:dic];
    }
    if (cell==nil&&dic.count==4) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"thenemTableViewCell" owner:self options:nil] lastObject];
        [cell updateCellWithPic:dic];
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
