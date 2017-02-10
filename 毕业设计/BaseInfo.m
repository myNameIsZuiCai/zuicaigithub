//
//  BaseInfo.m
//  ZhiHu
//
//  Created by manong on 15/12/26.
//  Copyright © 2015年 manong. All rights reserved.
//

#import "BaseInfo.h"

@implementation BaseInfo

-(id) initWidthDict:(NSMutableDictionary *) dDict{
    if (self=[super init]) {
        self.date=dDict[@"date"];
    }
    return self;
}
@end
