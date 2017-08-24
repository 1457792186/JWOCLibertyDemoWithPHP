//
//  JWPercentDrivenInteractiveTransition.h
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JWGestureConifg)();

#import "JWAnimatedTransitioning.h"

//JWPercentDrivenInteractiveTransition 百分比手势过渡管理对象的类
@interface JWPercentDrivenInteractiveTransition : UIPercentDrivenInteractiveTransition

@property (strong,nonatomic)UIViewController * vc;
@property (assign,nonatomic)BOOL interation;
/**手势方向*/
@property (nonatomic, assign) JWInteractiveTransitionGestureDirection direction;
/**手势类型*/
@property (nonatomic, assign) JWPresentOneTransitionType type;
/**促发手势present的时候的config，config中初始化并present需要弹出的控制器*/
@property (nonatomic, copy) JWGestureConifg presentConifg;
/**促发手势push的时候的config，config中初始化并push需要弹出的控制器*/
@property (nonatomic, copy) JWGestureConifg pushConifg;


//初始化方法

+ (instancetype)interactiveTransitionWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction;

/** 给传入的控制器添加手势*/
- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
