//
//  tencentMicroBlogViewController.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/18.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "tencentMicroBlogViewController.h"
#import "personnalViewController.h"
#define account @"5678"
#define password @"1234"
@interface tencentMicroBlogViewController ()

@end

@implementation tencentMicroBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)backTologin:(id)sender{
    personnalViewController *per=[[personnalViewController alloc]initWithNibName:@"personnalViewController" bundle:[NSBundle mainBundle]];
    [self dismissViewControllerAnimated:per completion:nil];
}
-(IBAction)loginYesOrNo:(id)sender{
    NSString *str1=[NSString stringWithFormat:@"%@",_text1.text];
    NSString *str2=[NSString stringWithFormat:@"%@",_text2.text];
    if ([str1 isEqualToString:account]) {
        if ([str2 isEqualToString:password]) {
            NSLog(@"登录成功");
        }
    }else{
        NSLog(@"登录失败");
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
