//
//  BBSLabelViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSLabelViewController.h"
#import "NxhTest-Swift.h"
#import "LTMorphingLabel.h"

@interface BBSLabelViewController ()

@end

@implementation BBSLabelViewController

/*
 引入swift文件：
 引入swift项目 在github上下载原项目压缩包，在Finder中找到LTMorphingLabel文件夹，将其添加到你的项目里。 
 项目文件-> TARGETS -> Build Settings -> Packaging -> Define Module设置为 Yes。 
 项目文件-> TARGETS -> Build Settings -> Packaging ->Product Module Name设置为你的项目名称。 
 ViewController中包含头文件：#import "项目名称-Swift.h"。
 需要首先自创建一个swift文件并继承自NSObject类，若有错项目文件-> TARGETS -> Build Settings ->Swift Language Version更改
 OC引入swift代码的方法都是这个流程
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
