//
//  BlurImage.h
//  LXDBlurNavController
//
//  Created by manong on 16/1/28.
//  Copyright © 2016年 sindri lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//处理图片模糊效果
@interface BlurImage : NSObject
//根据传入的image 对象，模糊值，调整图片模糊状态
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;
@end
