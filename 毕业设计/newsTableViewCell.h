//
//  newsTableViewCell.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/10.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoriesEntity.h"
@interface newsTableViewCell : UITableViewCell{
    IBOutlet UILabel *_newsLable;
    IBOutlet UILabel *_dateLable;
    IBOutlet UIImageView *_imageView;
}
-(void) updateCell:(StoriesEntity *) sEntity date:(NSString*) time;

@end
