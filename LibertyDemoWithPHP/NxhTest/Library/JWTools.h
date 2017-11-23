//
//  JWTools.h
//  WeiJiang
//
//  Created by WeiJiang on 14/3/21.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface JWTools : NSObject

/**
 *  实现数组的排序功能
 *
 *  @param arr 将要被排序的数组
 *
 *  @param des 是升序还是降序，如果是降序为YES，反之为升序
 *
 *  @return 返回排序之后的数组
 */
+ (id)sortWithArray:(NSArray *)arr des:(BOOL)des;


#pragma mark - UILabel

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelHeightWithLabel:(UILabel *)label;

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param text 文字
 *  @param font 字体大小
 *  @param size 控件最大大小
 *
 *  @return 文字所占的区域大小
 */
+ (CGSize)sizeForText:(NSString *)text withFont:(UIFont *)font withSize:(CGSize)size;

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelHeightWithLabel:(UILabel *)label withWidth:(CGFloat)width;

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelWidthWithLabel:(UILabel *)label;

/**
 *  通过文字来计算文字所占的区域大小
 *
 *  @param label Label
 *
 *  @return 文字所占的区域大小
 */
+ (CGFloat)labelWidthWithLabel:(UILabel *)label withHeight:(CGFloat)height;

#pragma mark - FileRead
/**
 *  根据文件名获取本地Json文件
 *
 *  @param fileName 文件名
 *
 *  @return Json字典
 */
+ (NSDictionary *)jsonWithFileName:(NSString *)fileName;

#pragma mark - FilePath

/**
 *  获取文件路径
 *
 *  @param fileName 文件名
 *  @param type     文件类型
 *
 *  @return 文件路径
 */
+ (NSString *)filePathWithFileName:(NSString *)fileName ofType:(NSString *)type;
/**
 *  获取文件路径
 *
 *  @param fileName 文件名
 *
 *  @return 文件路径
 */
+ (NSString *)filePathWithFileName:(NSString *)fileName;
/**
 *  通过文件名获取文本文件内容
 *
 *  @param fileName 文件名
 *
 *  @return 文件
 */
+ (NSString *)fileWithFileName:(NSString *)fileName;
/**
 *  通过文件名获取文件内容
 *
 *  @param fileName Array文件名
 *
 *  @return Array文件
 */
+ (NSArray *)contentArrayForFileName:(NSString *)fileName;
/**
 *  通过文件名获取文件内容
 *
 *  @param fileName Dictionary文件名
 *
 *  @return Dictionary文件
 */
+ (NSDictionary *)contentDictForFileName:(NSString *)fileName;

/**
 *  保存图片到本地
 *
 *  @param image 图片
 *
 *  @return 存储地址
 */
+ (NSString *)saveJImage:(UIImage *)image;
/**
 *  计算文件大小
 *
 *  @param path 文件路径
 *
 *  @return 文件大小
 */
+ (CGFloat)fileSizeAtPath:(NSString *)path;
/**
 *  清除路径文件
 *
 *  @param path 文件路径
 */
+ (void)clearCache:(NSString *)path;
/**
 *  清除UIWebView的缓存
 *
 */
+ (void)clearWebViewCache;

#pragma mark - NSDate
/**
 *  传一个日期字符串,返回年月日
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateWithYearMonthDayStr:(NSString *)dateStr;
/**
 *  传一个日期字符串，判断是否是昨天，或者是今天的日期
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateStr:(NSString *)dateStr;

/**
 *  传一个日期字符串，判断是否是昨天，或者是多少小时、分钟前
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateWithStr:(NSString *)dateStr;

/**
 *  传一个日期字符串，判断是否是今天(无年)
 *
 *  @param dateStr 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateWithOutYearStr:(NSString *)dateStr;

/**
 *  传一个日期字符串，判断是否是今天(无年)
 *
 *  @param date 日期字符串
 *
 *  @return 修改完的日期字符串
 */
