//
//  BBSDownloadingTableViewCell.h
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"

typedef void(^JWDownloadBlock)(UIButton *);

@interface BBSDownloadingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (nonatomic, copy  ) JWDownloadBlock downloadBlock;
@property (nonatomic, strong) ZFSessionModel  *sessionModel;

@end
