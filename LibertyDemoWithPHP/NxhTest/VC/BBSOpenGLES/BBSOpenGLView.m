//
//  BBSOpenGLView.m
//  NxhTest
//
//  Created by apple on 2018/2/13.
//  Copyright © 2018年 UgoMedia. All rights reserved.
//

#import "BBSOpenGLView.h"

@implementation BBSOpenGLView

//1.设置layer class 为 CAEAGLLayer
//显示OpenGL的内容,需要把它缺省的layer设置为一个特殊的layer（CAEAGLLayer）,通过直接复写layerClass的方法
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

//2.设置layer为不透明（Opaque）
//透明的层对性能负荷很大，特别是OpenGL的层,尽量都把层设置为不透明
- (void)setupLayer {
    _eaglLayer = (CAEAGLLayer*) self.layer;
    _eaglLayer.opaque = YES;
}

//3.创建OpenGL context
//EAGLContext管理所有通过OpenGL进行draw的信息。这个与Core Graphics context类似。
//当创建一个context，要声明要用哪个version的API。这里，选择OpenGL ES 2.0.
- (void)setupContext {
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    _context = [[EAGLContext alloc] initWithAPI:api];
    if (!_context) {
        NSLog(@"Failed to initialize OpenGLES 2.0 context");
        exit(1);
    }
    
    if (![EAGLContext setCurrentContext:_context]) {
        NSLog(@"Failed to set current OpenGL context");
        exit(1);
    }
}

//4.创建render buffer （渲染缓冲区）
//Render buffer 是OpenGL的一个对象，用于存放渲染过的图像
/*
 会发现render buffer会作为一个color buffer被引用，因为本质上它就是存放用于显示的颜色。
 
 创建render buffer的三步：
 1.调用glGenRenderbuffers来创建一个新的render buffer object。这里返回一个唯一的integer来标记render buffer（这里把这个唯一值赋值到_colorRenderBuffer）。有时候会发现这个唯一值被用来作为程序内的一个OpenGL 的名称。（反正它唯一嘛）
 2.调用glBindRenderbuffer ，告诉这个OpenGL：在后面引用GL_RENDERBUFFER的地方，其实是想用_colorRenderBuffer。其实就是告诉OpenGL，定义的buffer对象是属于哪一种OpenGL对象
 3.最后，为render buffer分配空间。renderbufferStorage
 */
- (void)setupRenderBuffer {
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}


//5.创建一个 frame buffer （帧缓冲区）
/*
 Frame buffer也是OpenGL的对象，它包含了前面提到的render buffer，以及其它后面会讲到的诸如：depth buffer、stencil buffer 和 accumulation buffer。

 前两步创建frame buffer的动作跟创建render buffer的动作很类似。（也是用一个glBind什么的）
 
 而最后一步  glFramebufferRenderbuffer 这个才有点新意。它把前面创建的buffer render依附在frame buffer的GL_COLOR_ATTACHMENT0位置上
 */
- (void)setupFrameBuffer {
    GLuint framebuffer;
    glGenFramebuffers(1, &framebuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, framebuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _colorRenderBuffer);
}

//6.清理屏幕
/*
 这里每个RGB色的范围是0~1，所以每个要除一下255.
 
 下面解析一下每一步动作：
 
 1.调用glClearColor ，设置一个RGB颜色和透明度，接下来会用这个颜色涂满全屏。
 
 2.调用glClear来进行这个“填色”的动作（大概就是photoshop那个油桶嘛）。还记得前面说过有很多buffer的话，这里我们要用到GL_COLOR_BUFFER_BIT来声明要清理哪一个缓冲区。
 
 3.调用OpenGL context的presentRenderbuffer方法，把缓冲区（render buffer和color buffer）的颜色呈现到UIView上。
 */
- (void)render {
    glClearColor(0, 104.0/255.0, 55.0/255.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

//7.修改初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
        [self setupContext];
        [self setupRenderBuffer];
        [self setupFrameBuffer];
        [self render];
    }
    return self;
}




@end
