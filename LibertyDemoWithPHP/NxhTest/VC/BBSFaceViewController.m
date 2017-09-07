//
//  BBSFaceViewController.m
//  NxhTest
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSFaceViewController.h"
#import "JWAnimatedTransitioning.h"
#import "JWPercentDrivenInteractiveTransition.h"


#import <AVFoundation/AVFoundation.h>

@interface BBSFaceViewController ()<AVCapturePhotoCaptureDelegate>
//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession * session;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput * videoInput;

//照片输出流对象，当然本例照相机只有拍照功能，所以只需要这个对象,适配iOS10
@property (nonatomic, strong) AVCapturePhotoOutput * stillNewImageOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput * stillImageOutput;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
//切换前后镜头的按钮
@property (nonatomic, strong) UIButton * toggleButton;
//拍照按钮
@property (nonatomic, strong) UIButton * shutterButton;
//放置预览图层的View
@property (nonatomic, strong) UIView * cameraShowView;

//展示拍照成果
@property (nonatomic, strong)UIImageView * showImageView;

@end

@implementation BBSFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脸识别";
    
    [self setupCamera];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupCameraLayer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.session) {
        [self.session startRunning];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.session) {
        [self.session stopRunning];
    }
}

#pragma mark - AVFoundation
//初始化相机
- (void)setupCamera{
    self.session = [[AVCaptureSession alloc]init];
    
    self.videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:nil];//初始化采用前摄像头
    
    //添加输入
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        AVCapturePhotoSettings * outputSettings = [AVCapturePhotoSettings photoSettingsWithFormat:@{AVVideoCodecKey:AVVideoCodecJPEG}];
        self.stillNewImageOutput = [[AVCapturePhotoOutput alloc]init];
        [self.stillNewImageOutput capturePhotoWithSettings:outputSettings delegate:self];
        
        //添加输出
        if ([self.session canAddOutput:self.stillNewImageOutput]) {
            [self.session addOutput:self.stillNewImageOutput];
        }
    }else{
        NSDictionary * outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
        [self.stillImageOutput setOutputSettings:outputSettings];
        
        //添加输出
        if ([self.session canAddOutput:self.stillImageOutput]) {
            [self.session addOutput:self.stillImageOutput];
        }
    }
    
//    拍照结果显示
    self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, SCREENHEIGHT/2.f, SCREENWIDTH, SCREENHEIGHT/2.f)];
    self.showImageView.backgroundColor = [UIColor redColor];
    self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.showImageView setUserInteractionEnabled:YES];
    [self.view addSubview:self.showImageView];
    
//    初始化按钮
    self.toggleButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 60.f, 30.f)];
    self.toggleButton.backgroundColor = [UIColor cyanColor];
    [self.toggleButton setTitle:@"切换" forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.showImageView addSubview:self.toggleButton];
    
    self.shutterButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxX(self.toggleButton.frame)+10.f, 60.f, 30.f)];
    self.shutterButton.backgroundColor = [UIColor cyanColor];
    [self.shutterButton setTitle:@"拍照" forState:UIControlStateNormal];
    [self.shutterButton addTarget:self action:@selector(shutterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.showImageView addSubview:self.shutterButton];
}


//获取前后摄像头
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        devices = [AVCaptureDeviceDiscoverySession  discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:position].devices;
    }else{
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    }
    
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}
- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}
- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}


//加载预览图层
- (void)setupCameraLayer{
    
//    判断是否授权相机
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        NSLog(@"应用相机权限受限,请在设置中启用");
        return;
    }
    
    if (!self.previewLayer) {
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        
        self.cameraShowView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT/2.f)];
        [self.view addSubview:self.cameraShowView];
        CALayer * cameraShowLayer = [self.cameraShowView layer];
        
        [cameraShowLayer setMasksToBounds:YES];
        
        [self.previewLayer setFrame:self.cameraShowView.frame];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        
        [cameraShowLayer insertSublayer:self.previewLayer below:[[cameraShowLayer sublayers] firstObject]];
    }
}

//切换前后摄像头
- (void)toggleButtonAction{
    NSArray *devices;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        devices = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:[[_videoInput device] position]].devices;
    }else{
        devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    }
    
    NSUInteger cameraCount = [devices count];
    if (cameraCount > 1) {
        NSError *error;
        AVCaptureDeviceInput *newVideoInput;
        AVCaptureDevicePosition position = [[_videoInput device] position];
        
        if (position == AVCaptureDevicePositionBack){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontCamera] error:&error];
        }else if (position == AVCaptureDevicePositionFront){
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backCamera] error:&error];
        }else{
            return;
        }
        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:self.videoInput];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                [self setVideoInput:newVideoInput];
            } else {
                [self.session addInput:self.videoInput];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
    }
}

//拍照方法
- (void)shutterButtonAction{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        AVCaptureConnection * videoConnection = [self.stillNewImageOutput connectionWithMediaType:AVMediaTypeVideo];
    }else{
        AVCaptureConnection * videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        
        if (!videoConnection) {
            NSLog(@"take photo failed!");
            return;
        }
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (imageDataSampleBuffer == NULL) {
                return ;
            }
            NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage * image = [UIImage imageWithData:imageData];
            NSLog(@"image size = %@",NSStringFromCGSize(image.size));
            self.showImageView.image = image;
        }];
    }
}


#pragma mark - AVCapturePhotoCaptureDelegate
//AVCapturePhotoCaptureDelegate获取图片
- (void)captureOutput:(AVCapturePhotoOutput *)captureOutput didFinishProcessingPhotoSampleBuffer:(nullable CMSampleBufferRef)photoSampleBuffer previewPhotoSampleBuffer:(nullable CMSampleBufferRef)previewPhotoSampleBuffer resolvedSettings:(AVCaptureResolvedPhotoSettings *)resolvedSettings bracketSettings:(nullable AVCaptureBracketedStillImageSettings *)bracketSettings error:(nullable NSError *)error{
    if (error) {
        NSLog(@"error : %@", error.localizedDescription);
    }
    
    if (photoSampleBuffer) {
        NSData *data = [AVCapturePhotoOutput JPEGPhotoDataRepresentationForJPEGSampleBuffer:photoSampleBuffer previewPhotoSampleBuffer:previewPhotoSampleBuffer];
        UIImage *image = [UIImage imageWithData:data];
        self.showImageView.image = image;
    }
}


@end
