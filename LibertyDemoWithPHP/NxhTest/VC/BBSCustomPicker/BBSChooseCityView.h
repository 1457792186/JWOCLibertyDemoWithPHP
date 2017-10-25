//
//  YWChooseSexView.h
//  YuWa
//
//  Created by 蒋威 on 2016/11/14.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSChooseCityView : UIView
@property(nonatomic,strong)UIPickerView*pickerView;
@property(nonatomic,copy)void(^touchConfirmBlock)(NSDictionary * valueDic);
@property(nonatomic,copy)void(^touchCancelBlock)();

- (BBSChooseCityView*)initWithCustomeHeight:(CGFloat)height;
@end
