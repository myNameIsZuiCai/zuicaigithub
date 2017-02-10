//
//  StoryRequest.m
//  毕业设计
//
//  Created by manongjiaoyu16 on 16/1/21.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "StoryRequest.h"
#import "common.h"
#import "HTTPRequest.h"
#import "StoriesEntity.h"
@implementation StoryRequest
+(instancetype)sharedInstance {
    static StoryRequest *instance;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken,^{
        instance=[[self alloc] init];
    });
    return instance;
}
-(void)recentStories_Request:(NSString *)strDate success:(void (^)(NSMutableDictionary *))success fail:(void (^)(NSError *))fail {
    NSString *strUrl=[NSString stringWithFormat:@"%@%@",oldNews,strDate];
    [[HTTPRequest sharedInstance] Get:strUrl success:^(NSURLSessionDataTask *dataTask,id response){
        NSMutableDictionary *dDict=(NSMutableDictionary *)response;
        NSMutableDictionary *sStories=[StoriesEntity ParseJson:dDict];
        success(sStories);
    }failure:^(NSURLSessionDataTask *dataTask,NSError *error){
        fail(error);
    }];
    
}
-(void) stories_Request:(void(^)(NSMutableDictionary * dStories)) sucess fail:(void(^)(NSError *error)) fail{
    [[HTTPRequest sharedInstance] Get:server success:^(NSURLSessionDataTask *dataTask, id response){
        NSMutableDictionary *dDict=(NSMutableDictionary *)response;
        // NSLog(@"%@",dDict);
        NSMutableDictionary *sStories=[StoriesEntity ParseJson:dDict];
        sucess(sStories);
    } failure:^(NSURLSessionDataTask *dataTask,NSError *error){
        fail(error);
    }];
}

@end
