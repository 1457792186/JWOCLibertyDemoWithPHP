//
//  JWPercentDrivenInteractiveTransition.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "JWPercentDrivenInteractiveTransition.h"

@implementation JWPercentDrivenInteractiveTransition

+ (instancetype)interactiveTransitionWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction{
    return [[self alloc] initWithTransitionType:type GestureDirection:direction];
}

- (instancetype)initWithTransitionType:(JWPresentOneTransitionType)type GestureDirection:(JWInteractiveTransitionGestureDirection)direction{
    self = [super init];
    if (self) {
        _direction = direction;
        _type = type;
    }
    return self;
}

//通过这个方法给控制器的View添加相应的手势
- (void)addPanGestureForViewController:(UIViewController *)viewController{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    //将传入的控制器保存，因为要利用它触发转场操作
    self.vc = viewController;
    [viewController.view addGestureRecognizer:pan];
}

//关键的手势过渡的过程
- (void)handleGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat persent = 0;
    switch (_direction) {
        case JWInteractiveTransitionGestureDirectionLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case JWInteractiveTransitionGestureDirectionRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            persent = transitionX / panGesture.view.frame.size.width;
        }
            break;
        case JWInteractiveTransitionGestureDirectionUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
        case JWInteractiveTransitionGestureDirectionDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            persent = transitionY / panGesture.view.frame.size.width;
        }
            break;
    }
    
    //persent是根据panGesture的移动距离获取的，这里就不说明了，可具体去代码中查看
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            //手势开始的时候标记手势状态，并开始相应的事件，它的作用在使用这个类的时候说明
            self.interation = YES;
            //手势开始是触发对应的转场操作，方法代码在后面
            [self startGesture];
            break;
        case UIGestureRecognizerStateChanged:{
            //手势过程中，通过updateInteractiveTransition设置转场过程进行的百分比，然后系统会根据百分比自动布局控件，不用我们控制了
            [self updateInteractiveTransition:persent];
            break;
        }
        case UIGestureRecognizerStateEnded:{
            //手势完成后结束标记并且判断移动距离是否过半，过则finishInteractiveTransition完成转场操作，否者取消转场操作，转场失败
            self.interation = NO;
            if (persent > 0.5) {
                [self finishInteractiveTransition];
            }else{
                [self cancelInteractiveTransition];
            }
            break;
        }
        default:
            break;
    }
}
//触发对应转场操作的代码如下，根据type(type是我自定义的枚举值)我们去判断是触发哪种操作，对于push和present由于要传入需要push和present的控制器，为了解耦，我用block把这个操作交个控制器去做了，让这个手势过渡管理者可以充分被复用
- (void)startGesture{
    switch (_type) {
        case JWPresentOneTransitionTypePresent:{
            if (_presentConifg) {
                _presentConifg();
            }
        }
            break;
            
        case JWPresentOneTransitionTypeDismiss:
            [_vc dismissViewControllerAnimated:YES completion:nil];
            break;
        case JWInteractiveTransitionTypePush:{
            if (_pushConifg) {
                _pushConifg();
            }
        }
            break;
        case JWInteractiveTransitionTypePop:
            [_vc.navigationController popViewControllerAnimated:YES];
            break;
    }
}


@end
