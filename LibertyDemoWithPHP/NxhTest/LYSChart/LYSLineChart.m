//
//  LYSLineChart.m
//  LYSLineChart
//
//  Created by HENAN on 17/7/25.
//  Copyright © 2017年 LYS. All rights reserved.
//

#import "LYSLineChart.h"
#define POINT(A,B) CGPointMake(A,B)

#pragma mark - 图表四个顶点 -
#define BoxLeftTopPoint POINT(_edgeInsets.left, _size.height - _edgeInsets.top)
#define BoxRightTopPoint POINT(_size.width - _edgeInsets.right, _size.height - _edgeInsets.top)
#define BoxLeftBottomPoint POINT(_edgeInsets.left, _edgeInsets.bottom)
#define BoxRightBottomPoint POINT(_size.width - _edgeInsets.right, _edgeInsets.bottom)

#pragma mark - 画布四个顶点 -
#define CanvasLeftTopPoint POINT(BoxLeftTopPoint.x + _canvasEdgeInsets.left,BoxLeftTopPoint.y - _canvasEdgeInsets.top)
#define CanvasRightTopPoint POINT(BoxRightTopPoint.x - _canvasEdgeInsets.right,BoxRightTopPoint.y - _canvasEdgeInsets.top)
//#define CanvasLeftBottomPoint POINT(BoxLeftBottomPoint.x + _canvasEdgeInsets.left,BoxLeftBottomPoint.y + _canvasEdgeInsets.bottom)
//#define CanvasRightBottomPoint POINT(BoxRightBottomPoint.x - _canvasEdgeInsets.right,BoxRightBottomPoint.y + _canvasEdgeInsets.bottom)
#define CanvasLeftBottomPoint POINT(BoxLeftBottomPoint.x,BoxLeftBottomPoint.y)
#define CanvasRightBottomPoint POINT(BoxRightBottomPoint.x - _canvasEdgeInsets.right,BoxRightBottomPoint.y + _canvasEdgeInsets.bottom)

#pragma mark - 计算两个点直接距离 -
#define TwoPointSpacing(A,B) sqrt(pow(A.x - B.x,2) + pow(A.y - B.y, 2))

@interface LYSLineChart ()

