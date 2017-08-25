//
//  UIImageView+colorGraduallyChange.h
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+fuzzy.h"

typedef NS_ENUM(NSUInteger, KImageColorChangeDirectionStyle) {
    
    kDirectionUp,//上-下，0-1
    kDirectionDown,//下-上，0-1
    kDirectionLeft,//左-右，0-1
    kDirectionRight,//右-左，0-1
};

@interface UIImageView (colorGraduallyChange)

//颜色渐变
- (void)changeAlphaWithDirection:(KImageColorChangeDirectionStyle)direction;

//模糊背景——毛玻璃
- (void)fuzzyImage;
//模糊背景——图片毛玻璃
- (void)fuzzyWithImageWithBlurNumber:(CGFloat)blur;

@end
