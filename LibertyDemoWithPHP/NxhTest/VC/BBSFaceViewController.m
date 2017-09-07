//
//  BBSFaceViewController.m
//  NxhTest
//
//  Created by apple on 2017/9/7.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSFaceViewController.h"
#import "JWAnimatedTransitioning.h"
#import "JWPercentDrivenInteractiveTransition.h"

#import <AVFoundation/AVFoundation.h>
#import "UIImage+JWImage.h"

@interface BBSFaceViewController ()<AVCapturePhotoCaptureDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>
//AVCaptureVideoDataOutputSampleBufferDelegate需要动态进行人脸识别，所以需要启用数据流，在这里需要设置并遵守代理

//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession * session;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput * videoInput;

//照片输出流对象，当然本例照相机只有拍照功能，所以只需要这个对象,适配iOS10
@property (nonatomic, strong) AVCapturePhotoOutput * stillNewImageOutput;
@property (nonatomic, strong) AVCaptureStillImageOutput * stillImageOutput;

//预览图层，来显示照相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * previewLayer;
@property (nonatomic, strong) AVCaptureVideoDataOutput *videoDataOutput;    //原始视频帧，用于获取实时图像以及视频录制
@property (nonatomic, strong) AVCaptureMetadataOutput *metadataOutput;      //用于二维码识别以及人脸识别


//切换前后镜头的按钮
@property (nonatomic, strong) UIButton * toggleButton;
//拍照按钮
@property (nonatomic, strong) UIButton * shutterButton;
//放置预览图层的View
@property (nonatomic, strong) UIView * cameraShowView;

//展示拍照成果
@property (nonatomic, strong)UIImageView * showImageView;

@property (nonatomic, strong)UIImageView * stickerLeftEyeCameraImageView;//贴纸图片
@property (nonatomic, strong)UIImageView * stickerRightEyeCameraImageView;//贴纸图片
@property (nonatomic, strong)UIImageView * stickerMouthEyeCameraImageView;//贴纸图片


@end

@implementation BBSFaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"人脸识别&自定义相机";
    
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.showImageView.hidden = !self.showImageView.hidden;
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
    
    
//    相机数据流设置
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    dispatch_queue_t queue;
    queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    [captureOutput setSampleBufferDelegate:self queue:queue];
    
    NSString *key = (NSString *)kCVPixelBufferPixelFormatTypeKey;
    NSNumber *value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary *settings = @{key:value};
    [captureOutput setVideoSettings:settings];
    [self.session addOutput:captureOutput];
}
//获取硬件设备，device有很多属性可以调整(注意调整device属性的时候需要上锁, 调整完再解锁)
//-(AVCaptureDevice *)device{
//    if (_device == nil) {
//        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//        if ([_device lockForConfiguration:nil]) {
//            //自动闪光灯
//            if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
//                [_device setFlashMode:AVCaptureFlashModeAuto];
//            }
//            //自动白平衡
//            if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance]) {
//                [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance];
//            }
//            //自动对焦
//            if ([_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
//                [_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
//            }
//            //自动曝光
//            if ([_device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
//                [_device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
//            }
//            [_device unlockForConfiguration];
//        }
//    }
//    return _device;
//}

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
        
        self.cameraShowView = [[UIView alloc]initWithFrame:CGRectMake(0.f, 0.f, SCREENWIDTH, SCREENHEIGHT)];
        //添加贴纸视图
        self.stickerLeftEyeCameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20.f, 40.f)];
        self.stickerLeftEyeCameraImageView.hidden = YES;
        [self.cameraShowView addSubview:self.stickerLeftEyeCameraImageView];
        self.stickerRightEyeCameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20.f, 40.f)];
        self.stickerRightEyeCameraImageView.hidden = YES;
        [self.cameraShowView addSubview:self.stickerRightEyeCameraImageView];
        self.stickerMouthEyeCameraImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20.f, 50.f)];
        self.stickerMouthEyeCameraImageView.hidden = YES;
        [self.cameraShowView addSubview:self.stickerMouthEyeCameraImageView];
        //添加照片流显示
        [self.view addSubview:self.cameraShowView];
        CALayer * cameraShowLayer = [self.cameraShowView layer];
        
        [cameraShowLayer setMasksToBounds:YES];
        
        [self.previewLayer setFrame:self.cameraShowView.frame];
        [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        
        [cameraShowLayer insertSublayer:self.previewLayer below:[[cameraShowLayer sublayers] firstObject]];
        
        
        //    拍照结果显示
        self.showImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, SCREENHEIGHT/2.f, SCREENWIDTH, SCREENHEIGHT/2.f)];
        self.showImageView.backgroundColor = [UIColor redColor];
        self.showImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.showImageView.hidden = YES;
        [self.showImageView setUserInteractionEnabled:YES];
        [self.view addSubview:self.showImageView];
        
        //    初始化按钮
        self.toggleButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, 0.f, 60.f, 30.f)];
        self.toggleButton.backgroundColor = [UIColor cyanColor];
        [self.toggleButton setTitle:@"切换" forState:UIControlStateNormal];
        [self.toggleButton addTarget:self action:@selector(toggleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.showImageView addSubview:self.toggleButton];
        
        self.shutterButton = [[UIButton alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.toggleButton.frame)+20.f, 60.f, 30.f)];
        self.shutterButton.backgroundColor = [UIColor cyanColor];
        [self.shutterButton setTitle:@"拍照" forState:UIControlStateNormal];
        [self.shutterButton addTarget:self action:@selector(shutterButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.showImageView addSubview:self.shutterButton];
        
        UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.shutterButton.frame)+20.f, 60.f, 30.f)];
        backBtn.backgroundColor = [UIColor cyanColor];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.showImageView addSubview:backBtn];
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
            image = [UIImage fixOrientation:image];
            NSLog(@"image size = %@",NSStringFromCGSize(image.size));
            self.showImageView.image = image;
            //人脸识别
            [self imageCheckFace:image];
        }];
    }
}

