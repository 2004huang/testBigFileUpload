//
//  NSString+Helper.h
//  HaveFace
//
//  Created by wangxiaoqi on 15/11/18.
//  Copyright © 2015年 wangxiaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <Foundation/Foundation.h>


@interface NSString (Helper)

/**
 *  判断是否为正确的邮箱
 *
 *  @return 返回YES为正确的邮箱，NO为不是邮箱
 */
- (BOOL)isValidateEmail;

/**
 *  阿拉伯数字转中文
 */
+ (NSString *)ChineseWithInteger:(NSInteger)integer;

/**
 *  判断是否为正确的手机号
 *
 *  @return 返回YES为手机号，NO为不是手机号
 */
- (BOOL)checkTel;

/**
 *  清空字符串中的空白字符
 *
 *  @return 清空空白字符串之后的字符串
 */
- (NSString *)trimString;

/**
 *  是否空字符串
 *
 *  @return 如果字符串为nil或者长度为0返回YES
 */
- (BOOL)isEmptyString;

/**
 *  返回沙盒中的文件路径
 *
 *  @return 返回当前字符串对应在沙盒中的完整文件路径
 */
+ (NSString *)stringWithDocumentsPath:(NSString *)path;
/**
 *  过滤非法字符
 *
 *  @return 返回当前字符串对应在沙盒中的完整文件路径
 */
+ (NSString *)vaiableStringByCharacter:(NSString *)mutStr;


/**
 *  根据字体计算最大宽度
 *
 *  @param font 字体的大小
 *  @param maxW 最大的宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;


- (CGSize)sizeWithFont:(UIFont *)font;


/**
 *  写入系统偏好
 *
 *  @param key 写入键值
 */
- (void)saveToNSDefaultsWithKey:(NSString *)key;


/**
 *  一串字符在固定宽度下，正常显示所需要的高度
 *
 *  @param string：文本内容
 *  @param width：每一行的宽度
 *  @param 字体大小
 */
+ (CGFloat)autoHeightWithString:(NSString *)string
                        Width:(CGFloat)width
                         Font:(UIFont *)font;

/**
 *  一串字符在一行中正常显示所需要的宽度
 *
 *  @param string：文本内容
 *  @param 字体大小
 */
+ (CGFloat)autoWidthWithString:(NSString *)string
                         Font:(UIFont *)font;
//下划线文字
+ (NSAttributedString *)makeDeleteLine:(NSString *)string;

//返回带换行符的字符串
+ (NSString *)StringHaveNextLine:(NSArray *)array;


/**
 *  调整html返回的字符串的内容格式
 */
+(NSString*)getHtmlString:(NSString *)routeName;



/**
 判断float型小数点后0位1位还是2位 展示字符串 如果是0位不显示小数点和补位 如果是1位补位1位 2位即补位2位

 @param f 传入后台拿到的金额
 @return 转化为格式化后的字符串（如果是0位不显示小数点和补位 如果是1位补位1位 2位即补位2位）
 */
- (NSString *)formatFloat:(float)f;



/**
 输入的密码字符串判断类型  暂时是可以纯数字的
 
 @return 返回输入的类型 详见方法实现
 */
-(int)checkIsHaveNumAndLetter;

/**
 判断名字首字母的方法
 
 @return 返回输入的类型 详见方法实现
 */
+ (NSString *)firstCharactorWithString:(NSString *)string;
/**
 判断名字首字母的方法 按照拼音
 
 @return 返回输入的类型 详见方法实现
 */
+ (NSString *)pinYinFirstCharactorWithString:(NSString *)string;



/**
 重复会议需要转变的字符串
 
 @param str 传入的字符串格式  “n” “w”...
 @return 返回的格式为 “从不”“两周”。。。
 */
+ (NSString *)transTheRepeatType:(NSString *)str;


/**
 重复会议需要转变的字符串
 
 @param str 传入的字符串格式“从不”“两周”。。。
 @return 返回的格式为 “n” “w”...
 */
+ (NSString *)transTheRepeatTypeToUpload:(NSString *)str;



/**
 将会议号格式转化为我们工程里要求的显示格式 为“-”分割三部分样式

 @param confid 当前要转变的会议号
 @return 返回格式化好的会议号 带“-”短杠的三部分格式
 */
+ (NSString *)transTheConfIDToTheThreeApart:(NSString *)confid;

/**
 将会议号格式转化为我们工程里要求的显示格式 为“ ”(空格)分割三部分样式
 
 @param confid 当前要转变的会议号
 @return 返回格式化好的会议号 带“-”短杠的三部分格式
 */
+ (NSString *)transTheConfIDWithSpaceToTheThreeApart:(NSString *)confid;

+ (NSString *)iconGetString:(NSString *)iconStr;

// 获取版本号 自己看的版本号
+ (NSString*)getLocalAppVersion;

// 获取BundleID
+(NSString*)getBundleID;

+ (NSString*)ObjectTojsonString:(id)object;


/// 日期xxxx-xx-xx 转换为 汉字一 二 三...日
/// @param dateSting 日期
+ (NSString *)weekdayStringFromDate:(NSString *)dateSting;

+ (NSString *)dayStringFromDate:(NSString *)dateSting;

/// 字符串过滤不为空
/// @param string 字符串
+ (NSString*)formatToString:(id)string;

/// 字典解析
/// @param dictionary dic数据
/// @param key key字符串
+ (NSString*)formatToString:(NSDictionary*)dictionary key:(NSString*)key;

@end