@end
@implementation LYSLineChart
{
    CGSize _size;
    NSArray *_rowData;
    CGFloat space_value;
    
    NSMutableArray *chartLayerAry;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _size = frame.size;
        self.layer.geometryFlipped = YES;
        // 设置初始值
        [self customDefaultParams];
    }
    return self;
}
- (CGFloat)rowSpace{
    if (_rowSpace == 0) {
        _rowSpace = TwoPointSpacing(CanvasLeftTopPoint, CanvasLeftBottomPoint) / _row;
    }
    return _rowSpace;
}
- (CGFloat)columnSpace{
    if (_columnSpace == 0) {
        _columnSpace = TwoPointSpacing(CanvasRightBottomPoint, CanvasLeftBottomPoint) / (_column - 1);
    }
    return _columnSpace;
}
#pragma mark - 设置初始值 -
- (void)customDefaultParams{
    // 图表边距
    _edgeInsets = UIEdgeInsetsMake(20, 40, 20, 20);
    
    // 画布边距
    _canvasEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    
    // 坐标轴样式
    LYAxisStyle *xdefaulyAxisStyle = [[LYAxisStyle alloc] init];
    xdefaulyAxisStyle.lineWidth = 1;
    xdefaulyAxisStyle.lineColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _xStyle = xdefaulyAxisStyle;
    LYAxisStyle *ydefaulyAxisStyle = [[LYAxisStyle alloc] init];
    ydefaulyAxisStyle.lineWidth = 1;
    ydefaulyAxisStyle.lineColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _yStyle = ydefaulyAxisStyle;
    
    // 辅助先样式
    LYGuideStyle *horizontaldefaultGuideStyle = [[LYGuideStyle alloc] init];
    horizontaldefaultGuideStyle.lineWidth = 0.5;
    horizontaldefaultGuideStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _horizontalStyle = horizontaldefaultGuideStyle;
    LYGuideStyle *verticaldefaultGuideStyle = [[LYGuideStyle alloc] init];
    verticaldefaultGuideStyle.lineWidth = 0.5;
    verticaldefaultGuideStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _verticalStyle = verticaldefaultGuideStyle;
    _isShowVerticalGuide = NO;
    _isShowHorizontalGuide = YES;
    
    // 坐标轴数据样式
    LYAxisDataStyle *xdefaultAxisDataStyle = [[LYAxisDataStyle alloc] init];
    xdefaultAxisDataStyle.fontSize = 10;
    xdefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _xAxisDataStyle = xdefaultAxisDataStyle;
    LYAxisDataStyle *ydefaultAxisDataStyle = [[LYAxisDataStyle alloc] init];
    ydefaultAxisDataStyle.fontSize = 10;
    ydefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _yAxisDataStyle = ydefaultAxisDataStyle;
    
    // 网格样式
    LYGuideStyle *defaultGriddingStyle = [[LYGuideStyle alloc] init];
    defaultGriddingStyle.lineWidth = 0.5;
    defaultGriddingStyle.lineColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _griddingStyle = defaultGriddingStyle;
    _isShowGriddingGuide = NO;
    
    // 精度
    _precisionScale = 1;
    _yAxisPrecisionScale = 2;
    
    // 是否是百分比
    _isPercent = NO;
    _isHundredPercent = NO;
    
    LYAxisDataStyle *yValuedefaultAxisDataStyle = [[LYAxisDataStyle alloc] init];
    yValuedefaultAxisDataStyle.fontSize = 10;
    yValuedefaultAxisDataStyle.fontColor = [UIColor blackColor];
    _yValueDataStyle = yValuedefaultAxisDataStyle;
    
    _isShowBenchmarkLine = NO;
    LYBenchmarkLineStyle *benchmarkLineStyle = [[LYBenchmarkLineStyle alloc] init];
    benchmarkLineStyle.lineColor = [UIColor redColor];
    benchmarkLineStyle.lineWidth = 1;
    benchmarkLineStyle.fontSize = 9;
    benchmarkLineStyle.fontColor = [UIColor redColor];
    _benchmarkLineStyle = benchmarkLineStyle;
    
    _lineChartFillColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:0.5];
    _lineChartColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    _lineChartWidth = 1;
    _lineChartDotRadius = 2;
    _lineChartDotColor = [UIColor colorWithRed:67 / 255.0 green:155 / 255.0 blue:231 / 255.0 alpha:1];
    
    _isCurve = NO;
}

