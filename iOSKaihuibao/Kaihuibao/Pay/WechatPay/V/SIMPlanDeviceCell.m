//
//  SIMPlanDeviceCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/23.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMPlanDeviceCell.h"
@interface SIMPlanDeviceCell()
@property (nonatomic, strong) UIView *backV;
@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *detail;
@end
@implementation SIMPlanDeviceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addBackViews];
    }return self;
}

- (void)addBackViews {
    _backV = [[UIView alloc] init];
    _backV.backgroundColor = [UIColor whiteColor];
    _backV.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    _backV.layer.borderWidth = 1;
    _backV.layer.cornerRadius = 5;
    _backV.layer.masksToBounds = YES;
    [self.contentView addSubview:_backV];
    
    _titleName = [[UILabel alloc] init];
    _titleName.font = FontRegularName(kWidthS(14));
    _titleName.textColor = BlackTextColor;
    [_backV addSubview:_titleName];
    
    _detail = [[UILabel alloc] init];
    _detail.font = FontRegularName(kWidthS(12));
    _detail.textColor = BlackTextColor;
    _detail.numberOfLines = 0;
    [_backV addSubview:_detail];
    
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.right.mas_equalTo(-30);
    }];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleName);
        make.top.mas_equalTo(_titleName.mas_bottom).offset(15);
        make.bottom.mas_equalTo(-20);
    }];

    [_backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
    }];
    
    
}
- (void)setDetailModel:(SIMNewPlanDetailModel *)detailModel {
    _detailModel = detailModel;
    _titleName.text = _detailModel.name;
    NSString *detailStr = _detailModel.detail;
    NSString *detailRealStr;
    if ([detailStr rangeOfString:@"&"].location != NSNotFound) {
        detailRealStr = [NSString stringWithFormat:@"%@",[detailStr stringByReplacingOccurrencesOfString:@"&" withString:@"\n"]];
    }else {
        detailRealStr = detailStr;
    }
    NSString *fainalDetail;
    if ([detailRealStr rangeOfString:@"num"].location != NSNotFound) {
        fainalDetail = [NSString stringWithFormat:@"%@",[detailRealStr stringByReplacingOccurrencesOfString:@"num" withString:[_detailModel.participant stringValue]]];
    }else {
        fainalDetail = detailRealStr;
    }
    
    _detail.text = fainalDetail;
    [self setLabelSpace:_detail withValue:fainalDetail withFont:FontRegularName(kWidthS(12))];
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = 10; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    //设置字间距 NSKernAttributeName:@1.5f
    NSDictionary *dic = @{NSFontAttributeName:font,
                          NSParagraphStyleAttributeName:paraStyle,
                          };
    
    NSAttributedString *attributeStr = [[NSAttributedString
                                         alloc] initWithString:str
                                        attributes:dic];
    label.attributedText = attributeStr;
}
@end
