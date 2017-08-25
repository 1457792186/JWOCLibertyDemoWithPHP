//
//  JWAnimatedTransitioning.h
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//JWAnimatedTransitioning 过渡动画管理的类

//手势的方向
typedef NS_ENUM(NSUInteger, JWInteractiveTransitionGestureDirection) {
    JWInteractiveTransitionGestureDirectionLeft = 0,
    JWInteractiveTransitionGestureDirectionRight,
    JWInteractiveTransitionGestureDirectionUp,
    JWInteractiveTransitionGestureDirectionDown
};
//过渡动画管理的枚举
typedef NS_ENUM(NSUInteger, JWPresentOneTransitionType) {
    JWPresentOneTransitionTypePresent = 0,//管理present动画
    JWPresentOneTransitionTypeDismiss,//管理dismiss动画
    JWInteractiveTransitionTypePush,//管理push动画
    JWInteractiveTransitionTypePop,//管理pop动画
    JWAnimatedRotationPresent,//转角弹出
};

@interface JWAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>
@property (assign,nonatomic)JWPresentOneTransitionType type;
/**手势方向*/
@property (nonatomic, assign)JWInteractiveTransitionGestureDirection direction;

//根据定义的枚举初始化的两个方法
+ (instancetype)transitionWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction;
- (instancetype)initWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction;

@end
