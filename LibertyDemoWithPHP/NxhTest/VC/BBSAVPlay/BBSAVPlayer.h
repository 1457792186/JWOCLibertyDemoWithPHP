//
//  BBSAVPlayer.h
//  NxhTest
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
//音频播放
#import <AVFoundation/AVFoundation.h>

@interface BBSAVPlayer : NSObject

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) BOOL isPlaying;//播放状态
@property (nonatomic, assign) CGFloat progress;//播放进度
@property (nonatomic, copy) NSString *playTime;//当前播放时间
@property (nonatomic, copy) NSString *playDuration;//总时长

+(instancetype)shareMusicTool;

@property (nonatomic, copy) NSString *currentUrl;

/// 播放
/// @param urlStr 歌曲url
-(void)playMusicWithMusicURL:(NSString *)urlStr;

// 播放
- (void)playAction;

// 播放
- (void)play;

// 暂停
- (void)pause;

//下一首
- (void)nextAction;

//上一首
- (void)preAction;


@end
