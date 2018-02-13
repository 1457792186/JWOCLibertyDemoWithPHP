//
//  BBSOpenGLViewController.m
//  NxhTest
//
//  Created by apple on 2018/2/13.
//  Copyright © 2018年 UgoMedia. All rights reserved.
//

#import "BBSOpenGLViewController.h"
#import "BBSOpenGLView.h"

@interface BBSOpenGLViewController ()

@property (nonatomic, strong)BBSOpenGLView *glView;

@end

@implementation BBSOpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.glView = [[BBSOpenGLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:_glView];
}



@end
