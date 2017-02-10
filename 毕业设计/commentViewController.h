//
//  commentViewController.h
//  毕业设计
//
//  Created by 码农教育2 on 16/1/28.
//  Copyright © 2016年 码农教育2. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface commentViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_commentArr;
    NSMutableArray *_shortCommentArr;
    NSString *_strID;
    NSMutableDictionary *_CommentDic;
    NSMutableDictionary *_shortComDic;
    NSMutableArray *valueLong;
    NSMutableArray *valueShort;
}
-(void)getNewsID:(NSString*)para;
@end
