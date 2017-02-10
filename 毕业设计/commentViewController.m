//
//  commentViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/28.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "commentViewController.h"
#import "common.h"
#import "NewDerailJson.h"
#import "AFNetworking.h"
#import "aboutCommentTableViewCell.h"
@interface commentViewController ()

@end

@implementation commentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initTableView];
    [self whiteComment];
    [self changeNavigationBar];
}
-(void)changeNavigationBar{
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Browser_Icon1_Back_Highlight@2x.png"] style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem=leftItem;
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden=NO;
}
-(void)initTableView{
    _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    _shortCommentArr=[NSMutableArray array];
    _commentArr=[NSMutableArray array];
}
-(void)whiteComment{
    UIView *writeView=[[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, [UIScreen mainScreen].bounds.size.width, 50)];
    writeView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:writeView];
    //返回按钮
    UIButton *back=[[UIButton alloc]initWithFrame:CGRectMake(0, 0,50, 50)];
    [back setImage:[UIImage imageNamed:@"Login_Arrow"] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backToNewsDetail:) forControlEvents:UIControlEventTouchUpInside];
    [writeView addSubview:back];
    [self getLongCommentFromServer];
}
-(void)backToNewsDetail:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getLongCommentFromServer{
    //初始化评论字典
    _CommentDic=[NSMutableDictionary dictionary];
    valueLong=[NSMutableArray array];
    //组合评论的地址
    NSString *str1=[NSString stringWithFormat:@"%@",longComment];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",_strID]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:str2 parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        _CommentDic=operation.responseObject;
        valueLong=_CommentDic[@"comments"];
        [self getShortCommentFromServer];

    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.description);
    }];
}
-(void)getShortCommentFromServer{
    _shortComDic=[NSMutableDictionary dictionary];
    valueShort=[NSMutableArray array];
    //组合评论的地址
    NSString *str1=[NSString stringWithFormat:@"%@",shortComment];
    NSString *str2=[str1 stringByReplacingOccurrencesOfString:@"#{id}" withString:[NSString stringWithFormat:@"%@",_strID]];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:str2 parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject){
        _shortComDic=operation.responseObject;
        valueShort=_shortComDic[@"comments"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        NSLog(@"%@",error.description);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getNewsID:(NSString*)para{
    _strID=para;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
#pragma mark 每一个分区的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger nCount=0;
    switch (section) {
            
        case 0:
            nCount=[valueLong count];
            
            break;
            
        case 1:
            nCount=[valueShort count];
           
            break;
            
        default:
            break;
    }
    
    return nCount;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strCell=@"comment";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"aboutCommentTableViewCell" owner:self options:nil]lastObject];
    }
    NSMutableArray *mArr=[NSMutableArray array];
    switch (indexPath.section) {
        case 0:
            mArr=[valueLong mutableCopy];
            break;
            case 1:
            mArr=[valueShort mutableCopy];
        default:
            break;
    }
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic=[mArr objectAtIndex:indexPath.row];
    aboutCommentTableViewCell *newsCell=(aboutCommentTableViewCell*)cell;

    [newsCell UpdateNewCell:dic IndexPath:indexPath];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *textHeight=nil;
    NSInteger height;
    NSMutableArray *arr=[NSMutableArray array];
    switch (indexPath.section) {
        case 0:
            arr=[valueLong mutableCopy];
            break;
            case 1:
            arr=[valueShort mutableCopy];
        default:
            break;
    }
    NSMutableDictionary *mDic=[NSMutableDictionary dictionary];
    mDic=[arr objectAtIndex:indexPath.row];
    textHeight=mDic[@"content"];
    CGRect rect=[textHeight boundingRectWithSize:CGSizeMake(300, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];
    height=rect.size.height+100;
    
    return height;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *str=[NSString string];
    NSInteger nCount;
    switch (section) {
        case 0:
            nCount=[valueLong count];
            str=[NSString stringWithFormat:@"%ld条长评论",nCount];
            break;
            case 1:
            nCount=[valueShort count];
            str=[NSString stringWithFormat:@"%ld条短评论",nCount];
        default:
            break;
    }
    return str;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
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
