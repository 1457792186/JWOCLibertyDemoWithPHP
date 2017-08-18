//
//  LYSToolObject.m
//  LYSToolObject
//
//  Created by HENAN on 17/7/25.
//  Copyright © 2017年 LYS. All rights reserved.
//

#import "LYSToolObject.h"

@implementation LYAxisStyle
@end

@implementation LYGuideStyle
@end

@implementation LYAxisDataStyle
@end

@implementation LYBenchmarkLineStyle
@end

@implementation LYAnimationLayer
{
    CGPathRef (^animationAction)(CADisplayLink *displayLink);
    CADisplayLink *_displayLink;
}
- (void)animationSetPath:(CGPathRef (^)(CADisplayLink *displayLink))setPathAction{
    if (_displayLink) {[_displayLink invalidate];_displayLink = nil;}
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationDisPlayHistogram)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:(NSDefaultRunLoopMode)];
    animationAction = setPathAction;
}
- (void)animationDisPlayHistogram{
    if (animationAction) {[self setPath:animationAction(_displayLink)];}
}
@end
