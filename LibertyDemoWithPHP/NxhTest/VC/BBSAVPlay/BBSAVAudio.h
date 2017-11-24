//
//  BBSAVAudio.h
//  NxhTest
//
//  Created by apple on 2017/11/24.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
//音频播放,仅支持下载后播放
#import <AVFoundation/AVFoundation.h>

@interface BBSAVAudio : NSObject
@property (nonatomic, strong) AVAudioPlayer *player;//仅支持下载后播放

+(instancetype)shareMusicTool;
/// 播放
/// @param name 歌曲名称
-(void)playMusicWithMusicName:(NSString *)name;
/// 暂停
-(void)pause;
/// 歌曲总时长字符串
-(NSString *)durationMusicString;
/// 总时长
-(NSTimeInterval)durationMusic;
/// 当前播放时长
-(NSString *)currentTimeString;
/// 当前时长
-(NSTimeInterval)currentTime;
/// 进度
-(CGFloat)musicProgress;

@end
