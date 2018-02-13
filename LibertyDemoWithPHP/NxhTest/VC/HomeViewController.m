//
//  ViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "HomeViewController.h"
#import "BBSARViewController.h"
#import "iCarousel.h"
#import "UIImage+JWImage.h"
#import "UIImageView+JWImageView.h"

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
#import "BBSCustomPickerViewController.h"
#import "BBSSpeechRecognitionVC.h"
#import "BBSAVPlayViewController.h"
#import "BBSDrawingViewController.h"
#import "BBSCoreDataViewController.h"
#import "BBSOpenGLViewController.h"

//iOS应用内评分
#ifdef __IPHONE_10_3
#import <StoreKit/StoreKit.h>
#endif


@interface HomeViewController ()<iCarouselDataSource, iCarouselDelegate,TZImagePickerControllerDelegate>

@property (strong, nonatomic)iCarousel *carousel;
@property (strong, nonatomic)NSMutableArray * dataArray;
@property (strong, nonatomic)NSMutableArray * nameArray;
@property (strong, nonatomic)UIImageView * bgImageView;

@property (nonatomic,strong)NSTimer * timer;
@property (nonatomic,assign)NSInteger time;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"翻页效果";
    
    self.view.backgroundColor = [UIColor cyanColor];
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    [_bgImageView setUserInteractionEnabled:YES];
    [self.view addSubview:_bgImageView];
    
    _nameArray = [NSMutableArray arrayWithArray:@[@"图表绘制",
                                                  @"网络连接",
                                                  @"网络连接本地",
                                                  @"图片选择器",
                                                  @"断点下载",
                                                  @"文本特效",
                                                  @"拖拽视图",
                                                  @"自定义转场",
                                                  @"转场&拖拽",
                                                  @"股票绘制",
                                                  @"人脸识别",
                                                  @"AR",
                                                  @"多级选择栏",
                                                  @"原生语音识别",
                                                  @"音视频",
                                                  @"原生绘图",
                                                  @"CoreData",
                                                  @"OpenGL",
                                                  @"背景图毛玻璃"]];
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
    
    //    销毁，重置计时器
    [self reSetTimer];
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

#pragma mark - NSTimer & StoreKit

- (void)reSetTimer{
    //    销毁，重置计时器
    if(self.timer&&self.timer.isValid) {
        [self.timer invalidate];
    }
    self.timer = nil;
    self.time = 0;
    
    //    创建计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeMaxAction) userInfo:nil repeats:YES];
}

- (void)timeMaxAction{
    //  到计时时间事件
    if (self.time >= 3*60) {
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self reSetTimer];
        }];
        
        UIAlertAction * commentAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self reSetTimer];
            [self commentApp];
        }];
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"评分" message:@"请评分" preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:cancelAction];
        [alertVC addAction:commentAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        self.time++;
    }
}

- (void)commentApp{
//    应用内评论App
#ifdef __IPHONE_10_3
    if([SKStoreReviewController respondsToSelector:@selector(requestReview)]) {// iOS 10.3 以上支持
        [SKStoreReviewController requestReview];
        return;
    }
#endif
    
    // iOS 10.3 之前的使用这个
    NSString  * nsStringToOpen = [NSString  stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"APPID"];//替换为对应的APPID
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpen]];
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
        {//原生人脸动态识别
            BBSFaceViewController * faceVC = [[BBSFaceViewController alloc]init];
            [self presentViewController:faceVC animated:YES completion:nil];
        }
            break;
        case 11:
        {//AR测试-Target中添加，原文件仅参考
            BBSARViewController * arVC = [[BBSARViewController alloc]init];
            if (IOS11_OR_LATER) {
                [self presentViewController:arVC animated:YES completion:nil];
            }else{
                NSLog(@"iOS11前不可用");
            }
        }
            break;
        case 12:
        {//多级选择栏
            BBSCustomPickerViewController * customPickerVC = [[BBSCustomPickerViewController alloc]init];
            [self presentViewController:customPickerVC animated:YES completion:nil];
        }
            break;
        case 13:
        {//原生语音识别
            BBSSpeechRecognitionVC * speechRecognitionVC = [[BBSSpeechRecognitionVC alloc]init];
            [self presentViewController:speechRecognitionVC animated:YES completion:nil];
        }
            break;
        case 14:
        {//音视频集合
            BBSAVPlayViewController * avVC = [[BBSAVPlayViewController alloc]init];
            [self presentViewController:avVC animated:YES completion:nil];
        }
            break;
        case 15:
        {//原生绘图
            BBSDrawingViewController * drawVC = [[BBSDrawingViewController alloc]init];
            [self presentViewController:drawVC animated:YES completion:nil];
        }
            break;
        case 16:
        {//CoreData
            BBSCoreDataViewController * dataVC = [[BBSCoreDataViewController alloc]init];
            [self presentViewController:dataVC animated:YES completion:nil];
        }
            break;
        case 17:
        {//CoreData
            BBSOpenGLViewController * openGLVC = [[BBSOpenGLViewController alloc]init];
            [self presentViewController:openGLVC animated:YES completion:nil];
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

#pragma mark- GCD
- (void)gcdShow{
//    可以使用dispatch_queue_create来创建对象，需要传入两个参数，第一个参数表示队列的唯一标识符，用于DEBUG，可为空；第二个参数用来识别是串行队列还是并行队列。DISPATCH_QUEUE_SERIAL表示串行队列，DISPATCH_QUEUE_CONCURRENT表示并行队列
//    对于并行队列，还可以使用dispatch_get_global_queue来创建全局并行队列。GCD默认提供了全局的并行队列，需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可
    
    // 串行队列的创建方法
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_SERIAL);
    // 并行队列的创建方法
    dispatch_queue_t queues= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    // 同步执行任务创建方法
    dispatch_sync(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);    // 这里放任务代码
    });
    // 异步执行任务创建方法
    dispatch_async(queue, ^{
        NSLog(@"%@",[NSThread currentThread]);    // 这里放任务代码
    });
    
    /*
     GCD只需两步，既然有两种队列，两种任务执行方式，那么就有了四种不同的组合方式。这四种不同的组合方式是
     并行队列 + 同步执行
     并行队列 + 异步执行
     串行队列 + 同步执行
     串行队列 + 异步执行
     
     实际上，还有一种特殊队列是主队列，那样就有六种不同的组合方式dispatch_queue_t queue = dispatch_get_main_queue();
     主队列 + 同步执行
     主队列 + 异步执行
     
     
     不同组合方式区别:
                    并行队列                    串行队列                       主队列
     同步(sync)    没有开启新线程，串行执行任务    没有开启新线程，串行执行任务       没有开启新线程，串行执行任务
     异步(async)   有开启新线程，并行执行任务      有开启新线程(1条)，串行执行任务    没有开启新线程，串行执行任务
     */
}

