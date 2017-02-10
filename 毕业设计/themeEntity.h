//
//  themeEntity.h
//  毕业设计
//
//  Created by 码农教育2 on 16/2/18.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInfo.h"
@interface themeEntity : BaseInfo
@property(nonatomic,strong) NSString *nid;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *thumbnail;
@property(nonatomic,strong) NSString *descript;
@end
