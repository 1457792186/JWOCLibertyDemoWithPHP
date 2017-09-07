//
//  UIImage+JWImage.h
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (JWImage)

//图片倒转
+ (UIImage *)imageTransformWithImage:(UIImage *)image;

//用来图片翻转90度
+ (UIImage *)fixOrientation:(UIImage *)aImage;

//图片毛玻璃效果
+ (UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

//多张图片合成一张
+ (BOOL) mergedImageOnMainImage:(UIImage *)mainImg WithImageArray:(NSArray *)imgArray AndImagePointArray:(NSArray *)imgPointArray;

// 画水印、添加图片
- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;

//截图
+ (UIImage *)creatScreenShotWithView:(UIView *)view;

//拉伸图片
- (UIImage *)resizableImageWithImage;

//图片拉伸
- (UIImage *)draughtImage;

//图片拉伸到指定大小
- (UIImage *)scaleImageToSize:(CGSize)newSize;

//图片识别人脸
- (UIImage *)imageCheckFace:(UIImage *)faceImage;

#pragma mark - 毛玻璃
- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;//常用
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;


@end
