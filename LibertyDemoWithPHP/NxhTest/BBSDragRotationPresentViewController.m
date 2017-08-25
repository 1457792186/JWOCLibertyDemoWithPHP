//
//  BBSDragRotationPresentViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/25.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSDragRotationPresentViewController.h"
#import "JWAnimatedTransitioning.h"


@interface BBSDragRotationPresentViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation BBSDragRotationPresentViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.transitioningDelegate = self;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义转场效果+拖拽";
}

#pragma mark - UIViewControllerTransitioningDelegate;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [JWAnimatedTransitioning transitionWithTransitionType:JWAnimatedRotationPresent GestureDirection:JWInteractiveTransitionGestureDirectionDown];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [JWAnimatedTransitioning transitionWithTransitionType:JWPresentOneTransitionTypeDismiss GestureDirection:JWInteractiveTransitionGestureDirectionDown];
}

@end
