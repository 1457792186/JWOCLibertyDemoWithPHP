//
//  BBSAnimatedTransitionViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSAnimatedTransitionViewController.h"

@interface BBSAnimatedTransitionViewController ()

@end

@implementation BBSAnimatedTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义转场效果";
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
