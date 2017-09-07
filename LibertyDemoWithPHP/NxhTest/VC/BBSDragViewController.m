
//
//  BBSDragViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSDragViewController.h"
#import "UIImage+JWImage.h"
#import "UIImageView+JWImageView.h"
@interface BBSDragViewController ()

@end

@implementation BBSDragViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    背景设置
    /*
     设置背景透明必要在父视图中设置：
     本视图.modalPresentationStyle = UIModalPresentationOverFullScreen;
     并从根视图rootViewController弹出
     */
    
    self.title = @"视图拖拽消失";
    
    self.view.backgroundColor = [UIColor clearColor];
    UIView * alphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    alphaView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f];
    [self.view addSubview:alphaView];
    
    [self addImageView];
    
//    手势添加
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(draggingImage:)];
    [self.view addGestureRecognizer:recognizer];
}

- (void)addImageView{
    UIImageView * BGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT/2.f)];
    BGImageView.backgroundColor = [UIColor clearColor];
    BGImageView.image = [UIImage imageNamed:@"BG_IMG6"];
    BGImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:BGImageView];
    
    UIImageView * BGImageViewShadow = [[UIImageView alloc]initWithFrame:CGRectMake(BGImageView.frame.origin.x, CGRectGetMaxY(BGImageView.frame), BGImageView.frame.size.width, SCREENHEIGHT - CGRectGetMaxY(BGImageView.frame))];
    UIImage * shadowImage = [UIImage imageNamed:@"BG_IMG6"];
    shadowImage = [UIImage imageTransformWithImage:shadowImage];
    BGImageViewShadow.image = shadowImage;
    BGImageViewShadow.contentMode = UIViewContentModeScaleAspectFit;
    [BGImageViewShadow changeAlphaWithDirection:kDirectionDown];
    BGImageViewShadow.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.view addSubview:BGImageViewShadow];
}


-(void)draggingImage:(UIPanGestureRecognizer *)recognizer{
    //在 x 轴上面滑动的距离
    CGFloat tx = [recognizer translationInView:self.view].x;
    
    //在 y 轴上面滑动的距离
//    CGFloat ty = [recognizer translationInView:self.view].y;
    
    CGFloat angle = tx/SCREENWIDTH;
    
//    NSLog(@"x = %f,y = %f,angle = %f",tx,ty,angle*M_PI);
    
    if (self.view.layer.anchorPoint.y != 1.f) {
//        锚点设置
//        旋转方向
        self.view.layer.anchorPoint = CGPointMake(0.5f, 1.f);
//        锚点位置
        self.view.layer.position = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT);
    }
    
    //停止拖动
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state ==UIGestureRecognizerStateCancelled||angle>1||angle<-1) {
        //        界定 pop 还是还原
        CGFloat x = self.view.frame.origin.x;
        CGFloat y = self.view.frame.origin.y;
        
        //滑动超过一半
        if (ABS(x) >= self.view.frame.size.width*0.35 || ABS(y) >= self.view.frame.size.height*0.35||angle>0.35||angle<-0.35) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                //判断是左、右，并且移到左，右边，再 pop.     写的一般自己优化吧
//                if (x>0 &&y>0) {
//                    
//                    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, self.view.frame.size.height);
//                }else if(x>0 && y<0){
//                    
//                    self.view.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, -self.view.frame.size.height);
//                }else if (x<0 && y>0){
//                    
//                    self.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, self.view.frame.size.height);
//                }else if (x<0 && y<0){
//                    
//                    self.view.transform = CGAffineTransformMakeTranslation(-self.view.frame.size.width, -self.view.frame.size.height);
//                    
//                }
                self.view.transform = CGAffineTransformMakeRotation(tx>0?M_PI_2:(-M_PI_2));
                
            }completion:^(BOOL finished) {
                //关闭视图
                [self dismissViewControllerAnimated:NO completion:^{
                    self.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
                    self.view.layer.position = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT/2.f);
                    self.view.transform = CGAffineTransformIdentity;
                }];
            }];
            
        }else{
            //动画返回
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }completion:^(BOOL finished) {
                self.view.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
                self.view.layer.position = CGPointMake(SCREENWIDTH/2.f, SCREENHEIGHT/2.f);
            }];
        }
    }else{//正在拖拽
//        self.view.transform = CGAffineTransformMakeTranslation(tx, ty);//平滑移动
        self.view.transform = CGAffineTransformMakeRotation(angle*M_PI_4);//倾斜角
        
    }
    
    
}

@end
