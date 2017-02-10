//
//  setTableViewController.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/25.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface setTableViewController : UITableViewController
{
    IBOutlet UIImageView *_imageView;
}
-(IBAction)back:(id)sender;
@property(strong,nonatomic)setTableViewController* leftSlideVC;
@end
