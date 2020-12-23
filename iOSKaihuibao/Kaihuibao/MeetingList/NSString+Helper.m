//
//  NSString+Helper.m
//  HaveFace
//
//  Created by wangxiaoqi on 15/11/18.
//  Copyright © 2015年 wangxiaoqi. All rights reserved.
//

#import "NSString+Helper.h"
@implementation NSString (Helper)

#pragma mark 是否空字符串
- (BOOL)isEmptyString {
    if (![self isKindOfClass:[NSString class]]) {
        return TRUE;
    }else if (self==nil) {
        return TRUE;
    }else if(!self) {
        // null object
        return TRUE;
    } else if(self==NULL) {
        // null object
        return TRUE;
    } else if([self isEqualToString:@"NULL"]) {
        // null object
        return TRUE;
    }else if([self isEqualToString:@"(null)"]){
        
        return TRUE;
    }else{
        //  使用whitespaceAndNewlineCharacterSet删除周围的空白字符串
        //  然后在判断首位字符串是否为空
        NSString *trimedString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            // empty string
            return TRUE;
        } else {
            // is neither empty nor null
            return FALSE;
        }
    }
}
#pragma mark 过滤非法字符
+ (NSString *)vaiableStringByCharacter:(NSString *)mutStr {
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+ "];
    NSString * hmutStr = [[mutStr componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    
//    NSLog(@"humStr is %@",hmutStr);
    
    return hmutStr;
}

#pragma mark 阿拉伯数字转中文
+ (NSString *)ChineseWithInteger:(NSInteger)integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
    NSString *string = [formatter stringFromNumber:[NSNumber numberWithInt:(int)integer]];
    if ([string isEqualToString:@"七"]) {
        string = @"日";
    }
    return string;
}

#pragma mark 判断是否是手机号
- (BOOL)checkTel {

    NSString *regex = @"^1[3|4|5|6|7|8|9]\\d{9}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}


#pragma mark 判断是否是邮箱
- (BOOL)isValidateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}


#pragma mark 清空字符串中的空白字符
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark 返回沙盒中的文件路径
+ (NSString *)stringWithDocumentsPath:(NSString *)path {
    NSString *file = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return [file stringByAppendingPathComponent:path];
}

#pragma mark 写入系统偏好
- (void)saveToNSDefaultsWithKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setObject:self forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 一串字符在固定宽度下，正常显示所需要的高度 method
+ (CGFloat)autoHeightWithString:(NSString *)string Width:(CGFloat)width Font:(UIFont *)font {
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 10;//行间距
    paragraph.paragraphSpacing = 50;//段落间隔
    paragraph.firstLineHeadIndent = 50;//首行缩近
    //绘制属性（字典）
    NSDictionary * dictA = @{NSFontAttributeName:FontRegularName(20),
                             NSForegroundColorAttributeName:[UIColor greenColor],
                             NSBackgroundColorAttributeName:[UIColor grayColor],
                             NSParagraphStyleAttributeName:paragraph,
                             //                             NSObliquenessAttributeName:@0.5 //斜体
                             //                             NSStrokeColorAttributeName:[UIColor whiteColor],
                             //                             NSStrokeWidthAttributeName:@2,//描边
                             //                             NSKernAttributeName:@20,//字间距
                             //                             NSStrikethroughStyleAttributeName:@2//删除线
                             //                             NSUnderlineStyleAttributeName:@1,//下划线
                             };

    //大小
    CGSize boundRectSize = CGSizeMake(width, MAXFLOAT);
    
    //调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:dictA context:nil].size.height;
    return newFloat;
}

#pragma mark 一串字符在一行中正常显示所需要的宽度 method
+ (CGFloat)autoWidthWithString:(NSString *)string Font:(UIFont *)font {
    
    //大小
    CGSize boundRectSize = CGSizeMake(MAXFLOAT, font.lineHeight);
    //绘制属性（字典）
    NSDictionary *fontDict = @{ NSFontAttributeName: font };
    //调用方法,得到高度
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:fontDict context:nil].size.width;
    return newFloat;
}

