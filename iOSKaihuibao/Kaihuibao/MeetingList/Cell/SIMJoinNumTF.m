//
//  SIMJoinNumTF.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/8/15.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMJoinNumTF.h"

@implementation SIMJoinNumTF

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + bounds.size.width - kWidthS(80), bounds.origin.y + bounds.size.height -30, 16, 16);
}
- (void)paste:(UIMenuController *)menu
{
    NSLog(@"粘贴板的点击事件");
    //    UIPasteboard *board = [UIPasteboard generalPasteboard];
    NSString *string = [UIPasteboard generalPasteboard].string;
    if (string.length > 0) {
        NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
        NSString *cutStr;
        if (tem.length > 10) {
            cutStr = [tem substringToIndex:11];
        }else {
            cutStr = tem;
        }
        _pasteStr = [NSString transTheConfIDWithSpaceToTheThreeApart:cutStr];
        self.text = _pasteStr;
    }
}
@end
