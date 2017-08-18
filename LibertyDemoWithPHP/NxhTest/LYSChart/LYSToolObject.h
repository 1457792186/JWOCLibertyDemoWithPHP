//
//  LYSToolObject.h
//  LYSToolObject
//
//  Created by HENAN on 17/7/25.
//  Copyright © 2017年 LYS. All rights reserved.
//

#import <UIKit/UIKit.h>

// 轴线样式
@interface LYAxisStyle : NSObject
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@end

// 辅助线样式
@interface LYGuideStyle : NSObject
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@end

// X轴数据样式
@interface LYAxisDataStyle : NSObject
@property (nonatomic,strong)UIColor *fontColor;
@property (nonatomic,assign)CGFloat fontSize;
@end

// 阈值线样式
@interface LYBenchmarkLineStyle : NSObject
@property (nonatomic,copy)NSString *benchmarkValue;
@property (nonatomic,strong)UIColor *lineColor;
@property (nonatomic,assign)CGFloat lineWidth;
@property (nonatomic,strong)UIColor *fontColor;
@property (nonatomic,assign)CGFloat fontSize;
@end

// 动态layer
@interface LYAnimationLayer : CAShapeLayer
@property (nonatomic,strong)id obj;
@property (nonatomic,assign)CGRect selfRect;
- (void)animationSetPath:(CGPathRef (^)(CADisplayLink *displayLink))setPathAction;
@end
