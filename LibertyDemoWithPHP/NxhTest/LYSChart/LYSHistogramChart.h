//
//  LYSHistogramChart.h
//  LYSHistogramChart
//
//  Created by HENAN on 17/1/6.
//  Copyright © 2017年 LYS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSToolObject.h"
@interface LYSHistogramChart : UIView
@property (nonatomic,assign)UIEdgeInsets edgeInsets;        // 内容边距
@property (nonatomic,assign)UIEdgeInsets canvasEdgeInsets;  // 画布边距
@property (nonatomic,strong)LYAxisStyle *xStyle;            // x轴样式
@property (nonatomic,strong)LYAxisStyle *yStyle;            // y轴样式

@property (nonatomic,assign)NSInteger row;                  // 图表有多少行
@property (nonatomic,assign)NSInteger column;               // 图表有多少列

@property (nonatomic,assign)CGFloat rowSpace;               // 竖直方向每一行间距
@property (nonatomic,assign)CGFloat columnSpace;            // 水平方向每一列间距

@property (nonatomic,assign)BOOL isShowGriddingGuide;       // 是否显示网格线
@property (nonatomic,strong)LYGuideStyle *griddingStyle;    // 网格样式

@property (nonatomic,assign)BOOL isShowHorizontalGuide;     // 是否显示水平辅助线
@property (nonatomic,strong)LYGuideStyle *horizontalStyle;  // 水平线样式

@property (nonatomic,assign)BOOL isShowVerticalGuide;       // 是否显示竖直辅助线
@property (nonatomic,strong)LYGuideStyle *verticalStyle;    // 竖直线样式

@property (nonatomic,strong)NSArray *columnData;            // x轴下标
@property (nonatomic,strong)NSArray *valueData;             // 展示数据
@property (nonatomic,assign)NSInteger precisionScale;       // 计算精度,10,100,1000,默认是1
@property (nonatomic,assign)NSInteger yAxisPrecisionScale;  // y轴下标计算精度,0,1,2,3,4,5,默认是2

@property (nonatomic,strong)LYAxisDataStyle *xAxisDataStyle;   // x轴下标样式
@property (nonatomic,strong)LYAxisDataStyle *yAxisDataStyle;   // y轴下标样式

@property (nonatomic,assign)BOOL isPercent;                    // 是否是百分比
@property (nonatomic,assign)BOOL isHundredPercent;             // 是否最大值100%

@property (nonatomic,strong)LYAxisDataStyle *yValueDataStyle;  // 显示数据样式

@property (nonatomic,assign)BOOL isShowBenchmarkLine;          // 是否显示阈值线
@property (nonatomic,strong)LYBenchmarkLineStyle *benchmarkLineStyle; // 阈值线样式

// 柱状图
@property (nonatomic,assign)CGFloat histogramWidth;            // 柱状图宽度
@property (nonatomic,strong)UIColor *histogramFillColor;       // 填充颜色
@property (nonatomic,strong)UIColor *histogramClickFillColor;  // 点击柱状图颜色
@property (nonatomic,copy)void(^histogramClickAction)(NSInteger index); // 点击柱状图回调事件

// 绘制图表
- (void)reloadData;
@end
