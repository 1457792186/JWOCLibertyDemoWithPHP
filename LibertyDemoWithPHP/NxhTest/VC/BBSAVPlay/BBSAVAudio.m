//
//  BBSAVAudio.m
//  NxhTest
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSAVAudio.h"

@interface BBSAVAudio ()

@property (nonatomic, copy) NSString *currentName;
@property (nonatomic, assign) CGFloat musicProgre;

@end

@implementation BBSAVAudio

// 单例
+(instancetype)shareMusicTool {
    static BBSAVAudio *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BBSAVAudio alloc]init];
        
        //后台播放相关
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
//        注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playAction) name:MUSIC_PLAY object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preAction) name:@"preAction" object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextAction) name:@"nextAction" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:MUSIC_PAUSE object:nil];
        
        instance.player = [[AVAudioPlayer alloc]init];
    });
    return instance;
}
// 播放
-(void)playMusicWithMusicName:(NSString *)name {
    
    if (name == nil) {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle]pathForResource:name ofType:nil];
    
    if (path == nil) {
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:path];
    
    if (![self.currentName isEqualToString:name]) {
        
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    }
    self.currentName = name;
    [self.player prepareToPlay];
    [self.player play];
}
// 暂停
- (void)playAction{
    if (!self.player.playing) {
        [self.player play];
    }
}

// 暂停
- (void)pause{
    if (self.player.playing) {
        [self.player pause];
    }
}
/// 总时长字符串
-(NSString *)durationMusicString {
    return [NSString stringWithFormat:@"%02d:%02d",(int)self.player.duration / 60, (int)self.player.duration % 60];
}
/// 总时长
-(NSTimeInterval)durationMusic {
    return self.player.duration;
}
/// 返回当前时长字符串
-(NSString *)currentTimeString {
    return [NSString stringWithFormat:@"%02d:%02d",(int)self.player.currentTime / 60, (int)self.player.currentTime % 60];
}
/// 返回当前时长
-(NSTimeInterval)currentTime {
    return self.player.currentTime;
}

/// 当前进度
-(CGFloat)musicProgress {
    return self.player.currentTime / self.player.duration;
}

@end