+ (NSAttributedString *)makeDeleteLine:(NSString *)string{
    string = [NSString stringWithFormat:@"<html><body style =\"font-size:12px;\"><s><font color=\"#B6B6B6\">%@</font></s></body></html>",string];
    NSAttributedString * attributeString = [[NSAttributedString alloc]initWithData:[string dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    return attributeString;
}

+ (NSString *)StringHaveNextLine:(NSArray *)array{
    NSString *lineString;
//    for (NSInteger index = 0; index < array.count; index ++) {
//        ZJPFriendInfoBrandList *infoBrand = array[index];
//        if (index == 0) {
//            lineString = [NSString stringWithFormat:@"%@",infoBrand.brandCNName];
//        }else{
//            lineString = [NSString stringWithFormat:@"%@\n%@",lineString,infoBrand.brandCNName];
//        }
//        
//    }
    return lineString;
}



- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    
    CGSize maxSize = CGSizeMake(maxW,MAXFLOAT);
    return  [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
}


+(NSString*)getHtmlString:(NSString *)routeName{
    
    NSMutableString *tmpMutable = [NSMutableString stringWithString:routeName];
    NSRange range = [tmpMutable rangeOfString:@"<a "];
    while (range.location != NSNotFound) {
        
        [tmpMutable replaceCharactersInRange:range
                                  withString:@"<a style=\"background:green; color:white; line-height:35px; border-radius:5px; height:50x; display:block;\" "];
        range = [tmpMutable rangeOfString:@"<a " options:NSLiteralSearch range:NSMakeRange(range.location+3, routeName.length-range.location-3)];
        
    }
    
    range = [tmpMutable rangeOfString:@"<img"];
    while (range.location != NSNotFound) {
        
        [tmpMutable replaceCharactersInRange:range
                                  withString:@"<img width=100% "];
        range = [tmpMutable rangeOfString:@"<img" options:NSLiteralSearch range:NSMakeRange(range.location+4, routeName.length-range.location-4)];
        
    }
    //    NSLog(@"%@",tmpMutable);
    return tmpMutable;
}

- (NSString *)formatFloat:(float)f
{
    if (fmodf(f, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmodf(f*10, 1)==0) {//如果有两位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}


#pragma mark 一输入的密码判断类型 暂时是可以纯数字的
-(int)checkIsHaveNumAndLetter {
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:self
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, self.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    if (tNumMatchCount == self.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == self.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == self.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
    
}


// 判断名字首字母的方法
+ (NSString *)firstCharactorWithString:(NSString *)string {
    if (string.length == 0) {
        return @"#";
    }
    if (string.length > 2) {
        NSString *ss = [string substringWithRange:NSMakeRange(string.length-2, 2)];
//        NSLog(@"ssssssss%@",ss);
        return ss;
    }else {
        return string;
    }
}

// 判断名字首字母的方法
+ (NSString *)pinYinFirstCharactorWithString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pinYin = [str capitalizedString];
    return [pinYin substringToIndex:1];
}

+ (NSString *)transTheRepeatType:(NSString *)str {
    if ([str isEqualToString:@"n"]) {
        return SIMLocalizedString(@"MArrangeConfRepeat_Never", nil);// 不重复
    }else if ([str isEqualToString:@"d"]) {
        return SIMLocalizedString(@"MArrangeConfRepeat_Day", nil);// 天重复
    }else if ([str isEqualToString:@"w"]) {
        return SIMLocalizedString(@"MArrangeConfRepeat_Week", nil);// 周重复
    }else if ([str isEqualToString:@"s"]) {
        return SIMLocalizedString(@"MArrangeConfRepeat_TwoWeek", nil);// 两周重复
    }else if ([str isEqualToString:@"m"]) {
        return SIMLocalizedString(@"MArrangeConfRepeat_Month", nil);// 月重复
    }else {
        return @"";
    }
}

+ (NSString *)transTheRepeatTypeToUpload:(NSString *)str {
    if ([str isEqualToString:SIMLocalizedString(@"MArrangeConfRepeat_Never", nil)]) {
        return @"n";// 不重复
    }else if ([str isEqualToString:SIMLocalizedString(@"MArrangeConfRepeat_Day", nil)]) {
        return @"d";// 天重复
    }else if ([str isEqualToString:SIMLocalizedString(@"MArrangeConfRepeat_Week", nil)]) {
        return @"w";// 周重复
    }else if ([str isEqualToString:SIMLocalizedString(@"MArrangeConfRepeat_TwoWeek", nil)]) {
        return @"s";// 两周重复
    }else if ([str isEqualToString:SIMLocalizedString(@"MArrangeConfRepeat_Month", nil)]) {
        return @"m";// 月重复
    }else {
        return @"";
    }
}


+ (NSString *)transTheConfIDToTheThreeApart:(NSString *)confid {
    if (![confid isEmptyString]) {
        NSMutableString *stri = [[NSMutableString alloc] initWithString:confid];
        if (confid.length == 9) {
            [stri insertString:@"-"atIndex:3];
            [stri insertString:@"-"atIndex:7];
        }else if (confid.length == 10) {
            [stri insertString:@"-"atIndex:3];
            [stri insertString:@"-"atIndex:7];
        }else if (confid.length == 11) {
            [stri insertString:@"-"atIndex:3];
            [stri insertString:@"-"atIndex:8];
        }else if (confid.length == 12) {
            [stri insertString:@"-"atIndex:4];
            [stri insertString:@"-"atIndex:9];
        }else {
            
        }
        return stri.copy;
    }else {
        return confid;
    }
}
+ (NSString *)transTheConfIDWithSpaceToTheThreeApart:(NSString *)confid {
    if (![confid isEmptyString]) {
        NSMutableString *stri = [[NSMutableString alloc] initWithString:confid];
        if (confid.length <= 10) {
            if (confid.length < 7) {
                [stri insertString:@" "atIndex:3];
            }else {
                [stri insertString:@" "atIndex:3];
                [stri insertString:@" "atIndex:7];
            }
        }else {
            [stri insertString:@" "atIndex:3];
            [stri insertString:@" "atIndex:8];
        }
        return stri.copy;
    }else {
        return confid;
    }
}

+ (NSString *)iconGetString:(NSString *)iconStr {
    NSString *string;
    if ([iconStr containsString:@"http"]) {
        string = iconStr;
    }else {
        string = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,iconStr];
    }
    return string;
}

// 获取版本号 自己看的版本号
+ (NSString*)getLocalAppVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

// 获取BundleID

+(NSString*)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}

+ (NSString*)ObjectTojsonString:(id)object
{
    NSString *jsonString = [[NSString alloc]init];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSString *jsonTemp = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *jsonResult = [jsonTemp stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *mutStr = [[NSMutableString alloc] initWithString:jsonResult];
    NSString *sss = [NSString stringWithString:mutStr];
    
    return sss;
}


+ (NSString*)formatToString:(NSDictionary*)dictionary key:(NSString*)key {
    if (key&&dictionary&&[dictionary isKindOfClass:[NSDictionary class]]) {
        return [NSString formatToString:[dictionary objectForKey:key]];
    }
    return @"";
}

+ (NSString*)formatToString:(id)string {
    if (string&&![string isKindOfClass:[NSNull class]]) {
        if ([string isKindOfClass:[NSNumber class]]) {
            if (strcmp([string objCType], @encode(float)) == 0)
            {
                return [NSString stringWithFormat:@"%.1f", [string floatValue]];
            }
            else if (strcmp([string objCType], @encode(double)) == 0)
            {
                return [NSString stringWithFormat:@"%.1f", [string floatValue]];
            }else
                return [NSString stringWithFormat:@"%d", [string intValue]];
        }
        return [NSString stringWithFormat:@"%@",string];
    }
    return @"";
}

+ (NSString *)weekdayStringFromDate:(NSString *)dateSting {
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *inputDate = [formatter dateFromString:dateSting];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"日", @"一", @"二", @"三", @"四", @"五", @"六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)dayStringFromDate:(NSString *)dateSting{
    // 创建 格式 对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置 日期 格式 可以根据自己的需求 随时调整， 否则计算的结果可能为 nil
    formatter.dateFormat = @"yyyy-MM-dd";
    // 将字符串日期 转换为 NSDate 类型
    NSDate *inputDate = [formatter dateFromString:dateSting];
    NSString *dayString = [NSString dateTranformTimeStrFromDate:inputDate withformat:@"dd"];
    return dayString;
}


@end
