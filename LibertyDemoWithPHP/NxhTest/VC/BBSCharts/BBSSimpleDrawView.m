//
//  BBSSimpleDrawView.m
//  NxhTest
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSSimpleDrawView.h"

@interface BBSSimpleDrawView()

@property (nonatomic,assign)BBSSimpleLayerAnimationType animationType;
@property (nonatomic,strong)CAShapeLayer * drawLayer;

@end

@implementation BBSSimpleDrawView

- (void)addTouchAction{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchesAction)];
    [self addGestureRecognizer:tap];
}
- (void)touchesAction{
//    点击后再次动画
    if (self.drawLayer) {
        [self layerAnimationWithType:self.animationType];
    }
}

- (void)drawLayerWuthType:(BBSSimpleLayerType)layerType withAnimationType:(BBSSimpleLayerAnimationType)animationType{
    // 绘制前清空画布
    for (CALayer *sublayer in self.layer.sublayers) {[sublayer removeFromSuperlayer];}
    
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    
    UIBezierPath * path = [[UIBezierPath alloc]init];//贝塞尔曲线
    
    CGSize baseSize = self.frame.size;
    
//    绘图类别
    switch (layerType) {
        case bbsSimpleSqure:
        {
//            layer.frame = self.frame;
            path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, baseSize.width, baseSize.height)];
            
//            path = [UIBezierPath bezierPathWithRoundedRect:<#(CGRect)#> cornerRadius:<#(CGFloat)#>];//绘画带圆角
        }
            break;
        case bbsSimpleRound:
        {
            path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(baseSize.width/2.f, baseSize.height/2.f) radius:60.f startAngle:0.f endAngle:2*M_PI clockwise:true];
        }
            break;
        case bbsSimpleChart:
        {
            CGPoint startPoint = CGPointMake(0, baseSize.height/2.f);
            CGPoint endPonit = CGPointMake(baseSize.width, baseSize.height/2.f);
            CGPoint controlPoint = CGPointMake(baseSize.width/2.f, 0.f);
            [path moveToPoint:startPoint];
            [path addQuadCurveToPoint:endPonit controlPoint:controlPoint];
        }
            break;
        case bbsSimplesChart:
        {
            CGPoint startPoint = CGPointMake(0, baseSize.height/2.f);
            CGPoint endPonit = CGPointMake(baseSize.width, baseSize.height/2.f);
            CGPoint controlPoint = CGPointMake(baseSize.width/4.f, 0.f);
            CGPoint controlPoint2 = CGPointMake(baseSize.width*3/4.f, baseSize.height);
            [path moveToPoint:startPoint];
            [path addCurveToPoint:endPonit controlPoint1:controlPoint controlPoint2:controlPoint2];
        }
            break;
        default:
            break;
    }
    
    layer.path = path.CGPath;//设置贝塞尔曲线
    layer.fillColor = [UIColor cyanColor].CGColor;//填充色
    layer.strokeColor = [UIColor redColor].CGColor;//边框色
    self.drawLayer = layer;//存储以再次动画
    
    [self layerAnimationWithType:animationType];//设置动画
    
    [self.layer addSublayer:layer];
}

- (void)layerAnimationWithType:(BBSSimpleLayerAnimationType)animationType{
    if (!self.drawLayer)return;
    
    CABasicAnimation * animation = [CABasicAnimation animation];
    
    /*
     duration           动画的时长
     repeatCount        重复的次数。不停重复设置为 HUGE_VALF
     repeatDuration     设置动画的时间。在该时间内动画一直执行，不计次数。
     beginTime          指定动画开始的时间。从开始延迟几秒的话，设置为【CACurrentMediaTime() + 秒数】 的方式
     timingFunction     设置动画的速度变化
     autoreverses       动画结束时是否执行逆动画
     fromValue          所改变属性的起始值
     toValue            所改变属性的结束时的值
     byValue            所改变属性相同起始值的改变量
     */
    
    //    animation.fromValue = @(M_PI_2);
    //    animation.toValue = @(M_PI);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //    animation.autoreverses = YES;
    animation.repeatCount = 1;
    animation.beginTime = CACurrentMediaTime() + 2;
    
    //    speed 改变动画的速度 可以直接设置动画上的speed属性，这样只有这个动画速度。
    //    animation.speed = 2;
    
    //    防止动画结束后回到初始状态
    //    animation.removedOnCompletion = NO;//在动画执行完成之后，最好还是将动画移除掉。也就是尽量不要设置removedOnCompletion属性为NO
    //    animation.fillMode = kCAFillModeForwards;
    
    //    动画开始和结束时的事件
    //    为了获取动画的开始和结束事件，需要实现协议
    //    animation.delegate = self;
    
    //    动画类别
    switch (animationType) {
        case bbsSimpleAnimationStart:
        {
            self.drawLayer.strokeStart = 0.f;
            self.drawLayer.strokeEnd = 1.f;
            
            animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];//范围是0-1
            /*
             一些常用的animationWithKeyPath值的总结
             
             值                      说明          使用形式
             transform.scale        比例转化        @(0.8)
             transform.scale.x      宽的比例        @(0.8)
             transform.scale.y      高的比例        @(0.8)
             transform.rotation.x   围绕x轴旋转      @(M_PI)
             transform.rotation.y   围绕y轴旋转      @(M_PI)
             transform.rotation.z   围绕z轴旋转      @(M_PI)
             cornerRadius           圆角的设置       @(50)
             backgroundColor        背景颜色的变化    (id)[UIColor purpleColor].CGColor
             bounds                 大小，中心不变    [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
             position               位置(中心点的改变)    [NSValue valueWithCGPoint:CGPointMake(300, 300)];
             contents               内容，比如UIImageView的图片    imageAnima.toValue = (id)[UIImage imageNamed:@"to"].CGImage;
             opacity                透明度           @(0.7)
             contentsRect.size.width 横向拉伸缩放     @(0.4)最好是0~1之间的
             */
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.duration = 2.f;
            
            [self.drawLayer addAnimation:animation forKey:@"1"];//forKey任意
        }
            break;
        case bbsSimpleAnimationCenter:
        {
            self.drawLayer.strokeStart = 0.5;
            self.drawLayer.strokeEnd = 0.5;
            
            animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];//范围是0-1
            animation.fromValue = @0.5;
            animation.toValue = @0;
            animation.duration = 2.f;
            
            CABasicAnimation * animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation2.repeatCount = HUGE_VALF;
            animation2.beginTime = CACurrentMediaTime() + 2;
            animation2.fromValue = @0.5;
            animation2.toValue = @1;
            animation2.duration = 2.f;
            
            [self.drawLayer addAnimation:animation forKey:@"2"];
            [self.drawLayer addAnimation:animation2 forKey:@"3"];
        }
            break;
        case bbsSimpleAnimationEnd:
        {
            animation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
            self.drawLayer.strokeStart = 0.f;
            self.drawLayer.strokeEnd = 1.f;
            
            animation.keyPath = @"strokeStart";//范围是0-1
            animation.fromValue = @1;
            animation.toValue = @0;
            animation.duration = 2.f;
            
            [self.drawLayer addAnimation:animation forKey:@"4"];
        }
            break;
        case bbsSimpleAnimationLine:
        {
            animation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
            self.drawLayer.borderWidth = 1.f;
            animation.fromValue = @1;
            animation.toValue = @10;
            animation.duration = 2.f;
            
            [self.drawLayer addAnimation:animation forKey:@"5"];
        }
            break;
        default:
            break;
    }
    
}


@end
