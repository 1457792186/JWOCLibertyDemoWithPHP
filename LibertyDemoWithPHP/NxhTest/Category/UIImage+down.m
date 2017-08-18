//
//  UIImage+down.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "UIImage+down.h"

@implementation UIImage (down)


+ (UIImage *)imageTransformWithImage:(UIImage *)image{
    long double rotate = M_PI;
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    float translateX = -rect.size.width;
    float translateY = -rect.size.height;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

@end
