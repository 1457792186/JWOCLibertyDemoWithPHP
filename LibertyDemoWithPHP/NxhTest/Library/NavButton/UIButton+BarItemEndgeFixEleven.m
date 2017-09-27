//
//  UIButton+BarItemEndgeFixEleven.m
//  BBSClient
//
//  Created by apple on 2017/9/25.
//  Copyright © 2017年 Alex.Wu. All rights reserved.
//

#import "UIButton+BarItemEndgeFixEleven.h"
#import "UIImage+scale.h"
@implementation UIButton (BarItemEndgeFixEleven)

- (void)fixBarItemWithElevenLeft{
    if (!IOS11_OR_LATER) {
        return;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([self.titleLabel.text isEqualToString:@" 返回"]) {
        self.contentEdgeInsets =UIEdgeInsetsMake(0, -5.f,0, 0);
        self.imageEdgeInsets =UIEdgeInsetsMake(0, -5.f,0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -5.f,0, 0);
    }else{
        self.contentEdgeInsets =UIEdgeInsetsMake(0, -15.f,0, 0);
        self.imageEdgeInsets =UIEdgeInsetsMake(0, -15.f,0, 0);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -15.f,0, 0);
    }
}
- (void)fixBarItemWithElevenRight{
    if (!IOS11_OR_LATER) {
        return;
    }
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentEdgeInsets =UIEdgeInsetsMake(0, 0,0, -20.f);
    self.imageEdgeInsets =UIEdgeInsetsMake(0, 0,0, -20.f);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, 0.f,0, -20.f);
}

@end