+ (NSString *)dateWithOutYearDate:(NSDate *)date;

/**
 *  *  年月日转数字
 *
 *  @param dateStr 年月日字符串
 *
 *  @return 年月日数字
 */
+ (NSString *)dateTimeWithStr:(NSString *)dateStr;

/**
 *  今日年月日
 *  @return 今日年月日
 */
+ (NSString *)dateWithTodayYearMonthDayStr;

/**
 *  今日年月日数字
 *  @return 今日年月日数字
 */
+ (NSString *)dateWithTodayYearMonthDayNumberStr;

/**
 *  第一个时间是否小于第二个时间
 *
 *  @param firstDateStr   第一个时间
 *  @param compareDateStr 第二个时间
 *
 *  @return 第一个时间是否小于第二个时间
 */
+ (BOOL)firstDate:(NSString *)firstDateStr withCompareDate:(NSString *)compareDateStr;

#pragma mark - Json
/**
 *  单个数组组成Json文件
 *
 *  @param key 接口关键字
 *  @param arr 接口数组
 *
 *  @return json字符串
 */
+ (NSString *)jsonStrWithKey:(NSString *)key withArr:(NSArray *)arr;
/**
 *  单个数组组成Json文件
 *  @param arr 接口数组
 *
 *  @return json字符串
 */
+ (NSString *)jsonStrWithArr:(NSArray *)arr;

/**
 *  json格式字符串转字典
 *  @param jsonString json格式字符串
 *
 *  @return 字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
/**
 *  字典转json格式字符串
 *
 *  @param dic 字典
 *
 *  @return json格式字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  字符串组成UTF8文件
 *
 *  @param str 接口关键字
 *
 *  @return json字符串
 */
+ (NSString *)UTF8WithStringJW:(NSString *)str;
/**
 *  字符串解析UTF8
 *
 *  @param UTF8String UTF8
 *
 *  @return 字符串
 */
+ (NSString *)stringWithUTF8JW:(NSString *)UTF8String;

#pragma mark - RegEx
/**
 *  判断用户名，2－16位(字母大小写，数字，中文)
 *
 *  @param password 用户名
 *
 *  @return 用户名是否正确
 */
+ (BOOL)isRightUserName:(NSString *)content;
/**
 *  密码长度至少6
 *
 *  @param password 密码
 *
 *  @return 密码长度是否大于等于6
 */
+ (BOOL)isRightPassWordWithStr:(NSString *)password;
/**
 *  纯数字验证码
 *
 *  @param comfireCode 验证码
 *
 *  @return 验证码纯数字
 */
+ (BOOL)isComfireCodeWithStr:(NSString *)comfireCode;
/**
 *  纯数字
 *
 *  @param numberStr Str
 *
 *  @return 是否是纯数字
 */
+ (BOOL)isNumberWithStr:(NSString *)numberStr;
/**
 *  两位小数
 *
 *  @param numberStr numberStr
 *
 *  @return 是否是两位小数
 */
+ (BOOL)isValidateMoney:(NSString *)numberStr;
/**
 *  邮箱验证
 *
 *  @param email 邮箱
 *
 *  @return 是否是邮箱
 */
+ (BOOL)isEmailWithStr:(NSString *)email;
/**
 *  验证手机号
 *
 *  @param phoneNumber 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)isPhoneIDWithStr:(NSString *)phoneNumber;
/**
 *  验证国内手机号
 *
 *  @param telNumber 手机号
 *
 *  @return 是否是手机号
 */
+ (BOOL)checkTelNumber:(NSString*)telNumber;

/**
 *  判断是否含表情字符串
 *
 *  @param string 字符串
 *
 *  @return 是否含有
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

#pragma mark - NSString
/**
 *  数字时间转格式时间
 *
 *  @param number 数字时间,如:123456789
 *
 *  @return 格式时间,如:2016-01-01
 */
+ (NSString *)stringNumberTurnToDateWithNumber:(NSString *)number;