#pragma mark - 开始绘制 -
- (void)reloadData{
    // 绘制前清空画布
    for (CALayer *layer in self.layer.sublayers) {[layer removeFromSuperlayer];}
    
    // 绘制XY轴
    [self drawXYAxis];
    
    // 绘制辅助先
    [self drawGuide];
    
    // 计算数据
    [self calculateValue];
    
    // 绘制坐标轴数据
    [self drawAxisData];
    
    // 画图
    [self drawLineChart];
}
#pragma mark - 画图 -
- (void)drawLineChart{
    CGFloat scale = self.rowSpace / space_value;
    if (_isShowBenchmarkLine) {
        CAShapeLayer *benchmarkLine = [self horizontalLine:POINT(BoxLeftBottomPoint.x, CanvasLeftBottomPoint.y + [_benchmarkLineStyle.benchmarkValue floatValue] * scale) width:TwoPointSpacing(BoxLeftBottomPoint, BoxRightBottomPoint) linecolor:_benchmarkLineStyle.lineColor lineHeight:_benchmarkLineStyle.lineWidth];
        [self.layer addSublayer:benchmarkLine];
        CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_benchmarkLineStyle.fontSize]} forStr:_benchmarkLineStyle.benchmarkValue];
        CATextLayer *ytext = [self textLayer:POINT(BoxLeftBottomPoint.x - _yStyle.lineWidth, CanvasLeftBottomPoint.y + [_benchmarkLineStyle.benchmarkValue floatValue] * scale) text:_benchmarkLineStyle.benchmarkValue fontColor:_benchmarkLineStyle.fontColor fontSize:_benchmarkLineStyle.fontSize boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
        ytext.anchorPoint = CGPointMake(1, 0.5);
        ytext.alignmentMode = kCAAlignmentRight;
        [self.layer addSublayer:ytext];
    }
    chartLayerAry = [NSMutableArray array];
    LYAnimationLayer *animationLayer = [self lineChartWith:CanvasLeftBottomPoint width:TwoPointSpacing(CanvasRightBottomPoint, CanvasLeftBottomPoint) height:TwoPointSpacing(CanvasLeftTopPoint, CanvasLeftBottomPoint)];
    animationLayer.anchorPoint = CGPointMake(0, 0);
    animationLayer.fillColor = _lineChartFillColor.CGColor;
    
    animationLayer.zPosition = 999999;
    [self.layer addSublayer:animationLayer];
    [chartLayerAry addObject:animationLayer];
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i = 0; i < [_valueData count]; i++) {
        [tempAry addObject:@0];
    }
    [animationLayer animationSetPath:^CGPathRef(CADisplayLink *displayLink) {
        BOOL isSuccess = YES;
        for (int i = 0; i < [_valueData count]; i++) {
            CGFloat speed = ([_valueData[i] floatValue] - [tempAry[i] floatValue]) / 10;
            tempAry[i] = @([tempAry[i] floatValue] + speed);
            if (speed > 1.0 / _precisionScale) {
                isSuccess = NO;
            }
        }
        if (isSuccess) {
            [displayLink invalidate];
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (_isCurve == NO) {
            [path moveToPoint:POINT(0, 0)];
            for (int i = 0; i < [_valueData count]; i++) {
                [path addLineToPoint:POINT(self.columnSpace * i, [tempAry[i] floatValue] * scale)];
            }
            [path addLineToPoint:POINT(TwoPointSpacing(CanvasRightBottomPoint, CanvasLeftBottomPoint), 0)];
            [path addLineToPoint:POINT(0, 0)];
        }else{
            [path moveToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
            for (int i = 0; i < [tempAry count]; i++) {
                if (i + 1 < [tempAry count]) {
                    CGPoint point1 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i] floatValue] * scale);
                    CGPoint point2 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i + 1] floatValue] * scale);
                    [path addCurveToPoint:POINT(self.columnSpace * (i + 1), [tempAry[i + 1] floatValue] * scale) controlPoint1:point1 controlPoint2:point2];
                }
            }
            [path addLineToPoint:POINT(TwoPointSpacing(CanvasRightBottomPoint, CanvasLeftBottomPoint), 0)];
            [path addLineToPoint:POINT(0, 0)];
            [path addLineToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
        }
        return path.CGPath;
    }];
    
    LYAnimationLayer *animationLayerLine = [self lineChartWith:CanvasLeftBottomPoint width:TwoPointSpacing(CanvasRightBottomPoint, CanvasLeftBottomPoint) height:TwoPointSpacing(CanvasLeftTopPoint, CanvasLeftBottomPoint)];
    animationLayerLine.anchorPoint = CGPointMake(0, 0);
    animationLayerLine.fillColor = _lineChartColor.CGColor;
    animationLayerLine.zPosition = 999999;
    [self.layer addSublayer:animationLayerLine];
    [chartLayerAry addObject:animationLayerLine];
    NSMutableArray *tempAryLine = [NSMutableArray array];
    for (int i = 0; i < [_valueData count]; i++) {
        [tempAryLine addObject:@0];
    }
    [animationLayerLine animationSetPath:^CGPathRef(CADisplayLink *displayLink) {
        BOOL isSuccess = YES;
        for (int i = 0; i < [_valueData count]; i++) {
            CGFloat speed = ([_valueData[i] floatValue] - [tempAryLine[i] floatValue]) / 10;
            tempAryLine[i] = @([tempAryLine[i] floatValue] + speed);
            if (speed > 1.0 / _precisionScale) {
                isSuccess = NO;
            }
        }
        if (isSuccess) {
            [displayLink invalidate];
            for (int i = 0; i < [_valueData count]; i++) {
                CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_yValueDataStyle.fontSize]} forStr:_valueData[i]];
                CATextLayer *ytext = [self textLayer:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale + 2) text:_valueData[i] fontColor:_yValueDataStyle.fontColor fontSize:_yValueDataStyle.fontSize boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
                ytext.anchorPoint = CGPointMake(0.5, 0);
                ytext.alignmentMode = kCAAlignmentCenter;
                [animationLayerLine addSublayer:ytext];
                
                CAShapeLayer *dot = [self dotWith:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale) radius:_lineChartDotRadius color:_lineChartColor];
                dot.anchorPoint = POINT(0.5, 0.5);
                [animationLayerLine addSublayer:dot];
            }
        }
        UIBezierPath *path = [UIBezierPath bezierPath];
        if (_isCurve == NO) {
            [path moveToPoint:POINT(0, [tempAryLine[0] floatValue] * scale + _lineChartWidth)];
            for (int i = 0; i < [_valueData count]; i++) {
                [path addLineToPoint:POINT(self.columnSpace * i, [tempAryLine[i] floatValue] * scale)];
            }
            for (int i = (int)[_valueData count] - 1; i >= 0; i--) {
                [path addLineToPoint:POINT(self.columnSpace * i, [tempAry[i] floatValue] * scale + _lineChartWidth)];
            }
        }else{
            [path moveToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
            for (int i = 0; i < [tempAry count]; i++) {
                if (i + 1 < [tempAry count]) {
                    CGPoint point1 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i] floatValue] * scale);
                    CGPoint point2 = CGPointMake(self.columnSpace * i + self.columnSpace * 0.5,[tempAry[i + 1] floatValue] * scale);
                    [path addCurveToPoint:POINT(self.columnSpace * (i + 1), [tempAry[i + 1] floatValue] * scale) controlPoint1:point1 controlPoint2:point2];
                }
            }
            [path addLineToPoint:POINT(self.columnSpace * ([tempAry count] - 1), [tempAry[([tempAry count] - 1)] floatValue] * scale + _lineChartWidth)];
            for (int i = (int)[tempAry count] - 1; i >= 0; i--) {
                if (i - 1 >= 0) {
                    CGPoint point1 = CGPointMake(self.columnSpace * i - self.columnSpace * 0.5,[tempAry[i] floatValue] * scale + _lineChartWidth);
                    CGPoint point2 = CGPointMake(self.columnSpace * i - self.columnSpace * 0.5,[tempAry[i - 1] floatValue] * scale + _lineChartWidth);
                    [path addCurveToPoint:POINT(self.columnSpace * (i - 1), [tempAry[i - 1] floatValue] * scale + _lineChartWidth) controlPoint1:point1 controlPoint2:point2];
                }
            }
            [path addLineToPoint:POINT(0, [tempAry[0] floatValue] * scale)];
        }
        
        if (_isGradient){
            //添加颜色渐变
            CAGradientLayer *_gradLayer = [CAGradientLayer layer];
            NSArray *colors = [NSArray arrayWithObjects:
                               (id)[[UIColor colorWithWhite:0 alpha:0.3] CGColor],
                               (id)[[UIColor colorWithWhite:0 alpha:0.6] CGColor],
                               (id)[[UIColor colorWithWhite:0 alpha:1] CGColor],
                               nil];
            [_gradLayer setColors:colors];
            [_gradLayer setStartPoint:CGPointMake(0.0f, 0.0f)];
            [_gradLayer setEndPoint:CGPointMake(1.0f, 0.0f)];
            [_gradLayer setFrame:animationLayer.bounds];
            [animationLayer setMask:_gradLayer];
        }
        
        return path.CGPath;
    }];
    
}

