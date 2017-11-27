//
//  BBSSimpleDrawView.h
//  NxhTest
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

//绘图类别
typedef enum BBSSimpleLayerType{
    bbsSimpleSqure,//方形
    bbsSimpleRound,//圆形
    bbsSimpleChart,//波浪线
    bbsSimplesChart//多波浪线
}BBSSimpleLayerType;

//动画类别
typedef enum BBSSimpleLayerAnimationType{
    bbsSimpleAnimationStart,//从头到尾
    bbsSimpleAnimationCenter,//从中间到两边
    bbsSimpleAnimationEnd,//从尾到头
    bbsSimpleAnimationLine//从线由细到粗
}BBSSimpleLayerAnimationType;

@interface BBSSimpleDrawView : UIView

- (void)addTouchAction;
- (void)drawLayerWuthType:(BBSSimpleLayerType)layerType withAnimationType:(BBSSimpleLayerAnimationType)animationType;

@end
