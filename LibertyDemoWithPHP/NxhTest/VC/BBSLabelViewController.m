//
//  BBSLabelViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/23.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSLabelViewController.h"
#import "NxhTest-Swift.h"
#import "LTMorphingLabel.h"

/*
 引入swift文件：
 引入swift项目 在github上下载原项目压缩包，在Finder中找到LTMorphingLabel文件夹，将其添加到你的项目里。
 项目文件-> TARGETS -> Build Settings -> Packaging -> Define Module设置为 Yes。
 项目文件-> TARGETS -> Build Settings -> Packaging ->Product Module Name设置为你的项目名称。
 ViewController中包含头文件：#import "项目名称-Swift.h"。
 需要首先自创建一个swift文件并继承自NSObject类，若有错项目文件-> TARGETS -> Build Settings ->Swift Language Version更改
 OC引入swift代码的方法都是这个流程
 
 打包注意：
 Builld Settings的Build Options的ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES需要设置为YES
 或者Xcode7设置EMBEDDED_CONTENT_CONTAINS_SWIFT = YES 
 */
@interface BBSLabelViewController ()<LTMorphingLabelDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic)NSArray * textArr;
@property (strong,nonatomic)NSArray * styleTextArr;
@property (strong,nonatomic)UITableView * labelTableView;

@end

@implementation BBSLabelViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    self.title = @"Swift混合编程&炫酷文本效果";
    
    _labelTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT - 64.f)];
    _labelTableView.dataSource = self;
    _labelTableView.delegate = self;
    [self.view addSubview:_labelTableView];
    _textArr = @[@"What is design?",
                 @"Design",
                 @"Design is not just",
                 @"what it looks like",
                 @"and feels like.",
                 @"Design",
                 @"is how it works.",
                 @"- Steve Jobs",
                 @"Older people",
                 @"sit down and ask,",
                 @"'What is it?'",
                 @"but the boy asks,",
                 @"'What can I do with it?'.",
                 @"- Steve Jobs",
                 @"", @"Swift",
                 @"Objective-C",
                 @"iPhone",
                 @"iPad",
                 @"Mac Mini",
                 @"MacBook Pro🔥",
                 @"Mac Pro⚡️",
                 @"爱老婆",
                 @"老婆和女儿"];
    _styleTextArr = @[@"Scale", @"Evaporate", @"Fall", @"Pixelate", @"Sparkle", @"Burn", @"Anvil"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.labelTableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _textArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * labelCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"labelCell"];
//    }
    labelCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![labelCell viewWithTag:1001]) {
        LTMorphingLabel * morphingLabel = [[LTMorphingLabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40.f)];
        morphingLabel.font = [UIFont systemFontOfSize:20.f];
        morphingLabel.text = _textArr[indexPath.row];
        morphingLabel.delegate = self;
        morphingLabel.textColor = [UIColor blackColor];
        morphingLabel.morphingEffect = indexPath.row%_styleTextArr.count;
        morphingLabel.tag = 1001;
        
        [labelCell addSubview:morphingLabel];
        
        UILabel * styleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40.f)];
        styleLabel.text = _styleTextArr[indexPath.row%_styleTextArr.count];
        styleLabel.textAlignment = NSTextAlignmentRight;
        [labelCell addSubview:styleLabel];
    }
    
    
    return labelCell;
}




@end
