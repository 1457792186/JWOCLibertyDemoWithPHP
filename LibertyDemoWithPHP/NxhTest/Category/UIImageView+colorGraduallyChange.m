//
//  UIImageView+colorGraduallyChange.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "UIImageView+colorGraduallyChange.h"


@implementation UIImageView (colorGraduallyChange)


- (void)changeAlphaWithDirection:(KImageColorChangeDirectionStyle)direction{
    CAGradientLayer *_gradLayer = [CAGradientLayer layer];
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:0.4] CGColor],
                       (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                       nil];
    [_gradLayer setColors:colors];
    //渐变起止点，point表示向量
    switch (direction) {
        case kDirectionUp:
        {
            [_gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
            [_gradLayer setEndPoint:CGPointMake(0.0f, 1.0f)];
        }
            break;
        case kDirectionDown:
        {
            [_gradLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
            [_gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
        }
            break;
        case kDirectionLeft:
        {
            [_gradLayer setStartPoint:CGPointMake(1.0f, 0.0f)];
            [_gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
        }
            break;
        case kDirectionRight:
        {
            [_gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
            [_gradLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
        }
            break;
            
        default:
        {
            [_gradLayer setStartPoint:CGPointMake(0.0f, 1.0f)];
            [_gradLayer setEndPoint:CGPointMake(0.0f, 0.0f)];
        }
            break;
    }
    
    
    [_gradLayer setFrame:self.bounds];
    
    [self.layer setMask:_gradLayer];
}


- (void)fuzzyImage{
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0, 0, self.frame.size.width*0.5, self.frame.size.height);
    [self addSubview:effectView];
}

- (void)fuzzyWithImageWithBlurNumber:(CGFloat)blur{
    self.image = [UIImage coreBlurImage:self.image withBlurNumber:blur];
}

@end
