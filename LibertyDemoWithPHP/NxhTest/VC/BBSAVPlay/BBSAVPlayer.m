//
//  BBSAVPlayer.m
//  NxhTest
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSAVPlayer.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>

@interface BBSAVPlayer()
@property (nonatomic, strong) id timeObserve;

@end

@implementation BBSAVPlayer

// 单例
+(instancetype)shareMusicTool {
    static BBSAVPlayer *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BBSAVPlayer alloc]init];
        
        //后台播放相关
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        instance.player = [[AVPlayer alloc]init];
        
        [instance addPlayerNotification];
        
        //    Remote Control控制音乐的播放
        /*
         Remote Control可以让你在不打开APP的情况下控制其播放，最常见的出现于锁屏界面、从屏幕底部上拉和耳机线控三种，可以达到增强用户体验的作用
         */
        //    声明接收Remote Control事件
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    });
    return instance;
}

- (void)addPlayerNotification{
    //        Player注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAction) name:MUSIC_PLAY object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preAction) name:@"preAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextAction) name:@"nextAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:MUSIC_PAUSE object:nil];
}

- (void)playItemAddObserve:(AVPlayerItem *)songItem{
    //    item移除时间观察者：
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }
    
    //    item添加时间观察者：
/*
 (1）方法传入一个CMTime结构体，每到一定时间都会回调一次，包括开始和结束播放
 (2）如果block里面的操作耗时太长，下次不一定会收到回调，所以尽量减少block的操作耗时
 (3）方法会返回一个观察者对象，当播放完毕时需要移除这个观察者
 */
    __weak typeof(self)weakSelf = self;
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
        if (current) {
            weakSelf.progress = current / total;
            weakSelf.playTime = [NSString stringWithFormat:@"%.f",current];
            weakSelf.playDuration = [NSString stringWithFormat:@"%.2f",total];
        }
    }];
    
    //    item移除观察者&通知
    [self playItemRemoveObserve:songItem];
    
    //    item监听改播放器状态-媒体加载状态
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    //    item监听改播放器状态-数据缓冲状态
    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //    item添加通知播放完毕状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
}

//item移除通知&观察者
- (void)playItemRemoveObserve:(AVPlayerItem *)songItem{
    //    item移除观察者
    [songItem removeObserver:self forKeyPath:@"status"];
    [songItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    //    item移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:songItem];
}

//KVO方法中获取item其值的改变
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem * songItem = object;
    
    //    监听改播放器状态-媒体加载状态
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                self.isPlaying = NO;
                break;
            case AVPlayerStatusReadyToPlay:
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                self.isPlaying = NO;
                break;
            default:
                break;
        }
        return;
    }
    
    //    监听改播放器状态-数据缓冲状态
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSLog(@"共缓冲%.2f",totalBuffer);
    }
    
}

//播放完成监听后执行方法
- (void)playbackFinished:(NSNotification *)notice{
    NSLog(@"播放完成");
//    获取当前songItem
    AVPlayerItem * songItem = self.player.currentItem;
//    移除观察者&通知
    [self playItemRemoveObserve:songItem];
    //播放下一首
    [self nextAction];
}

//销毁时移除所有通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - MusicPlay
// 播放
-(void)playMusicWithMusicURL:(NSString *)urlStr{
    NSURL * url  = [NSURL URLWithString:urlStr];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    
/*等价于
 AVPlayer * player = [[AVPlayer alloc] initWithURL:url];
 AVPlayerItem * songItem = player.currentItem;//获取当前播放的item
 */
    
    [self.player play];
    self.isPlaying = YES;
}

// 播放
- (void)playAction{
    NSURL * url  = [NSURL URLWithString:self.currentUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    self.player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    
    //    添加观察者：
    [self playItemAddObserve:songItem];
    
    [self play];
}

// 播放
- (void)play{
    [self.player play];
    self.isPlaying = YES;
}

// 暂停
- (void)pause{
    [self.player pause];
    self.isPlaying = NO;
}

//下一首
- (void)nextAction{
/*多首播放
 一种是使用AVPlayer的子类AVQueuePlayer来播放多个item，调用advanceToNextItem来播放下一首音乐
 
 NSArray * items = @[item1, item2, item3 ....];
 AVQueuePlayer * queuePlayer = [[AVQueuePlayer alloc]initWithItems:items];
 */
    
    NSURL * url  = [NSURL URLWithString:self.currentUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    //    添加观察者：
    [self playItemAddObserve:songItem];
    
    [self.player replaceCurrentItemWithPlayerItem:songItem];
    [self play];
}

//上一首
- (void)preAction{
    NSURL * url  = [NSURL URLWithString:self.currentUrl];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //    添加观察者：
    [self playItemAddObserve:songItem];
    
    [self.player replaceCurrentItemWithPlayerItem:songItem];
    [self play];
}

#pragma mark - Remote Control
/*Remote Control可以让你在不打开APP的情况下控制其播放，最常见的出现于锁屏界面、从屏幕底部上拉和耳机线控三种，可以达到增强用户体验的作用*/
//Remote Control重写方法，成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return YES;
}

//对事件进行处理

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype)    {
        case UIEventSubtypeRemoteControlPlay:
            [self play];
            NSLog(@"remote_播放");
            break;
        case UIEventSubtypeRemoteControlPause:
            [self pause];
            NSLog(@"remote_暂停");
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextAction];
            NSLog(@"remote_下一首");
            break;
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self preAction];
            NSLog(@"remote_上一首");
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            self.isPlaying ? [self pause] : [self play];
            NSLog(@"remote_耳机的播放/暂停");
            break;
        default:
            break;
    }
}

#pragma mark - Now Playing Center
/*Now Playing Center可以在锁屏界面展示音乐的信息，也达到增强用户体验的作用*/
/*
 Now Playing Center并不需要每一秒都去刷新（设置），ElapsedPlaybackTime为播放秒数，根据设置的PlaybackRate来计算进度条展示的进度，比如你PlaybackRate传1，那就是1秒刷新一次进度显示，当然暂停播放的时候它也会自动暂停，PlaybackRate=0时暂停进度。
 
 设置Now Playing Center时候————对于播放网络音乐来说，需要刷新的有几个时间点：当前播放的歌曲变化时（如切换到下一首）、当前歌曲信息变化时（如从Unknown到ReadyToPlay）、当前歌曲拖动进度时
 */
- (void)configNowPlayingCenter {
    NSLog(@"配置NowPlayingCenter");
    NSMutableDictionary * info = [NSMutableDictionary dictionary];
//    //音乐的标题
//    [info setObject:_player.currentSong.title forKey:MPMediaItemPropertyTitle];
//    //音乐的艺术家
//    [info setObject:_player.currentSong.artist forKey:MPMediaItemPropertyArtist];
//    //音乐的播放时间
//    [info setObject:@(self.player.playTime.intValue) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    //音乐的播放速度
//    [info setObject:@(1) forKey:MPNowPlayingInfoPropertyPlaybackRate];
//    //音乐的总时间
//    [info setObject:@(self.player.playDuration.intValue) forKey:MPMediaItemPropertyPlaybackDuration];
//    //音乐的封面
//    MPMediaItemArtwork * artwork = [[MPMediaItemArtwork alloc] initWithImage:_player.coverImg];
//    [info setObject:artwork forKey:MPMediaItemPropertyArtwork];
    //完成设置
    [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:info];
}




@end
