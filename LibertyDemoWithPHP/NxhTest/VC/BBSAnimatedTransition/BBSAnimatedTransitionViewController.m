//
//  BBSAnimatedTransitionViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSAnimatedTransitionViewController.h"
#import "JWAnimatedTransitioning.h"
#import "JWPercentDrivenInteractiveTransition.h"

@interface BBSAnimatedTransitionViewController ()<UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) JWPercentDrivenInteractiveTransition *interactiveDismiss;//手势集成

@end

@implementation BBSAnimatedTransitionViewController

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
    self.title = @"自定义转场效果";
    
    self.view.backgroundColor = [UIColor greenColor];
    
    _interactiveDismiss = [JWPercentDrivenInteractiveTransition interactiveTransitionWithTransitionType:JWPresentOneTransitionTypeDismiss GestureDirection:JWInteractiveTransitionGestureDirectionUp];//下拉固定dismiss效果
    [_interactiveDismiss addPanGestureForViewController:self];
}

#pragma mark - UIViewControllerTransitioningDelegate;
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    //这里我们初始化presentType
    return [JWAnimatedTransitioning transitionWithTransitionType:JWPresentOneTransitionTypePresent GestureDirection:JWInteractiveTransitionGestureDirectionDown];
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    //这里我们初始化dismissType
    return [JWAnimatedTransitioning transitionWithTransitionType:JWPresentOneTransitionTypeDismiss GestureDirection:JWInteractiveTransitionGestureDirectionDown];
}

@end
