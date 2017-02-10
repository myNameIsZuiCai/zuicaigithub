//
//  StoryDetailRequest.h
//  知乎项目(全)
//
//  Created by manongjiaoyu16 on 16/1/18.
//  Copyright © 2016年 manongjiaoyu16. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryDetailRequest : NSObject
+(instancetype) sharedInstance;
-(void) detail_Request:(NSString *)strId success:(void(^)(NSMutableDictionary *strDict)) success fail:(void(^)(NSError *error)) fail;
@end
