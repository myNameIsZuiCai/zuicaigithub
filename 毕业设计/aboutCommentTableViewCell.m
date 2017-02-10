//
//  aboutCommentTableViewCell.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/29.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "aboutCommentTableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation aboutCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)UpdateNewCell:(NSMutableDictionary *)sEntity IndexPath:(NSIndexPath *)nIndexPath{
    NSString *strHead=sEntity[@"avatar"];
    NSString *format=[NSString stringWithFormat:@"%@",strHead];
    _touxiang.layer.cornerRadius=20;
    _touxiang.layer.masksToBounds=YES;
    
    //设置边框的宽度，颜色
    [_touxiang sd_setImageWithURL:[NSURL URLWithString:format]];
    _touxiang.layer.borderWidth=1;
    _touxiang.layer.borderColor=[[UIColor blackColor] CGColor];
    //用户名
    _userName.text=sEntity[@"author"];
    _userName.font=[UIFont systemFontOfSize:16];
    [_dianzan addTarget:self action:@selector(addlike) forControlEvents:UIControlEventTouchUpInside];
    
    //点赞的数量
    _flag=YES;
    _totalLikes=[sEntity[@"likes"] intValue];
    _likesLable.text=[NSString stringWithFormat:@"%ld",_totalLikes];
    _likesLable.font=[UIFont systemFontOfSize:12];
    
    //时间
    _timeLable.font=[UIFont systemFontOfSize:12];
    NSString *str=sEntity[@"time"];
    NSInteger str1=[str integerValue];
    NSDate *times=[NSDate dateWithTimeIntervalSince1970:str1];
//    _timeLable.text=[[[NSString stringWithFormat:@"%@",times]substringToIndex:16]substringToIndex:5];
    _timeLable.text=[NSString stringWithFormat:@"%@",times];
    //内容
    _contentLable.text=sEntity[@"content"];

}
-(void)addlike{
    if (_flag==YES) {
        _totalLikes++;
        _likesLable.text=[NSString stringWithFormat:@"%ld",_totalLikes];
        _likesLable.font=[UIFont systemFontOfSize:12];
        _flag=NO;
    }else{
        _totalLikes--;
        _likesLable.text=[NSString stringWithFormat:@"%ld",_totalLikes];
        _likesLable.font=[UIFont systemFontOfSize:12];
        _flag=YES;
    }
}
@end
