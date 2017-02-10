//
//  sinaMicroBlogViewController.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/18.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sinaMicroBlogViewController : UIViewController{
    IBOutlet UITextField *_text1;
    IBOutlet UITextField *_text2;
}

-(IBAction)backTologin:(id)sender;
-(IBAction)loginYesOrNo:(id)sender;
@end
