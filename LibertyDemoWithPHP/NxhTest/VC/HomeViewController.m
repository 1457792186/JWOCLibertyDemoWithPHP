//
//  ViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "HomeViewController.h"
#import "iCarousel.h"
#import "UIImage+down.h"
#import "UIImage+scale.h"
#import "UIImageView+colorGraduallyChange.h"

#import "TZImagePickerController.h"
#import "BBSWeightChangeVC.h"
#import "BBSURLSessionViewController.h"
#import "BBSMyURLSessionViewController.h"
#import "BBSDownloadViewController.h"
#import "BBSLabelViewController.h"
#import "BBSDragViewController.h"
#import "BBSAnimatedTransitionViewController.h"
#import "BBSDragRotationPresentViewController.h"
#import "BBSStockViewController.h"
#import "BBSFaceViewController.h"

@interface HomeViewController ()<iCarouselDataSource, iCarouselDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic)iCarousel *carousel;
@property (strong, nonatomic)NSMutableArray * dataArray;
@property (strong, nonatomic)NSMutableArray * nameArray;
@property (strong, nonatomic)UIImageView * bgImageView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"翻页效果";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [_bgImageView setUserInteractionEnabled:YES];
    [self.view addSubview:_bgImageView];
    
    _nameArray = [NSMutableArray arrayWithArray:@[@"图表绘制",@"网络连接",@"网络连接本地",@"图片选择器",@"断点下载",@"文本特效",@"拖拽视图",@"自定义转场",@"转场&拖拽",@"股票绘制",@"人脸识别",@"背景图毛玻璃"]];
    _dataArray = [NSMutableArray array];
    for (int i = 0; i<_nameArray.count; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"BG_IMG%zi",(i%7)]];
    }
    
    _carousel = [[iCarousel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/2.f)];
    _carousel.center = self.view.center;
    _carousel.dataSource = self;
    _carousel.delegate = self;
    _carousel.backgroundColor = [UIColor clearColor];
    _carousel.type = iCarouselTypeCoverFlow2;
    _carousel.centerItemWhenSelected = YES;//选中时居中
    
    [self.view addSubview:_carousel];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //翻页墙居中
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSInteger centerIdx = _dataArray.count/2 - 1;
        _carousel.currentItemIndex = centerIdx>0?centerIdx:0;
    });
}

#pragma mark - iCarouselDataSource
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return _dataArray.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    UILabel * label = nil;
//    if (view) {
//        label = [view viewWithTag:1001];
//    }else{
        CGFloat width  = SCREENWIDTH*2/3.f;
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height/2.f)];
        view.backgroundColor = [UIColor clearColor];
        
        imageView.image = [UIImage imageNamed:_dataArray[index]];
        view.contentMode = UIViewContentModeCenter;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
        
        //倒影
        UIImage * image = [UIImage imageNamed:_dataArray[index]];
        image = [UIImage imageTransformWithImage:image];
        UIImageView * imageDown = [[UIImageView alloc]initWithFrame:CGRectMake(imageView.frame.origin.x, CGRectGetMaxY(imageView.frame), imageView.frame.size.width, view.frame.size.height - CGRectGetMaxY(imageView.frame))];
        imageDown.contentMode = UIViewContentModeScaleAspectFit;
        imageDown.image = image;
        [imageDown changeAlphaWithDirection:kDirectionDown];
        imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        [view addSubview:imageDown];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height/2.f - 15.f, width, 30.f)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:40.f];
        label.textColor = [UIColor whiteColor];
        label.tag = 1001;
        [view addSubview:label];
//    }
    label.text = _nameArray[index];
    
    return view;
}


#pragma mark - iCarouselDelegate
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1f;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
        {//图表绘制
            BBSWeightChangeVC * vc = [[BBSWeightChangeVC alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 1:
        {//NSURLSession网络连接
            BBSURLSessionViewController * urlVC = [[BBSURLSessionViewController alloc]init];
            [self presentViewController:urlVC animated:YES completion:nil];
        }
            break;
        case 2:
        {//NSURLSession连接本地数据库测试PHP学习进程
            BBSMyURLSessionViewController * urlVC = [[BBSMyURLSessionViewController alloc]init];
            [self presentViewController:urlVC animated:YES completion:nil];
        }
            break;
        case 3:
        {//图片选择器，随机选择一张作为背景图片
            TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
            imagePickerVC.allowPickingVideo = NO;
            [imagePickerVC setDidFinishPickingPhotosHandle:^(NSArray * photos , NSArray * assets,BOOL isSelectOriginalPhoto){
                if (photos.count>0) {
                    NSInteger selIndex = arc4random()%photos.count;
                    while (selIndex>=photos.count) {
                        selIndex--;
                    }
                    _bgImageView.image = photos[selIndex];
                }
            }];
            
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }
            break;
        case 4:
        {//文件下载断点续传
            BBSDownloadViewController * downLoadVC = [[BBSDownloadViewController alloc]init];
            [self presentViewController:downLoadVC animated:YES completion:nil];
        }
            break;
        case 5:
        {//炫酷文本特效
            BBSLabelViewController * labelVC = [[BBSLabelViewController alloc]init];
            [self presentViewController:labelVC animated:YES completion:nil];
        }
            break;
        case 6:
        {//视图拖拽
            BBSDragViewController * dragVC = [[BBSDragViewController alloc]init];
            //设置背景透明必要
            dragVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            
            UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:dragVC animated:YES completion:nil];
        }
            break;
        case 7:
        {//自定义转场效果
            BBSAnimatedTransitionViewController * animatedVC = [[BBSAnimatedTransitionViewController alloc]init];
            [self presentViewController:animatedVC animated:YES completion:nil];
        }
            break;
        case 8:
        {//转场拖拽
            BBSDragRotationPresentViewController * rotationPresentVC = [[BBSDragRotationPresentViewController alloc]init];
            rotationPresentVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
            
            UIViewController * rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
            [rootViewController presentViewController:rotationPresentVC animated:YES completion:nil];
        }
            break;
        case 9:
        {//股票图绘制
            BBSStockViewController * stockVC = [[BBSStockViewController alloc]init];
            [self presentViewController:stockVC animated:YES completion:nil];
        }
            break;
        case 10:
        {
            BBSFaceViewController * faceVC = [[BBSFaceViewController alloc]init];
            [self presentViewController:faceVC animated:YES completion:nil];
        }
            break;
        default:
        {//背景图毛玻璃,只执行一次
            if (_dataArray.count > 0) {
                static dispatch_once_t onceToken;
                dispatch_once(&onceToken, ^{
                    _bgImageView.image = [UIImage imageNamed:_dataArray[index]];
                    [_bgImageView fuzzyWithImageWithBlurNumber:3.f];//毛玻璃添加
                });
            }
        }
            break;
    }
}

@end
