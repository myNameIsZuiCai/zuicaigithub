//
//  StoriesEntity.h
//  ZhiHu
//
//  Created by manong on 15/12/26.
//  Copyright © 2015年 manong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInfo.h"
@interface StoriesEntity : BaseInfo
{
}
@property (nonatomic,strong) NSArray *images;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) NSInteger nid;
@property(nonatomic,assign) NSInteger ga_prefix;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *image;
-(id) initWidthDict:(NSDictionary *) dDict;

+(NSMutableDictionary *) ParseData:(NSData *) data;
+(NSMutableDictionary *)ParseJson:(NSMutableDictionary *)dDict;
@end
