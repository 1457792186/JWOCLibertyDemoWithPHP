//
//  JWAnimatedTransitioning.h
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//过渡动画管理的类

typedef NS_ENUM(NSUInteger, JWPresentOneTransitionType) {
    JWPresentOneTransitionTypePresent = 0,//管理present动画
    JWPresentOneTransitionTypeDismiss//管理dismiss动画
};

@interface JWAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>



@end
