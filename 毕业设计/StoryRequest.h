//
//  StoryRequest.h
//  毕业设计
//
//  Created by manongjiaoyu16 on 16/1/21.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryRequest : NSObject
+(instancetype) sharedInstance;
-(void)recentStories_Request:(NSString *)strDate success:(void(^)(NSMutableDictionary * dStories))success fail:(void(^)(NSError *error)) fail;
-(void) stories_Request:(void(^)(NSMutableDictionary * dStories)) success fail:(void(^)(NSError *error)) fail;
@end
