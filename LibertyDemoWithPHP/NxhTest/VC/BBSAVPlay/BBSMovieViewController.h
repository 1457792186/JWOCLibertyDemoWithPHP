//
//  MovieViewController.h
//  LKPlayer
//
//  Created by ck on 16/6/24.
//  Copyright © 2016年 LK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PanDirection){
    panHorizontalMove,
    panVerticalMove
};

@interface BBSMovieViewController : UIViewController

@property (nonatomic,strong)NSString * url;

@end