- (void)backButtonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        image = [UIImage fixOrientation:image];
        NSLog(@"image size = %@",NSStringFromCGSize(image.size));
        self.showImageView.image = image;
        //人脸识别
        [self imageCheckFace:image];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
//相机数据流处理
// 这个方法是将数据流的帧转换成图片
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    UIImage *img = [self imageFromSampleBuffer:sampleBuffer];
    img = [UIImage fixOrientation:img];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self imageCheckFace:img];
    });
}

// 通过抽样缓存数据创建一个UIImage对象
//在该代理方法中，sampleBuffer是一个Core Media对象，可以引入Core Video供使用
- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
    UIImage *result = [[UIImage alloc] initWithCGImage:videoImage scale:1.0 orientation:UIImageOrientationLeftMirrored];
    CGImageRelease(videoImage);
    return result;
}


#pragma mark - Image
//图片识别人脸
- (void)imageCheckFace:(UIImage *)faceImage{
    //此处是CIDetectorAccuracyHigh，若用于real-time的人脸检测，则用CIDetectorAccuracyLow，更快
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *ciimg = [CIImage imageWithCGImage:faceImage.CGImage];
    //得到面部数据
    NSArray *features = [faceDetector featuresInImage:ciimg];
    
    [self hideStickerImageView];
    
    for (CIFaceFeature *f in features){
        CGRect aRect = f.bounds;
        NSLog(@"\n\nfeatures == %f, %f, %f, %f", aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
        NSLog(@"image size = %f , %f",faceImage.size.width,faceImage.size.height);
        //眼睛和嘴的位置
        if(f.hasLeftEyePosition){
            NSLog(@"Left eye %g %g\n", f.leftEyePosition.x, f.leftEyePosition.y);
            UIImage * leftEyeImage = [UIImage imageNamed:@"leftEye"];
            [self showStickerImageViewWithImageView:self.stickerLeftEyeCameraImageView withImage:leftEyeImage withPoint:f.leftEyePosition withBGImage:faceImage.size];
        }
        if(f.hasRightEyePosition){
            NSLog(@"Right eye %g %g\n", f.rightEyePosition.x, f.rightEyePosition.y);
            UIImage * rightEyeImage = [UIImage imageNamed:@"rightEye"];
            [self showStickerImageViewWithImageView:self.stickerRightEyeCameraImageView withImage:rightEyeImage withPoint:f.rightEyePosition withBGImage:faceImage.size];
        }
        if(f.hasMouthPosition){
            NSLog(@"Mouth %g %g\n", f.mouthPosition.x, f.mouthPosition.y);
            UIImage * mouthImage = [UIImage imageNamed:@"mouth"];
            [self showStickerImageViewWithImageView:self.stickerMouthEyeCameraImageView withImage:mouthImage withPoint:f.mouthPosition withBGImage:faceImage.size];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.showImageView.image = faceImage;
        });
    }
}

#pragma mark - StickerImageViewSet
- (void)hideStickerImageView{
    self.stickerLeftEyeCameraImageView.hidden = YES;
    self.stickerRightEyeCameraImageView.hidden = YES;
    self.stickerMouthEyeCameraImageView.hidden = YES;
}

- (void)showStickerImageViewWithImageView:(UIImageView *)showImageView withImage:(UIImage *)image withPoint:(CGPoint)point withBGImage:(CGSize)BGImageSize{
    showImageView.hidden = NO;
    showImageView.image = image;
    showImageView.center = CGPointMake(point.x*SCREENWIDTH/BGImageSize.width, (BGImageSize.height - point.y)*(SCREENHEIGHT)/BGImageSize.height);
}

@end
