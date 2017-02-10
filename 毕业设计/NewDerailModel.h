//
//  NewDerailModel.h
//  ZhiHu
//
//  Created by 码农教育20 on 16/1/15.
//  Copyright © 2016年 码农教育20. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@interface NewDerailModel : JSONModel
@property(nonatomic,strong) NSString *author;
@property(nonatomic,assign) NSInteger id;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,assign) NSInteger likes;
@property(nonatomic,assign) NSInteger time;
@property(nonatomic,strong) NSString *avatar;

@end
