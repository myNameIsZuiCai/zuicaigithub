//
//  leftSortViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/13.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "leftSortViewController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "ViewController.h"
#import "personnalViewController.h"
#import "collectionViewController.h"
#import "downLoadViewController.h"
#import "setTableViewController.h"
#import "common.h"
#import "themeViewController.h"
//#import "themeViewController.h"
//#import "setViewController.h"
#define headImage1 @"2.png"
@interface leftSortViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation leftSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initLeftTableView];
    
    [self getThemeFromServer:theme];

    // Do any additional setup after loading the view.
    
    
}
-(void)getThemeFromServer:(NSString*)para{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:para parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        _themeDic=[NSMutableDictionary dictionary];
        _themeArr=[NSMutableArray array];
        _other=[NSMutableArray array];
        _themeDic=operation.responseObject;
        _themeArr=_themeDic[@"others"];
        //遍历dic
        for (int i=0; i<_themeArr.count; i++) {
            NSMutableDictionary *dic1=[_themeArr objectAtIndex:i];
            NSString *str1=[dic1 objectForKey:@"name"];
            [_other addObject:[NSString stringWithFormat:@"%@",str1]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.description);
    }];
}

#pragma mark 初始化左边的表格视图
-(void)initLeftTableView{
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageview.backgroundColor=[UIColor blackColor];
    [self.view addSubview:imageview];
    
    _tableView = [[UITableView alloc] init];
    self.tableview = _tableView;
    _tableView.frame = self.view.bounds;
    _tableView.dataSource = self;
    _tableView.delegate  = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}
#pragma mark 每个分区的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}


