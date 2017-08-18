//
//  UIColor+HexColor.h
//  rhct_ios
//
//  Created by 66 on 15/1/21.
//  Copyright (c) 2015年 rhct. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
/**
 *  @brief  获取UIColor色彩，根据Hex;
 *
 *  @param hexColor 字符串（Hex）;
 *
 *  @return UIColor
 */
+ (UIColor *) colorWithHexString: (NSString *) hexString;
@end
