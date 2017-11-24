//
//  AppDelegate.m
//  NxhTest
//
//  Created by apple on 2017/8/15.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

#import "BBSAVAudio.h"

#import "BBSAVPlayer.h"

@interface AppDelegate ()

@property (assign, nonatomic) UIBackgroundTaskIdentifier bgTaskId;
@property (assign, nonatomic) BOOL isReStarMusic;//再启动音乐


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[HomeViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    //    初始化音乐中断事件状态
    _isReStarMusic = NO;
    
    return YES;
}

//实现获取backgroundPlayerID
+(UIBackgroundTaskIdentifier)backgroundPlayerID:(UIBackgroundTaskIdentifier)backTaskId{
    //设置并激活音频会话类别
    //    AVAudioSession *session=[AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [session setActive:YES error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //设置后台任务ID
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if(newTaskId!=UIBackgroundTaskInvalid&&backTaskId!=UIBackgroundTaskInvalid){
        [[UIApplication sharedApplication] endBackgroundTask:backTaskId];
    }
    return newTaskId;
}

//处理音乐中断事件
-(void)handleMusicInterreption:(NSNotification *)notification{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_PAUSE object:nil userInfo:nil];
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume&&_isReStarMusic) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MUSIC_PLAY object:nil userInfo:nil];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //    注册backgroundPlayerID以处理音乐中断事件
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:NULL];
    _bgTaskId = [AppDelegate backgroundPlayerID:_bgTaskId];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //    重置音乐中断事件状态
    if ([BBSAVAudio shareMusicTool].player.isPlaying) {
        _isReStarMusic = YES;
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //    重置音乐中断事件状态
    _isReStarMusic = NO;
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
