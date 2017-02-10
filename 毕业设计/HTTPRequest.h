//
//  HTTPRequest.h
//  毕业设计
//
//  Created by manongjiaoyu16 on 16/1/21.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "common.h"
@interface HTTPRequest : NSObject
+(instancetype) sharedInstance;
-(void)Get:(NSString *)strUrl success:(void(^)(NSURLSessionDataTask *dataTask,id response))success failure:(void(^)(NSURLSessionDataTask *dataTask,NSError *error))failure;
@end
