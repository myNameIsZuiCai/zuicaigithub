//
//  StoriesEntity.m
//  ZhiHu
//
//  Created by manong on 15/12/26.
//  Copyright © 2015年 manong. All rights reserved.
//

#import "StoriesEntity.h"
#import "common.h"
@implementation StoriesEntity

-(id) initWidthDict:(NSMutableDictionary *) dDict{
    if (self=[super initWidthDict:dDict]) {
        
    }
    return self;
}

+(NSMutableDictionary *) ParseData:(NSData *) data{
    NSMutableDictionary *dDict=[NSMutableDictionary dictionary];
    NSDictionary *dJSonDict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSMutableArray *ItemArr=[StoriesEntity ParseDict:dJSonDict key:Stories];
    NSMutableArray *Item1Arr=[StoriesEntity ParseDict:dJSonDict key:TopStories];
    dDict[Dateabc]=dJSonDict[@"date"];
    dDict[Stories]=ItemArr;
    dDict[TopStories]=Item1Arr;
    
    
    return dDict;
}
+(NSMutableArray *) ParseDict:(NSDictionary *) dDict key:(NSString *) strKey{
    NSMutableArray *mArr=[NSMutableArray array];
    NSMutableArray  *mJsonArr=dDict[strKey];
    
    for (int i=0; i<[mJsonArr count]; i++) {
        NSDictionary *dItemDict=mJsonArr[i];
        StoriesEntity *sEntity=[[StoriesEntity alloc] initWidthDict:dDict];
        if([strKey isEqualToString:Stories]){
            sEntity.images=dItemDict[@"images"];
        }else{
            sEntity.image=dItemDict[@"image"];
        }
        sEntity.ga_prefix=[dItemDict[@"ga_prefix"] intValue];
        sEntity.nid=[dItemDict[@"id"] intValue];
        sEntity.title=dItemDict[@"title"];
        sEntity.type=[dItemDict[@"type"] integerValue];
        [mArr addObject:sEntity];
    }
    return mArr;
}
+(NSMutableDictionary *)ParseJson:(NSMutableDictionary *)dDict{
    NSMutableDictionary *dStoryDict=[NSMutableDictionary dictionary];
    NSMutableArray *mArr=[StoriesEntity ParseDict:dDict key:Stories];
    dStoryDict[TopStories]=[StoriesEntity ParseDict:dDict key:TopStories];
    dStoryDict[Stories]=mArr;
    StoriesEntity *sEntity=[mArr lastObject];
    dStoryDict[Dateabc]=sEntity.date;
    return dStoryDict;
}
@end
