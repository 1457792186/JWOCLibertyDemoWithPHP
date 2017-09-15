//
//  BBSStockViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSStockViewController.h"
#import "NxhTest-Swift.h"

/*
 引入swift文件：
 引入swift项目 在github上下载原项目压缩包，在Finder中找到LTMorphingLabel文件夹，将其添加到你的项目里。
 项目文件-> TARGETS -> Build Settings -> Packaging -> Define Module设置为 Yes。
 项目文件-> TARGETS -> Build Settings -> Packaging ->Product Module Name设置为你的项目名称。
 ViewController中包含头文件：#import "项目名称-Swift.h"。
 需要首先自创建一个swift文件并继承自NSObject类，若有错项目文件-> TARGETS -> Build Settings ->Swift Language Version更改
 OC引入swift代码的方法都是这个流程
 
 打包注意：
 Builld Settings的Build Options的ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES需要设置为YES
 或者添加自定义设置EMBEDDED_CONTENT_CONTAINS_SWIFT = YES
 */
@interface BBSStockViewController ()<ChartViewDelegate>

@property (nonatomic, strong)CandleStickChartView *chartView;
@property (nonatomic, strong)UIScrollView * baseScrollView;//底部滑动视图
@property (nonatomic, assign)int dataCount;//显示数量

@end

@implementation BBSStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"股票绘制";
    
    _dataCount = arc4random()%100 + 20;//数量显示在20-40
    NSLog(@"数量  %zi",_dataCount);
    _baseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64.f, SCREENWIDTH, SCREENHEIGHT - 64.f)];
    CGFloat chartViewWidth = (_dataCount * 10.f)>SCREENWIDTH?(_dataCount * 10.f):SCREENWIDTH;
    
    _baseScrollView.contentSize = CGSizeMake(chartViewWidth, 0.f);
    [self.view addSubview:_baseScrollView];
    
    _chartView = [[CandleStickChartView alloc]initWithFrame:CGRectMake(0, 0, chartViewWidth, _baseScrollView.frame.size.height/2)];
//    _chartView.backgroundColor = [UIColor blackColor];
    _chartView.delegate = self;
    
    _chartView.chartDescription.enabled = NO;
    
    _chartView.maxVisibleCount = 60;
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    
    [_baseScrollView addSubview:_chartView];
    
    [self updateChartData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//使用Chart绘制股票图数据更新
- (void)updateChartData{
    [self setDataCount:_dataCount range:100.f];//100.f为Y轴基准线
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *yVals1 = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double mult = (range + 1);
        double val = (double) (arc4random_uniform(40)) + mult;
        double high = (double) (arc4random_uniform(9)) + 8.0;
        double low = (double) (arc4random_uniform(9)) + 8.0;
        double open = (double) (arc4random_uniform(6)) + 1.0;
        double close = (double) (arc4random_uniform(6)) + 1.0;
        BOOL even = i % 2 == 0;
        [yVals1 addObject:[[CandleChartDataEntry alloc] initWithX:i shadowH:val + high shadowL:val - low open:even ? val + open : val - open close:even ? val - close : val + close icon: [UIImage imageNamed:@"icon"]]];
    }
    
    CandleChartDataSet *set1 = [[CandleChartDataSet alloc] initWithValues:yVals1 label:@"Data Set"];
    set1.axisDependency = AxisDependencyLeft;
    
//    颜色设置
    [set1 setColor:[UIColor colorWithWhite:80/255.f alpha:1.f]];
    
    set1.drawIconsEnabled = NO;
    
    set1.shadowColor = UIColor.darkGrayColor;
    set1.shadowWidth = 0.7;
    set1.decreasingColor = UIColor.redColor;
    set1.decreasingFilled = YES;
    set1.increasingColor = [UIColor colorWithRed:122/255.f green:242/255.f blue:84/255.f alpha:1.f];
    set1.increasingFilled = NO;
    set1.neutralColor = UIColor.blueColor;
    set1.valueTextColor = [UIColor orangeColor];
    
    _chartView.backgroundColor = [UIColor cyanColor];
    //    坐标轴颜色
    _chartView.xAxis.labelTextColor = [UIColor blackColor];
    _chartView.leftAxis.labelTextColor = [UIColor blackColor];
    _chartView.rightAxis.labelTextColor = [UIColor blackColor];
    
    CandleChartData *data = [[CandleChartData alloc] initWithDataSet:set1];
    
    _chartView.data = data;
}



#pragma mark - ChartViewDelegate

- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView{
    NSLog(@"chartValueNothingSelected");
}

@end
