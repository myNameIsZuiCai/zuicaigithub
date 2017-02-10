//
//  HTTPRequest.m
//  毕业设计
//
//  Created by manongjiaoyu16 on 16/1/21.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "HTTPRequest.h"
#import "AFNetworking.h"
@implementation HTTPRequest
+(instancetype) sharedInstance {
    static HTTPRequest *httpRequest;
    static dispatch_once_t oneceToken;
    dispatch_once(&oneceToken,^{
        httpRequest=[[self alloc] init];
    });
    return httpRequest;
}
-(void)Get:(NSString *)strUrl success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    AFHTTPSessionManager *session=[AFHTTPSessionManager manager];
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    [session GET:strUrl parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        success(task,responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(task,error);
        
    }];
}

@end
