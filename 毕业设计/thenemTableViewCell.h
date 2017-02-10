//
//  thenemTableViewCell.h
//  毕业设计
//
//  Created by 码农教育2 on 16/2/16.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface thenemTableViewCell : UITableViewCell
{
    IBOutlet UILabel *_lable;
    IBOutlet UIImageView *_newsImage;
}

-(void)updateCellWithPic:(NSMutableDictionary*)picture;
-(void)updateCell:(NSMutableDictionary*)title;
@end
