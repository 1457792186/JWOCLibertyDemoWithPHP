//
//  BBSDrawingViewController.m
//  NxhTest
//
//  Created by apple on 2017/11/27.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSDrawingViewController.h"
#import "BBSSimpleDrawView.h"

@interface BBSDrawingViewController ()

@property (nonatomic,strong)UIScrollView * showScrollView;

@end

@implementation BBSDrawingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原生绘图";
    [self prepareUI];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareUI{
    CGFloat drawViewHeight = SCREENHEIGHT/3.f;
    CGFloat drawViewY = 0.f;
    
    self.showScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20.f, 64.f, SCREENWIDTH - 40.f, SCREENHEIGHT - 64.f)];
    [self.view addSubview:self.showScrollView];
    
    for (int i = 0; i<4; i++) {
        for (int j = 0; j<4; j++) {
            BBSSimpleDrawView * drawView = [[BBSSimpleDrawView alloc]initWithFrame:CGRectMake(0.f, drawViewY, self.showScrollView.frame.size.width, drawViewHeight)];
            drawView.backgroundColor = [UIColor whiteColor];
            [drawView drawLayerWuthType:i withAnimationType:j];//添加绘图
            
            [drawView addTouchAction];
            UILabel * introLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, drawView.frame.size.width, 20)];
            introLabel.textColor = [UIColor blackColor];
            introLabel.text = [NSString stringWithFormat:@"type:%zi animation:%zi",i,j];
            [drawView addSubview:introLabel];
            drawViewY += drawViewHeight + 10.f;
            
            [self.showScrollView addSubview:drawView];
        }
    }
    
    self.showScrollView.contentSize = CGSizeMake(10.f, drawViewY);
}


@end
