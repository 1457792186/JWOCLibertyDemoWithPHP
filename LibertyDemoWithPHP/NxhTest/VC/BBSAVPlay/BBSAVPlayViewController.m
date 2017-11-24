//
//  BBSAVPlayViewController.m
//  NxhTest
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSAVPlayViewController.h"
#import "BBSMovieViewController.h"

@interface BBSAVPlayViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *avListTableView;
@property (strong, nonatomic)NSArray * dataArr;

@end

@implementation BBSAVPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArr = @[@"音频播放",@"视频播放器",@"直播",@"返回"];
/*
 音频播放的实现级别：
 (1) 离线播放：这里并不是指应用不联网，而是指播放本地音频文件，包括先下完完成音频文件再进行播放的情况，这种使用AVFoundation里的AVAudioPlayer可以满足
            BBSAVAudio  暂无界面
 (2) 在线播放：使用AVFoundation的AVPlayer可以满足
            BBSAVPlayer 暂无界面
 (3) 在线播放同时存储文件：使用
 AudioFileStreamer ＋ AudioQueue 可以满足
 (4) 在线播放且带有音效处理：使用
 AudioFileStreamer ＋ AudioQueue ＋ 音效模块（系统自带或者自行开发）来满足
 */
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * avCell = [[UITableViewCell alloc]init];
    avCell.textLabel.text = self.dataArr[indexPath.row];
    avCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return avCell;
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.f)];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = @"音视频";
    return headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArr.count-1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (indexPath.row >= 1) {
        BBSMovieViewController * moiveVC = [[BBSMovieViewController alloc]init];
        moiveVC.url = indexPath.row == 1?@"http://baobab.cdn.wandoujia.com/14468618701471.mp4":@"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8";
//        @"http://baobab.cdn.wandoujia.com/14468618701471.mp4"         普通url
//        @"http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8"      直播源
        [self presentViewController:moiveVC animated:YES completion:nil];
    }
    
}

@end
