//
//  NewDerailJson.m
//  ZhiHu
//
//  Created by 码农教育20 on 16/1/15.
//  Copyright © 2016年 码农教育20. All rights reserved.
//

#import "NewDerailJson.h"

@implementation NewDerailJson

+(NSMutableArray *)ParseNewsExtra:(NSMutableArray *)NewExtra{
    NSMutableArray *mArr=[NSMutableArray array];
    for (int i=0; i<[NewExtra count]; i++) {
        NSMutableDictionary *mDic=[NewExtra objectAtIndex:i];
        NewDerailModel *newExt=[[NewDerailModel alloc]initWithDictionary:mDic error:nil];
        [mArr addObject:newExt];
    }
    return mArr;
}
@end
