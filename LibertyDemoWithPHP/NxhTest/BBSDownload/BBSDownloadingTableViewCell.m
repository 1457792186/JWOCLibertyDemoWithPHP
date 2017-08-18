//
//  BBSDownloadingTableViewCell.m
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSDownloadingTableViewCell.h"

@implementation BBSDownloadingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.downloadBtn.clipsToBounds = true;
    [self.downloadBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.downloadBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [self.downloadBtn setTitle:@"下载" forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  暂停、下载
 *
 *  @param sender UIButton
 */
- (IBAction)clickDownload:(UIButton *)sender {
    if (self.downloadBlock) {
        self.downloadBlock(sender);
    }
}

/**
 *  model setter
 *
 *  @param sessionModel sessionModel
 */
- (void)setSessionModel:(ZFSessionModel *)sessionModel
{
    _sessionModel = sessionModel;
    self.fileNameLabel.text = sessionModel.fileName;
    NSUInteger receivedSize = ZFDownloadLength(sessionModel.url);
    NSString *writtenSize = [NSString stringWithFormat:@"%.2f %@",
                             [sessionModel calculateFileSizeInUnit:(unsigned long long)receivedSize],
                             [sessionModel calculateUnit:(unsigned long long)receivedSize]];
    CGFloat progress = 1.0 * receivedSize / sessionModel.totalLength;
    self.progressLabel.text = [NSString stringWithFormat:@"%@/%@ (%.2f%%)",writtenSize,sessionModel.totalSize,progress*100];
    self.progress.progress = progress;
    self.speedLabel.text = @"已暂停";
}

@end
