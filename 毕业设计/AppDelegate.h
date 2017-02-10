//
//  AppDelegate.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{

    NSMutableArray *_themeArr;
    NSMutableDictionary *_dic;//启动图像的相关信息
    NSString *_launchPath;//启动图像的连接地址
}

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)LeftSlideViewController* leftSlideVC;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
@property(strong,nonatomic) NSMutableArray *themes;
-(void)deleteNavigationImage;
@end

