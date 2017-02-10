//
//  personnalViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/14.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "personnalViewController.h"
#import "AppDelegate.h"
#import "sinaMicroBlogViewController.h"
#import "tencentMicroBlogViewController.h"

@interface personnalViewController ()

@end

@implementation personnalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
-(IBAction)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)sinaClick:(id)sender{
    sinaMicroBlogViewController *sina=[[sinaMicroBlogViewController  alloc]init];
    [self presentViewController:sina animated:YES completion:nil];
}
-(IBAction)tencentClick:(id)sender{
    tencentMicroBlogViewController *tencent=[[tencentMicroBlogViewController alloc]init];
    [self presentViewController:tencent animated:YES completion:nil];
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
