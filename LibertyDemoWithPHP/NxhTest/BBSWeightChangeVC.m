//
//  BBSWeightChangeVC.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSWeightChangeVC.h"
#import "LYSLineChart.h"
#import "LYSHistogramChart.h"

@interface BBSWeightChangeVC ()

@end

@implementation BBSWeightChangeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self weightChangeChart];
    [self costChangeChart];
}


//体重曲线图
- (void)weightChangeChart{
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width*2, 200);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    LYSLineChart *chartView1 = [[LYSLineChart alloc] initWithFrame:CGRectMake(0, 0.f, self.view.frame.size.width*2, 200)];
    chartView1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [scroll addSubview:chartView1];
    
    chartView1.columnData = @[@"03.14",@"03.15",@"03.16",@"03.17",@"03.18",@"03.19",@"03.20",@"03.21",@"03.22",@"03.23",@"03.24",@"03.25",@"03.26",@"03.27",@"03.28"];
    chartView1.valueData = @[@"6.48",@"2.40",@"19.7",@"5.40",@"8.49",@"10.26",@"13.2",@"8.6",@"5.4",@"3.2",@"9.7",@"18.8",@"14.4",@"15.40",@"18.49"];
    chartView1.row = 5;
    chartView1.column = chartView1.columnData.count;
    
    chartView1.backgroundColor = [UIColor whiteColor];
    chartView1.isShowGriddingGuide = NO;
    chartView1.isShowBenchmarkLine = NO;
    chartView1.isShowHorizontalGuide = NO;
    //    chartView1.benchmarkLineStyle.benchmarkValue = @"0.6";
    
    chartView1.canvasEdgeInsets = UIEdgeInsetsMake(20, 40, 20, 40);
    chartView1.precisionScale = 100;
    chartView1.yAxisPrecisionScale = 2;
    
    chartView1.lineChartFillColor = [UIColor colorWithHexString:@"#ff7f9d"];
    chartView1.lineChartColor = [UIColor colorWithHexString:@"#EE6684"];
    UIColor * lineColor = [UIColor colorWithHexString:@"#EE6684"];
    
    chartView1.xStyle.lineColor = lineColor;
    chartView1.xStyle.lineWidth = 0.5f;
    chartView1.yStyle.lineColor = lineColor;
    chartView1.yStyle.lineWidth = 0.5f;
    chartView1.xAxisDataStyle.fontSize = 10.f;
    chartView1.yAxisDataStyle.fontSize = 10.f;
    chartView1.yValueDataStyle.fontSize = 12.f;
    
    chartView1.lineChartDotRadius = 4.f;
    chartView1.lineChartWidth = 0.5f;
    chartView1.isCurve = YES;
    chartView1.isGradient = YES;
    
    [chartView1 reloadData];
}

//账簿折线图
- (void)costChangeChart{
    UIScrollView * scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 80)];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width*2, 80);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    LYSLineChart *chartView1 = [[LYSLineChart alloc] initWithFrame:CGRectMake(0, 0.f, self.view.frame.size.width*2, 80)];
    chartView1.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    [scroll addSubview:chartView1];
    
    chartView1.columnData = @[@"03.14",@"03.15",@"03.16",@"03.17",@"03.18",@"03.19",@"03.20",@"03.21",@"03.22",@"03.23",@"03.24",@"03.25",@"03.26",@"03.27",@"03.28"];
    chartView1.valueData = @[@"6.48",@"2.40",@"0",@"5.40",@"8.49",@"10.26",@"2",@"8.6",@"5.4",@"3.2",@"0",@"18.8",@"14.4",@"15.40",@"18.49"];
    chartView1.row = 3;
    chartView1.column = chartView1.columnData.count;
    
    chartView1.backgroundColor = [UIColor colorWithHexString:@"#fbf7f8"];
    chartView1.isShowGriddingGuide = NO;
    chartView1.isShowBenchmarkLine = NO;
    chartView1.isShowHorizontalGuide = NO;
    //    chartView1.benchmarkLineStyle.benchmarkValue = @"0.6";
    
    chartView1.canvasEdgeInsets = UIEdgeInsetsMake(20, 40, 20, 40);
    chartView1.precisionScale = 100;
    chartView1.yAxisPrecisionScale = 2;
    
    chartView1.lineChartFillColor = chartView1.backgroundColor;
    chartView1.lineChartColor = [UIColor colorWithHexString:@"#EE6684"];
    UIColor * lineColor = [UIColor colorWithHexString:@"#e4dcdc"];
    
    chartView1.xStyle.lineColor = lineColor;
    chartView1.xStyle.lineWidth = 1.f;
    chartView1.yStyle.lineColor = lineColor;
    chartView1.yStyle.lineWidth = 1.f;
    chartView1.xAxisDataStyle.fontSize = 10.f;
    chartView1.yAxisDataStyle.fontSize = 10.f;
    chartView1.yValueDataStyle.fontSize = 12.f;
    
    chartView1.lineChartDotRadius = 4.f;
    chartView1.lineChartWidth = 0.5f;
    chartView1.isCurve = NO;
    
    
    [chartView1 reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
