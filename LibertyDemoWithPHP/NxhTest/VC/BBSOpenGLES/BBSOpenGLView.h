//
//  BBSOpenGLView.h
//  NxhTest
//
//  Created by apple on 2018/2/13.
//  Copyright © 2018年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

@interface BBSOpenGLView : UIView

@property (nonatomic,strong)CAEAGLLayer* eaglLayer;
@property (nonatomic,strong)EAGLContext* context;
@property (nonatomic,assign)GLuint colorRenderBuffer;

@end
