//
//  AppDelegate.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftSortViewController.h"
#import "AFNetworking.h"
#import "common.h"
#import "UIImageView+WebCache.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //导航条
    self.window=[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //创建视图控制器对象
    ViewController *vViewController=[[ViewController alloc] init];
    self.mainNavigationController=[[UINavigationController alloc]initWithRootViewController:vViewController];
   
    //左侧视图控制器对象
    leftSortViewController *leftVc=[[leftSortViewController alloc]init];

    //实现抽屉效果的视图控制器
    self.leftSlideVC=[[LeftSlideViewController alloc]initWithLeftView:leftVc andMainView:self.mainNavigationController];
    self.window.rootViewController=self.leftSlideVC;
    [self.window makeKeyAndVisible];


    //

    //启动屏幕的加载时间
    [NSThread sleepForTimeInterval:2];//在启动屏幕的时间停留是3秒
    //动画效果
    //设置一个图片;
    UIImageView *niceView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    niceView.image = [UIImage imageNamed:@"1-1.png"];
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    [manager GET:launchScreen parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){
        _dic=[NSMutableDictionary dictionary];
        _dic=operation.responseObject;
        //剥离启动图像的连接地址
        _launchPath=[_dic objectForKey:@"img"];
        
        
        [niceView sd_setImageWithURL:[NSURL URLWithString:_launchPath]];
        //添加到场景
        [self.window addSubview:niceView];
        //放到最顶层;
        [self.window bringSubviewToFront:niceView];
        //开始设置动画;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:3.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.window cache:YES];
        [UIView setAnimationDelegate:self];
        /*
         UIViewAnimationTransitionNone,
         UIViewAnimationTransitionFlipFromLeft,
         UIViewAnimationTransitionFlipFromRight,
         UIViewAnimationTransitionCurlUp,
         UIViewAnimationTransitionCurlDown,
         */
        niceView.alpha = 0.0;
        //动画消失的时候的位置和大小
        niceView.frame = CGRectMake(-15, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width*1.5, [UIScreen mainScreen].bounds.size.height*1.5);
        [UIView commitAnimations];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        NSLog(@"%@",error.description);
    }];
    
    [self.window makeKeyAndVisible];
    return YES;
}
-(void)deleteNavigationImage{
    //打开首页的时候将所有打开过的主题试图控制器关闭
    for (int i=0; i<[self.mainNavigationController.viewControllers count]; i++) {
        UIViewController *vc=[self.mainNavigationController.viewControllers objectAtIndex:i];
        //将导航条上的图片删除
        UIImageView *imageView=[vc.navigationController.view viewWithTag:Nav_ImageTag];
        [imageView removeFromSuperview];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
