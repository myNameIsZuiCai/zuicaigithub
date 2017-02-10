//
//  thenemTableViewCell.m
//  毕业设计
//
//  Created by 码农教育2 on 16/2/16.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "thenemTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation thenemTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)updateCellWithPic:(NSMutableDictionary*)picture{
    NSString *str1=[picture objectForKey:@"title"];
    _lable.text=[NSString stringWithFormat:@"%@",str1];
    _lable.numberOfLines=2;
    NSMutableArray *arr1=[picture objectForKey:@"images"];
    NSString *str2=[arr1 objectAtIndex:0];
    [_newsImage sd_setImageWithURL:[NSURL URLWithString:str2]];
}
-(void)updateCell:(NSMutableDictionary*)title{
    NSString *str1=[title objectForKey:@"title"];
    _lable.text=[NSString stringWithFormat:@"%@",str1];
    _lable.numberOfLines=2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