/**
 *  获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
 *
 *  @param str 传入汉字字符串
 *
 *  @return 获取首字母
 */
+ (NSString *)stringWithFirstCharactor:(NSString *)str;

/**
 *  32进制转10进制
 *
 *  @param str 32进制str
 *
 *  @return 10进制
 */
+ (NSString *)stringWithNumberThirtyTwoBase:(NSString *)str;

/**
 *  10进制转32进制
 *
 *  @param numberStr 10进制str
 *
 *  @return 32进制
 */
+ (NSString *)stringThirtyTwoWithNumberTenBase:(NSString *)numberStr;

/**
 *  复制字符串到剪贴板
 *
 *  @param str        复制字符串
 */
+ (void)strWithCopy:(NSString *)str;

#pragma mark - HUD
/**
 *  提示闪烁
 *
 *  @param showHud 显示文字
 *
 */
+ (void)showHUDWithStr:(NSString *)showHud;

#pragma mark - UIControl Border
/**
 *  虚线边框
 *
 *  @param size        虚线边框视图的大小
 *  @param color       边框颜色
 *  @param borderWidth 边框粗细
 *  @param cornerRadius 边框圆角
 *
 *  @return 虚线边框
 */
+ (UIImage*)imageWithSize:(CGSize)size borderColor:(UIColor *)color borderWidth:(CGFloat)borderWidth withCornerRadius:(CGFloat)cornerRadius;

/**
 *  UIControl设置圆角
 *
 *  @param sender UIControl
 */
+ (void)cornerRadiusUISet:(UIControl *)sender;

#pragma mark - QR Code 二维码
/**
 *  创建二维码
 *  @param QRStr 二维码链接
 */
+ (UIImage *)makeQRCodeWithStr:(NSString *)QRStr;

#pragma mark - 图片转Str
/**
 *  图片转Str
 *
 *  @param image 图片
 *
 *  @return 图片转Str
 */
+ (NSString *)imageToStr:(UIImage *)image;

#pragma mark - 图片大小
/**
 *  图片适应屏幕大小
 *
 *  @param image  图片
 *  @param height 适应高度
 *  @param width  适应宽度
 *
 *  @return 图片大小
 */
+ (CGSize)getScaleImageSizeWithImageView:(UIImage *)image withHeight:(CGFloat)height withWidth:(CGFloat)width;

#pragma mark - 图片压缩
/**
 *  图片压缩到指定大小
 *
 *  @param image      图片
 *  @param targetSize 大小
 *
 *  @return 压缩后图片
 */
+ (UIImage*)imageByScalingAndCropping:(UIImage *)image ForSize:(CGSize)targetSize;


/**
 *  微信分享图片32K限制
 *
 *  @param image 图片URL
 *
 *  @return 压缩后图片
 */
+ (UIImage *)zipImageWithImage:(UIImage *)image;

#pragma mark - 图片滤镜
/**
 *  图片加滤镜
 *
 *  @param image      修改图片
 *  @param filterName 滤镜效果名称
 *
 *  @return 修改后图片
 */
+ (UIImage*)filteredImage:(UIImage*)image withFilterName:(NSString*)filterName;

/**
 *  滤镜效果数组
 *
 *  @return 滤镜效果数组
 */
+ (NSArray *)imageFilterArr;

/**
 *  图片换色
 *  @param img      修改图片
 *  @param imgColor   图片颜色
 *
 *  @return 获取UUDID
 */
+ (UIImage *)imageWithColor:(UIColor *)imgColor withIMG:(UIImage *)img;

#pragma mark - UUID
/**
 *  获取UUDID
 *
 *  @return 获取UUDID
 */
+ (NSString *)getUUID;

#pragma mark - HTML
/**
 *  获取html,替换html换行符<br />为\n
 *
 *  @return 替换后字符串
 */
+ (NSString *)strRemoveHTML:(NSString *)html;

@end
