//
//  BBSDownloadedTableViewCell.m
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSDownloadedTableViewCell.h"

@implementation BBSDownloadedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSessionModel:(ZFSessionModel *)sessionModel
{
    _sessionModel = sessionModel;
    self.titleLabel.text = sessionModel.fileName;
    self.sizeLabel.text = sessionModel.totalSize;
    
}

@end
