//
//  sinaMicroBlogViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/18.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "sinaMicroBlogViewController.h"
#import "personnalViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#define account @"5678"
#define password @"1234"
@interface sinaMicroBlogViewController ()

@end

@implementation sinaMicroBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
-(IBAction)backTologin:(id)sender{
    personnalViewController *per=[[personnalViewController alloc]initWithNibName:@"personnalViewController" bundle:[NSBundle mainBundle]];
    [self dismissViewControllerAnimated:per completion:nil];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(IBAction)loginYesOrNo:(id)sender{
    NSString *str1=[NSString stringWithFormat:@"%@",_text1.text];
    NSString *str2=[NSString stringWithFormat:@"%@",_text2.text];
    if ([str1 isEqualToString:account]) {
        if ([str2 isEqualToString:password]) {
            NSLog(@"登录成功");
            //退回viewController
            ViewController *vc=[[ViewController alloc]init];
            [vc sender:FALSE];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }else{
        NSLog(@"登录失败");
    }
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
