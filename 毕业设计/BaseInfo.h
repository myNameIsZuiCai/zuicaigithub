//
//  BaseInfo.h
//  ZhiHu
//
//  Created by manong on 15/12/26.
//  Copyright © 2015年 manong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseInfo : NSObject
@property(nonatomic,strong) NSString *date;
-(id) initWidthDict:(NSMutableDictionary *) dDict;
@end
