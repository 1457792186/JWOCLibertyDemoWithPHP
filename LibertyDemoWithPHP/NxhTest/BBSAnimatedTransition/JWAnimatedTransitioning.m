//
//  JWAnimatedTransitioning.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "JWAnimatedTransitioning.h"

@implementation JWAnimatedTransitioning

#pragma mark - UIViewControllerAnimatedTransitioning
//返回动画事件
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}

//所有的过渡动画事务都在这个方法里面完成
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
}

@end
