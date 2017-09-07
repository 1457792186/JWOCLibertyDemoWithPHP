//
//  BBSDownloadedTableViewCell.h
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFSessionModel.h"

@interface BBSDownloadedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (nonatomic, strong) ZFSessionModel *sessionModel;

@end
