//
//  StoryDetailRequest.m
//  知乎项目(全)
//
//  Created by manongjiaoyu16 on 16/1/18.
//  Copyright © 2016年 manongjiaoyu16. All rights reserved.
//

#import "StoryDetailRequest.h"
#import "HttpRequest.h"
#import "Common.h"
@implementation StoryDetailRequest
+(instancetype)sharedInstance {
    static StoryDetailRequest *instance;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken,^{
        instance=[[self alloc] init];
    });
    return instance;
}
-(void)detail_Request:(NSString *)strId success:(void (^)(NSMutableDictionary *))success fail:(void (^)(NSError *))fail {
    NSString *strUrl=[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@",strId];
    [[HTTPRequest sharedInstance] Get:strUrl success:^(NSURLSessionDataTask *dataTask,id response){
        NSMutableDictionary *dDict=(NSMutableDictionary *)response;
        success(dDict);
    }failure:^(NSURLSessionDataTask *dataTask,NSError *error){
        fail(error);
    }];
}
@end