- (void)gcdDemo{//仅举例一个
//    并行队列 + 异步执行
//    可同时开启多线程，任务交替执行
    NSLog(@"asyncConcurrent---begin");
    
    dispatch_queue_t queue= dispatch_queue_create("test.queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"1------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"2------%@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            NSLog(@"3------%@",[NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent---end");
}

- (void)gcdBarrier{
//    1.GCD的栅栏方法 dispatch_barrier_async
    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"----1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2-----%@", [NSThread currentThread]);
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier-----%@", [NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----4-----%@", [NSThread currentThread]);
    });
//    在执行完栅栏前面的操作之后，才执行栅栏操作，最后再执行栅栏后边的操作
}
- (void)gcdAfter{
    //2.dispatch_after延迟操作
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 2秒后异步执行这里的代码...
    });
}

- (void)gcdOnce{
    //3.dispatch_once只执行一次，单例内常用
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
    });
}

- (void)gcdApply{
//    4.快速迭代方法 dispatch_apply
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(6, queue, ^(size_t index) {
        NSLog(@"%zd------%@",index, [NSThread currentThread]);
    });
//    可以同时遍历多个数字
}

- (void)gcdGroup{
//    5.GCD的队列组 dispatch_group
//    有时候会有这样的需求：分别异步执行2个耗时操作，然后当2个耗时操作都执行完毕后再回到主线程执行操作。这时候可以用到GCD的队列组。
//    可以先把任务放到队列中，然后将队列放入队列组中。
//    调用队列组的dispatch_group_notify回到主线程执行操作。
    
    dispatch_group_t group =  dispatch_group_create();
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 执行1个耗时的异步操作
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
    });
}

- (void)gcdSemaphore{
//    6.GCD中的信号量
/*
 信号量就是一个资源计数器，对信号量有两个操作来达到互斥，分别是P和V操作。 一般情况是这样进行临界访问或互斥访问的： 设信号量值为1， 当一个进程1运行是，使用资源，进行P操作，即对信号量值减1，也就是资源数少了1个。这是信号量值为0。系统中规定当信号量值为0是，必须等待，知道信号量值不为零才能继续操作。 这时如果进程2想要运行，那么也必须进行P操作，但是此时信号量为0，所以无法减1，即不能P操作，也就阻塞。这样就到到了进程1排他访问。 当进程1运行结束后，释放资源，进行V操作。资源数重新加1，这是信号量的值变为1. 这时进程2发现资源数不为0，信号量能进行P操作了，立即执行P操作。信号量值又变为0.次数进程2咱有资源，排他访问资源。 这就是信号量来控制互斥的原理
 
 ** 简单来讲 信号量为0则阻塞线程，大于0则不会阻塞。则我们通过改变信号量的值，来控制是否阻塞线程，从而达到线程同步。**
 
    在GCD中有三个函数是semaphore的操作，
    分别是：
            dispatch_semaphore_create 创建一个semaphore
            dispatch_semaphore_signal 发送一个信号
            dispatch_semaphore_wait 等待信号
    简单的介绍一下这三个函数
            dispatch_semaphore_create有一个整形的参数，可以理解为信号的总量;
            dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1;
            dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1;
            根据这样的原理，便可以快速的创建一个并发控制来同步任务和有限资源访问控制
 */
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建信号量，并且设置值为10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {
        //关键：
        // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(2);
            // 每次发送信号则semaphore会+1，
            dispatch_semaphore_signal(semaphore);
        });
    }
}
//6.GCD中的信号量Demo2
- (void)gcdSemaphore2{
    /*
     __block BOOL isok = NO;
     
     dispatch_semaphore_t sema = dispatch_semaphore_create(0);
     Engine *engine = [[Engine alloc] init];
     [engine queryCompletion:^(BOOL isOpen) {
     isok = isOpen;
     dispatch_semaphore_signal(sema);
     } onError:^(int errorCode, NSString *errorMessage) {
     isok = NO;
     dispatch_semaphore_signal(sema);
     }];
     
     dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
     // todo what you want to do after net callback
     */
}

@end
