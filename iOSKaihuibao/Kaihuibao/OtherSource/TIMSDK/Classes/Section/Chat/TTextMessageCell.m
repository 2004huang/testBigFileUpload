//
//  TTextMessageCell.m
//  UIKit
//
//  Created by kennethmiao on 2018/9/17.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TTextMessageCell.h"
#import "TFaceView.h"
#import "TFaceCell.h"
#import "THeader.h"
#import "TUIKit.h"
#import "THelper.h"

@implementation TTextMessageCellData
@end

@implementation TTextMessageCell

- (CGSize)getContainerSize:(TTextMessageCellData *)data
{
    _textView.attributedText = [self formatMessageString:data.content isSelf:data.isSelf];
    CGSize contentSize = [_textView sizeThatFits:CGSizeMake(TTextMessageCell_Text_Width_Max, MAXFLOAT)];
    return CGSizeMake(contentSize.width + 2 * TTextMessageCell_Margin, contentSize.height + 2 * TTextMessageCell_Margin);
}

- (void)setupViews
{
    [super setupViews];
    _bubble = [[UIImageView alloc] init];
    _bubble.userInteractionEnabled = YES;
    [super.container addSubview:_bubble];
    
//    _content = [[UILabel alloc] init];
//    _content.font = [UIFont systemFontOfSize:15];
//    _content.numberOfLines = 0;
//    [_bubble addSubview:_content];
    
    _textView = [[UITextView alloc] init];
    _textView.editable = NO;
    _textView.font = [UIFont systemFontOfSize:25];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    _textView.delegate = self;
    _textView.textContainerInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);//控制距离上下左右的边距
    [_bubble addSubview:_textView];
}


- (void)setData:(TTextMessageCellData *)data;
{
    //set data
    [super setData:data];
    _textView.attributedText = [self formatMessageString:data.content isSelf:data.isSelf];
    //update layout
    _bubble.frame = super.container.bounds;
    _textView.frame = CGRectMake(TTextMessageCell_Margin, TTextMessageCell_Margin, _bubble.frame.size.width - 2 * TTextMessageCell_Margin, _bubble.frame.size.height - 2 * TTextMessageCell_Margin);
    
    if(data.isSelf){
        _bubble.image = [[[[TUIKit sharedInstance] getConfig] getResourceFromCache:TUIKitResource(@"sender_text_normal")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
        _bubble.highlightedImage = [[[[TUIKit sharedInstance] getConfig] getResourceFromCache:TUIKitResource(@"sender_text_pressed")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
//        _content.textColor = [UIColor whiteColor];
    }
    else{
        _bubble.image = [[[[TUIKit sharedInstance] getConfig] getResourceFromCache:TUIKitResource(@"receiver_text_normal")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
        _bubble.highlightedImage = [[[[TUIKit sharedInstance] getConfig] getResourceFromCache:TUIKitResource(@"receiver_text_pressed")] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{18,25,17,25}") resizingMode:UIImageResizingModeStretch];
//        _content.textColor = [UIColor blackColor];
    }
}

- (NSAttributedString *)formatMessageString:(NSString *)text isSelf:(BOOL)isSelf
{
    //先判断text是否存在
    if (text == nil || text.length == 0) {
        NSLog(@"TTextMessageCell formatMessageString failed , current text is nil");
        return [[NSMutableAttributedString alloc] initWithString:@""];
    }
    //1、创建一个可变的属性字符串
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    // 根据不同发送者双方设置不同的textview的字体
    if(isSelf){
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    }
    else{
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, text.length)];
        [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, text.length)];
    }
    
    if([[TUIKit sharedInstance] getConfig].faceGroups.count == 0){
        return attributeString;
    }
    
    //2、通过正则表达式来匹配字符串
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        return attributeString;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    
    TFaceGroup *group = [[TUIKit sharedInstance] getConfig].faceGroups[0];
    
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        
        for (TFaceCellData *face in group.faces) {
            if ([face.name isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                //新建文字附件来存放我们的图片,iOS7才新加的对象
                NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
                //给附件添加图片
                textAttachment.image = [[[TUIKit sharedInstance] getConfig] getFaceFromCache:face.path];
                //调整一下图片的位置,如果你的图片偏上或者偏下，调整一下bounds的y值即可
                textAttachment.bounds = CGRectMake(0, -4, 20, 20);
                //把附件转换成可变字符串，用于替换掉源字符串中的表情文字
                NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:imageStr forKey:@"image"];
                
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
                
            }
        }
    }
    
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)imageArray.count -1; i >= 0; i--) {
        NSRange range;
        if (range.length > 0  ||  range.location != NSNotFound) {
            [imageArray[i][@"range"] getValue:&range];
            //进行替换
            [attributeString replaceCharactersInRange:range withAttributedString:imageArray[i][@"image"]];
        }

    }
    
    
    
    // 正则匹配超链接
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    _urlArr = [NSMutableArray array];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        //获取数组元素中得到range
        NSRange range = [match range];
        NSString* substringForMatch = [text substringWithRange:match.range];
        NSLog(@"substringForMatch %@",substringForMatch);
        NSLog(@"substringForMatchloaction %ld %ld",range.length,range.location);
        NSMutableDictionary *urlDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [urlDic setObject:substringForMatch forKey:@"urlStr"];
        [urlDic setObject:[NSValue valueWithRange:range] forKey:@"urlRange"];
        //把字典存入数组中
        [_urlArr addObject:urlDic];
    }
    //4、从后往前替换，否则会引起位置问题
    for (int i = (int)_urlArr.count -1; i >= 0; i--) {
        NSRange range;
        [_urlArr[i][@"urlRange"] getValue:&range];
        //进行替换
        //添加下划线
        if(isSelf){
            [attributeString addAttribute:NSUnderlineStyleAttributeName value:
             [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range]; // 下划线类型
            [attributeString addAttribute:NSUnderlineColorAttributeName value:
             [UIColor whiteColor] range:range]; // 下划线颜色
            [attributeString addAttributes:@{
                                     NSLinkAttributeName:_urlArr[i][@"urlStr"]
                                     }
                             range:range];
            _textView.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]}; // 修改可点击文字的颜色
        }
        else{
            [attributeString addAttribute:NSUnderlineStyleAttributeName value:
             [NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range]; // 下划线类型
            [attributeString addAttribute:NSUnderlineColorAttributeName value:
             BlueButtonColor range:range]; // 下划线颜色
            [attributeString addAttributes:@{
                                     NSLinkAttributeName:_urlArr[i][@"urlStr"]
                                     }
                             range:range];
            _textView.linkTextAttributes = @{NSForegroundColorAttributeName:BlueButtonColor}; // 修改可点击文字的颜色
        }
        
    }
    
    return attributeString;
}
#pragma mark -- UITextViewDelegate
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    for (int i = (int)_urlArr.count -1; i >= 0; i--) {
        NSRange range;
        NSLog(@"urlArr.count %ld",_urlArr.count);
        [_urlArr[i][@"urlRange"] getValue:&range];
        
        if (characterRange.location == range.location) {
            // 打开链接用浏览器
            NSLog(@"打开链接用浏览器");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_urlArr[i][@"urlStr"]]];
        }
    }
    
    return YES;
}
@end
