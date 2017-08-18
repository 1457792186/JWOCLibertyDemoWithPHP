//
//  BBSDownloadViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSDownloadViewController.h"
#import "BBSDownloadTableViewCell.h"
#import "BBSDownloadedTableViewCell.h"
#import "BBSDownloadingTableViewCell.h"

#import "ZFDownloadManager.h"

#define DOWNLOAD_CELL         @"BBSDownloadTableViewCell"
#define DOWNLOADING_CELL      @"BBSDownloadingTableViewCell"
#define DOWNLOADED_CELL       @"BBSDownloadedTableViewCell"

@interface BBSDownloadViewController ()<UITableViewDelegate,UITableViewDataSource,ZFDownloadDelegate>

@property (strong,nonatomic)NSMutableArray * downLoadArr;
@property (strong,nonatomic)NSMutableArray * dataArr;
@property (weak, nonatomic) IBOutlet UITableView *downloadTableView;

@end

@implementation BBSDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downLoadArr = [NSMutableArray array];
    _dataArr = [NSMutableArray array];
    
    [_downLoadArr addObjectsFromArray:@[
                                        @"http://www.plu.cn/d/file/lol/news/guofu/2013-03-16/0fa26862dd53c8eb6768d0953fe2ec7a.jpg",
                                        @"http://ossweb-img.qq.com/upload/webplat/info/lol/201303/13637724684962.jpg",
                                        @"http://i2.static.olcdn.com/cms/201402/25/MzEz1393306954506_500.JPG",
                                        @"http://s.wasu.tv/mrms/pic/20131224/201312241107336705dc3fdbd.jpg",
                                        @"http://s.wasu.tv/mams/pic/201403/19/19/20140319194939276f1671fea.jpg",
                                        @"http://ol.15w.com/uploads/allimg/130325/1I04M448-1.jpg",
                                        @"http://dldir1.qq.com/qqfile/QQforMac/QQ_V4.2.4.dmg",
                                        @"http://baobab.wdjcdn.com/1456117847747a_x264.mp4",
                                        @"http://baobab.wdjcdn.com/14525705791193.mp4",
                                        @"http://baobab.wdjcdn.com/1456459181808howtoloseweight_x264.mp4",
                                        @"http://baobab.wdjcdn.com/1455968234865481297704.mp4"
                                        ]
     ];
    [self initData];
    
    [_downloadTableView registerNib:[UINib nibWithNibName:DOWNLOAD_CELL bundle:nil] forCellReuseIdentifier:DOWNLOAD_CELL];
    [_downloadTableView registerNib:[UINib nibWithNibName:DOWNLOADING_CELL bundle:nil] forCellReuseIdentifier:DOWNLOADING_CELL];
    [_downloadTableView registerNib:[UINib nibWithNibName:DOWNLOADED_CELL bundle:nil] forCellReuseIdentifier:DOWNLOADED_CELL];
    
    [ZFDownloadManager sharedInstance].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 更新数据源
    [self initData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initData{
    NSMutableArray *downladed = [ZFDownloadManager sharedInstance].downloadedArray;
    NSMutableArray *downloading = [ZFDownloadManager sharedInstance].downloadingArray;
    _dataArr = [NSMutableArray array];
    [_dataArr addObject:downladed];
    [_dataArr addObject:downloading];
    
    [self.downloadTableView reloadData];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * headerView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44.f)];
    headerView.textColor = [UIColor redColor];
    headerView.text = @[@"下载",@"已下载",@"下载中"][section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        //下载文件并移除
        NSString *urlString = _downLoadArr[indexPath.row];
        [[ZFDownloadManager sharedInstance] download:urlString progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([_downLoadArr containsObject:urlString]) {
                    [_downLoadArr removeObjectAtIndex:indexPath.row];
//                    [_downloadTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self initData];
                    [_downloadTableView reloadData];
                }
            });
        } state:^(DownloadState state) {}];
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section==0?_downLoadArr.count:[_dataArr[section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        下载
        BBSDownloadTableViewCell * downloadCell = [tableView dequeueReusableCellWithIdentifier:DOWNLOAD_CELL forIndexPath:indexPath];
        downloadCell.titleLabel.text = _downLoadArr[indexPath.row];
        return downloadCell;
    }else if (indexPath.section == 1) {
//        已下载
        BBSDownloadedTableViewCell * downloadedCell = [tableView dequeueReusableCellWithIdentifier:DOWNLOADED_CELL forIndexPath:indexPath];
        downloadedCell.sessionModel = self.dataArr[indexPath.section-1][indexPath.row];
        return downloadedCell;
    }else{
//        下载中
        BBSDownloadingTableViewCell * downloadingCell = [tableView dequeueReusableCellWithIdentifier:DOWNLOADING_CELL forIndexPath:indexPath];
        ZFSessionModel * downloadObject = self.dataArr[indexPath.section-1][indexPath.row];
        downloadingCell.sessionModel = downloadObject;
        
        downloadingCell.downloadBlock = ^(UIButton *sender) {
            [[ZFDownloadManager sharedInstance] download:downloadObject.url progress:^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {} state:^(DownloadState state) {}];
        };
        return downloadingCell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section>0?YES:NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *downloadArray = _dataArr[indexPath.section-1];
    ZFSessionModel * downloadObject = downloadArray[indexPath.row];
    // 根据url删除该条数据
    [[ZFDownloadManager sharedInstance] deleteFile:downloadObject.url];
    [downloadArray removeObject:downloadObject];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
}

#pragma mark - ZFDownloadDelegate

- (void)downloadResponse:(ZFSessionModel *)sessionModel{
    if (self.dataArr) {
        // 取到对应的cell上的model
        NSArray *downloadings = self.dataArr[1];
        if ([downloadings containsObject:sessionModel]) {
            
            NSInteger index = [downloadings indexOfObject:sessionModel];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:2];
            __block BBSDownloadingTableViewCell *cell = [self.downloadTableView cellForRowAtIndexPath:indexPath];
            WEAK_SELF;
            sessionModel.progressBlock = ^(CGFloat progress, NSString *speed, NSString *remainingTime, NSString *writtenSize, NSString *totalSize) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.progressLabel.text   = [NSString stringWithFormat:@"%@/%@ (%.2f%%)",writtenSize,totalSize,progress*100];
                    cell.speedLabel.text      = speed;
                    cell.progress.progress    = progress;
                    cell.downloadBtn.selected = YES;
                });
            };
            
            sessionModel.stateBlock = ^(DownloadState state){
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 更新数据源
                    if (state == DownloadStateCompleted) {
                        [weakSelf initData];
                        cell.downloadBtn.selected = NO;
                    }
                    // 暂停
                    if (state == DownloadStateSuspended) {
                        cell.speedLabel.text = @"已暂停";
                        cell.downloadBtn.selected = NO;
                    }
                });
            };
        }
    }
}



@end
