//
//  SIMBaseInputTableViewCell.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseInputTableViewCell.h"

@implementation SIMBaseInputTableViewCell
{
    UITextField* _textfield;
}
-(instancetype)init
{
    if(self = [super init])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 分割线顶格
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        _textfield = [[UITextField alloc] initWithFrame:self.contentView.bounds];
        _textfield.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textfield];
        _textfield.textColor = BlackTextColor;
        
//        [_textfield setValue:GrayPromptTextColor forKeyPath:@"attributedPlaceholder"];
//        [_textfield setValue:FontRegularName(12) forKeyPath:@"attributedPlaceholder"];
        [_textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
-(UITextField *)textfield
{
    return _textfield;
}
-(instancetype)initTwoTextF
{
    if(self = [self init]){
        [_textfield removeFromSuperview];
        _joinTextfield = [[SIMJoinNumTF alloc] initWithFrame:self.contentView.bounds];
        _joinTextfield.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_joinTextfield];
        _joinTextfield.textColor = BlackTextColor;
        
//        [_joinTextfield setValue:GrayPromptTextColor forKeyPath:@"attributedPlaceholder"];
//        [_joinTextfield setValue:FontMediumName(16) forKeyPath:@"attributedPlaceholder"];
        [_joinTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(20);
            make.right.mas_equalTo(-20);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}
- (void)setPlaceHolderTwoStr:(NSString *)placeHolderTwoStr {
    _placeHolderTwoStr = placeHolderTwoStr;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_placeHolderTwoStr attributes:
    @{NSForegroundColorAttributeName:GrayPromptTextColor,
                 NSFontAttributeName:FontRegularName(16)
         }];
    _joinTextfield.attributedPlaceholder = attrString;
}
- (void)setPlaceHolderStr:(NSString *)placeHolderStr {
    _placeHolderStr = placeHolderStr;
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:_placeHolderStr attributes:
    @{NSForegroundColorAttributeName:GrayPromptTextColor,
//                 NSFontAttributeName:FontRegularName(12)
         }];
    _textfield.attributedPlaceholder = attrString;
}

@end
