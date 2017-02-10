//
//  storyCommentEntiy.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/27.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface storyCommentEntiy : JSONModel
@property(nonatomic,strong) NSString *author;//作者
@property(nonatomic,strong) NSString *avatar;//头像
@property(nonatomic,strong) NSString *content;//评论内容
@property(nonatomic,assign) NSInteger id;//评论id
@property(nonatomic,assign) NSInteger likes;//欢迎程度
@property(nonatomic,assign) NSInteger time;//评论时间
@end