#pragma mark - 绘制坐标轴数据
- (void)drawAxisData{
    for (int i = 0; i < [_columnData count]; i++) {
        CGRect rect = [self rectWithSize:CGSizeMake(self.columnSpace, _edgeInsets.bottom) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_xAxisDataStyle.fontSize]} forStr:_columnData[i]];
        CATextLayer *xtext = [self textLayer:POINT(CanvasLeftBottomPoint.x + (i * self.columnSpace), BoxLeftBottomPoint.y - _xStyle.lineWidth) text:_columnData[i] fontColor:_xAxisDataStyle.fontColor fontSize:_xAxisDataStyle.fontSize boxSize:CGSizeMake(rect.size.width, rect.size.height)];
        xtext.anchorPoint = CGPointMake(0.5, 1);
        [self.layer addSublayer:xtext];
    }
    for (int i = 0; i < [_rowData count]; i++) {
        CGRect rect = [self rectWithSize:CGSizeMake(_edgeInsets.left, self.rowSpace) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_yAxisDataStyle.fontSize]} forStr:_rowData[i]];
        CATextLayer *ytext = [self textLayer:POINT(BoxLeftBottomPoint.x - _yStyle.lineWidth, CanvasLeftBottomPoint.y + (i * self.rowSpace)) text:_rowData[i] fontColor:_yAxisDataStyle.fontColor fontSize:_yAxisDataStyle.fontSize boxSize:CGSizeMake(_edgeInsets.left, rect.size.height)];
        ytext.anchorPoint = CGPointMake(1, 0.5);
        ytext.alignmentMode = kCAAlignmentRight;
        [self.layer addSublayer:ytext];
    }
}
#pragma mark - 计算y轴数据 -
- (void)calculateValue{
    NSMutableArray *tempRowData = [NSMutableArray array];
    space_value = [self spaceValue];
    if (_isHundredPercent == YES) {
        space_value = 1.0 / _row;
    }
    if (_isPercent == NO) {
        for (int i = 0; i < _row + 1; i++) {
            switch (_yAxisPrecisionScale) {
                case 0:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.0f",i * space_value]];
                }
                    break;
                case 1:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.1f",i * space_value]];
                }
                    break;
                case 2:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.2f",i * space_value]];
                }
                    break;
                case 3:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.3f",i * space_value]];
                }
                    break;
                case 4:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.4f",i * space_value]];
                }
                    break;
                case 5:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.5f",i * space_value]];
                }
                    break;
                default:
                    break;
            }
        }
        tempRowData[0] = @"0";
    }else{
        for (int i = 0; i < _row + 1; i++) {
            switch (_yAxisPrecisionScale) {
                case 0:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.0f%%",i * space_value * 100]];
                }
                    break;
                case 1:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.1f%%",i * space_value * 100]];
                }
                    break;
                case 2:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.2f%%",i * space_value * 100]];
                }
                    break;
                case 3:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.3f%%",i * space_value * 100]];
                }
                    break;
                case 4:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.4f%%",i * space_value * 100]];
                }
                    break;
                case 5:
                {
                    [tempRowData addObject:[NSString stringWithFormat:@"%.5f%%",i * space_value * 100]];
                }
                    break;
                default:
                    break;
            }
        }
        tempRowData[0] = @"0";
    }
    _rowData = [NSArray arrayWithArray:tempRowData];
}
// 获取数据最大值,并计算每一行间隔值
- (CGFloat)spaceValue{
    CGFloat minValue = MAXFLOAT;
    CGFloat maxValue = -MAXFLOAT;
    for (int i = 0; i < [_valueData count]; i++) {
        if ([_valueData[i] floatValue] * _precisionScale> maxValue) {
            maxValue = [_valueData[i] floatValue] * _precisionScale;
        }
        if ([_valueData[i] floatValue] * _precisionScale < minValue) {
            minValue = [_valueData[i] floatValue] * _precisionScale;
        }
    }
    int max = (int)[self getNumber:maxValue];
    NSInteger tenValue = 0;
    while (max / 10) {max = max / 10;tenValue++;}
    CGFloat space_Value = ((max + 1) * pow(10, tenValue)) / _row;
    return space_Value / _precisionScale;
}
// 只取小数点之前的数字
- (CGFloat)getNumber:(CGFloat)value{
    NSString *string = [NSString stringWithFormat:@"%f",value];
    if (![[NSMutableString stringWithString:string] containsString:@"."]) {
        return value;
    }
    return [[[string componentsSeparatedByString:@"."] firstObject] floatValue];
}
#pragma mark - 绘制辅助线 -
- (void)drawGuide{
    if (_isShowGriddingGuide) {
        for (int i = 0; i < _row + 1; i++) {
            CGPoint point = POINT(CanvasLeftBottomPoint.x, CanvasLeftBottomPoint.y + (i * self.rowSpace));
            CAShapeLayer *xGuide = [self horizontalLine:point width:self.columnSpace * _column linecolor:_griddingStyle.lineColor lineHeight:_griddingStyle.lineWidth];
            xGuide.zPosition = 777777;
            [self.layer addSublayer:xGuide];
        }
        for (int i = 0; i < _column; i++) {
            CGPoint point = POINT(CanvasLeftBottomPoint.x + (i * self.columnSpace), CanvasLeftBottomPoint.y);
            CAShapeLayer *yGuide = [self verticalLine:point height:self.rowSpace * _row linecolor:_griddingStyle.lineColor lineWidth:_griddingStyle.lineWidth];
            yGuide.zPosition = 777777;
            [self.layer addSublayer:yGuide];
        }
    }
    
    if (_isShowHorizontalGuide) {
        for (int i = 0; i < _row + 1; i++) {
            CGPoint point = POINT(BoxLeftBottomPoint.x, CanvasLeftBottomPoint.y + (i * self.rowSpace));
            CAShapeLayer *xGuide = [self horizontalLine:point width:TwoPointSpacing(BoxRightTopPoint, BoxLeftTopPoint) linecolor:_horizontalStyle.lineColor lineHeight:_horizontalStyle.lineWidth];
            xGuide.zPosition = 888888;
            [self.layer addSublayer:xGuide];
        }
    }
    if (_isShowVerticalGuide) {
        for (int i = 0; i < _column; i++) {
            CGPoint point = POINT(CanvasLeftBottomPoint.x + (i * self.columnSpace), BoxLeftBottomPoint.y);
            CAShapeLayer *yGuide = [self verticalLine:point height:TwoPointSpacing(CanvasLeftTopPoint, BoxLeftBottomPoint) - (_isShowHorizontalGuide ? _horizontalStyle.lineWidth : 0) linecolor:_verticalStyle.lineColor lineWidth:_verticalStyle.lineWidth];
            yGuide.zPosition = 888888;
            [self.layer addSublayer:yGuide];
        }
    }
}
#pragma mark - 绘制XY轴 -
- (void)drawXYAxis{
    CAShapeLayer *x = [self horizontalLine:BoxLeftBottomPoint width:TwoPointSpacing(BoxLeftBottomPoint, BoxRightBottomPoint) linecolor:_xStyle.lineColor lineHeight:_xStyle.lineWidth];
    x.anchorPoint = CGPointMake(0, 1);
    x.zPosition = 999999;
    [self.layer addSublayer:x];
    CAShapeLayer *y = [self verticalLine:BoxLeftBottomPoint height:TwoPointSpacing(BoxLeftTopPoint, BoxLeftBottomPoint) linecolor:_yStyle.lineColor lineWidth:_yStyle.lineWidth];
    y.anchorPoint = CGPointMake(1, 0);
    y.zPosition = 999999;
    [self.layer addSublayer:y];
    
    // 弥补左下角缺陷
    CAShapeLayer *pane = [self horizontalLine:BoxLeftBottomPoint width:1 linecolor:_xStyle.lineColor lineHeight:_xStyle.lineWidth];
    pane.anchorPoint = CGPointMake(1, 1);
    [self.layer addSublayer:pane];
    
    // 绘制小三角
    CAShapeLayer *sanjiaoLayer = [self layerWith:POINT(BoxLeftTopPoint.x - (_yStyle.lineWidth * 0.5), BoxLeftTopPoint.y) width:_yStyle.lineWidth * 5 height:_yStyle.lineWidth * 7 fillColor:_yStyle.lineColor];
    [self.layer addSublayer:sanjiaoLayer];
}
#pragma mark - 创建竖线 -
- (CAShapeLayer *)verticalLine:(CGPoint)bottomPoint height:(CGFloat)height linecolor:(UIColor *)linecolor lineWidth:(CGFloat)lineWidth{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, lineWidth, height);
    line.anchorPoint = CGPointMake(0.5, 0);
    line.position = bottomPoint;
    line.backgroundColor = linecolor.CGColor;
    return line;
}
#pragma mark - 创建水平线 -
- (CAShapeLayer *)horizontalLine:(CGPoint)leftPoint width:(CGFloat)width linecolor:(UIColor *)linecolor lineHeight:(CGFloat)lineHeight{
    CAShapeLayer *line = [CAShapeLayer layer];
    line.bounds = CGRectMake(0, 0, width, lineHeight);
    line.anchorPoint = CGPointMake(0, 0.5);
    line.position = leftPoint;
    line.backgroundColor = linecolor.CGColor;
    return line;
}
// 获取字符串在指定区域的rect
- (CGRect)rectWithSize:(CGSize)size attributes:(NSDictionary<NSString *,id> *)attributes forStr:(NSString *)string{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [string boundingRectWithSize:size options:options attributes:attributes context:nil];
    return rect;
}
// 创建轴标题
- (CATextLayer *)textLayer:(CGPoint)positionPoint text:(NSString *)text fontColor:(UIColor *)fontColor fontSize:(CGFloat)fontSize boxSize:(CGSize)boxSize{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = text;
    textLayer.foregroundColor = fontColor.CGColor;
    textLayer.position = positionPoint;
    textLayer.fontSize = fontSize;
    textLayer.bounds = CGRectMake(0, 0, boxSize.width, boxSize.height);
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.wrapped = YES;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    return textLayer;
}
// 创建折线图
- (LYAnimationLayer *)lineChartWith:(CGPoint)point width:(CGFloat)width height:(CGFloat)height{
    LYAnimationLayer *layer = [LYAnimationLayer layer];
    layer.position = point;
    layer.bounds = CGRectMake(0, 0, width, height);
    return layer;
}
// 绘制圆点
- (CAShapeLayer *)dotWith:(CGPoint)point radius:(CGFloat)radius color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, 2 * radius, 2 * radius);
    layer.position = point;
    layer.cornerRadius = radius;
    layer.backgroundColor = color.CGColor;
    return layer;
}
// 创建小三角
- (CAShapeLayer *)layerWith:(CGPoint)point width:(CGFloat)width height:(CGFloat)height fillColor:(UIColor *)fillColor{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.bounds = CGRectMake(0, 0, width, height);
    layer.position = point;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:POINT(0, 0)];
    [path addLineToPoint:POINT(width, 0)];
    [path addLineToPoint:POINT(width / 2.0, height * 0.8)];
    [path addLineToPoint:POINT(0, 0)];
    layer.fillColor = fillColor.CGColor;
    layer.path = path.CGPath;
    return layer;
}
@end