#pragma mark 自定义表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *Identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        if (indexPath.row==0) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        }
        if (indexPath.row>0) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        
}
    //右箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0f];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == 0) {
        cell.textLabel.text=@"首页";
        cell.textLabel.textColor=[UIColor grayColor];
        cell.imageView.image=[UIImage imageNamed:@"Dark_Menu_Icon_Home@2x.png"];
}
    if (indexPath.row >0) {
        for (int i=1;i<_other.count; i++) {
            if (indexPath.row==i) {
                NSString *str=_other[indexPath.row-1];
                cell.textLabel.text=[NSString stringWithFormat:@"%@",str];
                cell.textLabel.textColor=[UIColor grayColor];
            }
            
        }

    }
    
    return cell;
}
#pragma mark 确定选择
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row==0) {
        //关闭左侧视图控制器第三方框架里的东西
        [tempAppDelegate.leftSlideVC closeLeftView];//关闭左侧抽屉
        ViewController *vc=[[ViewController alloc]init];
        [tempAppDelegate.mainNavigationController pushViewController:vc animated:YES];
    
        [tempAppDelegate deleteNavigationImage];
        self.navigationController.navigationBar.hidden=NO;
        
    }
    //确定在表格中选择的单元格的行号,在数组_other中抽取相应元素
    if (indexPath.row>0) {
        NSInteger n;
        n=indexPath.row;
        n-=1;
        //将theme与n相追加
        NSMutableDictionary *themeA=[NSMutableDictionary dictionary];
        themeA=[_themeArr objectAtIndex:n];
        //从themeA中剥离id
        NSString *strID=[themeA objectForKey:@"id"];
        //将theme1与strID相追加
        NSString *themeB=[theme1 stringByAppendingString:[NSString stringWithFormat:@"%@",strID]];
        NSString *themeC=[_other objectAtIndex:n];
        themeViewController *themePort=[[themeViewController alloc]initWithNibName:@"themeViewController" bundle:[NSBundle mainBundle]];
        [themePort getTheme:themeB];
        [themePort getTitle:themeC];
        [tempAppDelegate.leftSlideVC closeLeftView];
        [tempAppDelegate.mainNavigationController pushViewController:themePort animated:YES];
        self.navigationController.navigationBar.hidden=YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    q=[UIScreen mainScreen].bounds.size.height/7*2;
    return q;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

#pragma mark 自定义头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSInteger w=self.tableview.bounds.size.width;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, q)];
    view.backgroundColor = [UIColor clearColor];
    //将view分为三部分登录、收藏、离线下载
    //loginView,将loginView分为两button
    UIView *loginView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w/3*2, q/3)];
    loginView.backgroundColor=[UIColor clearColor];
    login=[[UIButton alloc]initWithFrame:CGRectMake(w/3, 0, w/3, q/3)];
    //背景图片
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w/3, q/3)];
    //为headImage添加tap手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapEvent:)];
    [loginView addGestureRecognizer:tap];
    
    headImage.image=[UIImage imageNamed:@"Account_Avatar@2x.png"];
    headImage.layer.masksToBounds=YES;
    headImage.layer.cornerRadius=35;
    
    [login setTitle:@"请登录" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [login setTitleColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    
    //collectionView
    UIView *collection=[[UIView alloc]initWithFrame:CGRectMake(0, q/3*2, w/2, q/3)];
    collection.backgroundColor=[UIColor clearColor];
    UIButton *collImage=[[UIButton alloc]initWithFrame:CGRectMake(0, q/3*2, w/5, q/4)];
    [collImage addTarget:self action:@selector(showCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    collectionText=[[UIButton alloc]initWithFrame:CGRectMake(w/4, q/3*2, w/5, q/4)];
    [collectionText setTitle:@"收藏" forState:UIControlStateNormal];
    [collectionText setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [collectionText addTarget:self action:@selector(showCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    collImage.backgroundColor=[UIColor clearColor];
    collectionText.backgroundColor=[UIColor clearColor];
    [collImage setBackgroundImage:[UIImage imageNamed:@"Dark_Menu_Icon_Collect@2x.png"] forState:UIControlStateNormal];
    //downLoad
    UIView *downLoad=[[UIView alloc]initWithFrame:CGRectMake(w/2, q/3*2, w/2, q/3)];
    downLoad.backgroundColor=[UIColor clearColor];
    UIButton *downImage=[[UIButton alloc]initWithFrame:CGRectMake(w/2, q/3*2, w/5, q/4)];
    downImage.backgroundColor=[UIColor clearColor];
    [downImage setBackgroundImage:[UIImage imageNamed:@"Menu_Download@2x.png"] forState:UIControlStateNormal];
    downText=[[UIButton alloc]initWithFrame:CGRectMake(w/4*3, q/3*2, w/5, q/4)];
    [downText setTitle:@"下载" forState:UIControlStateNormal];
    [downText setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [downImage addTarget:self action:@selector(showDownloadView:) forControlEvents:UIControlEventTouchUpInside];
    [downText addTarget:self action:@selector(showDownloadView:) forControlEvents:UIControlEventTouchUpInside];

    /*headImage
     collection
     downLoad*/
    [tableView addSubview:loginView];
    [tableView addSubview:headImage];
    [tableView addSubview:collection];
    [tableView addSubview:downLoad];
    [tableView addSubview:login];
    [tableView addSubview:collImage];
    [tableView addSubview:collectionText];
    [tableView addSubview:downImage];
    [tableView addSubview:downText];
    
    return view;
}
#pragma mark 创建设置白天夜间按钮
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //将UIView（allView）分为两部分：setView、dayOrNight
    float w=self.view.bounds.size.width;
    float h=self.view.bounds.size.height/14;
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0,h , w, h)];
    footView.backgroundColor=[UIColor clearColor];
    //创建setView，创建两个button
    UIView *setView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, w/4, h)];
    setView.backgroundColor=[UIColor clearColor];
    
    setImage=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, w/8, h)];
    setImage.backgroundColor=[UIColor blackColor];
    
    setTitle=[[UIButton alloc]initWithFrame:CGRectMake(w/8, 0, w/8, h)];
    setTitle.backgroundColor=[UIColor blackColor];
    [setImage setImage:[UIImage imageNamed:@"Dark_Menu_Icon_Setting@2x.png"] forState:UIControlStateNormal];
    [setTitle setTitle:@"设置" forState:UIControlStateNormal];
    [setTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [setTitle addTarget:self action:@selector(showSetViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [setImage addTarget:self action:@selector(showSetViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    //创建dayOrNightView
    UIView *dayOrNightView=[[UIView alloc]initWithFrame:CGRectMake(w/4, 0, w/4, h)];
    dayOrNightView.backgroundColor=[UIColor blackColor];
    dayOrNightImage=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, w/8, h)];
    dayOrNightTitle=[[UIButton alloc]initWithFrame:CGRectMake(w/8, 0, w/8, h)];
    [dayOrNightImage setImage:[UIImage imageNamed:@"Menu_Dark@2x.png"] forState:UIControlStateNormal];
    [dayOrNightImage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dayOrNightTitle setTitle:@"夜间" forState:UIControlStateNormal];
    [dayOrNightTitle setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    
    [dayOrNightTitle addTarget:self action:@selector(changeState:) forControlEvents:UIControlEventTouchUpInside];
    [setView addSubview:setImage];
    [setView addSubview:setTitle];
    [dayOrNightView addSubview:dayOrNightImage];
    [dayOrNightView addSubview:dayOrNightTitle];
    [footView addSubview:setView];
    [footView addSubview:dayOrNightView];
    return footView;
}

#pragma mark 改变抽屉视图
-(void)changeState:(id)sender{
    if ([dayOrNightTitle.currentTitle isEqualToString:@"夜间"]) {
        [dayOrNightTitle setTitle:@"白天" forState:UIControlStateNormal];
        [dayOrNightImage setImage:[UIImage imageNamed:@"Menu_Day@2x.png"] forState:UIControlStateNormal];
        
        setImage.backgroundColor=[UIColor whiteColor];
        setTitle.backgroundColor=[UIColor whiteColor];
        dayOrNightImage.backgroundColor=[UIColor whiteColor];
        dayOrNightTitle.backgroundColor=[UIColor whiteColor];
        _tableView.backgroundColor=[UIColor whiteColor];
    }else if([dayOrNightTitle.currentTitle isEqualToString:@"白天"]){
        [dayOrNightTitle setTitle:@"夜间" forState:UIControlStateNormal];
        [dayOrNightImage setImage:[UIImage imageNamed:@"Menu_Dark@2x.png"] forState:UIControlStateNormal];
        setImage.backgroundColor=[UIColor blackColor];
        setTitle.backgroundColor=[UIColor blackColor];
        dayOrNightImage.backgroundColor=[UIColor blackColor];
        dayOrNightTitle.backgroundColor=[UIColor blackColor];
        _tableView.backgroundColor=[UIColor blackColor];
    }else{
        return;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 跳转到个人资料页面
-(void)tapEvent:(id)sender{
    NSLog(@"123");
    personnalViewController *per=[[personnalViewController alloc]initWithNibName:@"personnalViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:per animated:YES completion:nil];
}
#pragma mark 显示设置界面
-(void)showSetViewController:(id)sender{
    UIStoryboard *stor=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    setTableViewController *Set=(setTableViewController *)[stor instantiateViewControllerWithIdentifier:@"Set"];
    [self presentViewController:Set animated:YES completion:nil];
}
#pragma mark 显示收藏视图
-(void)showCollectionView:(id)sender{
    collectionViewController *collection=[[collectionViewController alloc]initWithNibName:@"collectionViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:collection animated:YES completion:nil];
}
#pragma mark 显示下载视图
-(void)showDownloadView:(id)sender{
    downLoadViewController *download=[[downLoadViewController alloc]initWithNibName:@"downLoadViewController" bundle:[NSBundle mainBundle]];
    [self presentViewController:download animated:YES completion:nil];
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
