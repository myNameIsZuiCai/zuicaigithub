//
//  newsTableViewCell.m
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import "newsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "StoriesEntity.h"
@implementation newsTableViewCell
- (void)awakeFromNib {
    // Initialization code
}
-(void) updateCell:(StoriesEntity *) sEntity date:(NSString*) time{
    _newsLable.text=sEntity.title;
    _newsLable.numberOfLines=2;
    if ([sEntity.images count]>0) {
    NSString *strImgUrl=[sEntity.images  objectAtIndex:0];
        [_imageView sd_setImageWithURL:[NSURL URLWithString:strImgUrl]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
