//
//  SIMOrderChooseCountCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/11.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMOrderChooseCountCell.h"

@interface SIMOrderChooseCountCell()

@property (strong,nonatomic) UILabel *label;
@property (strong,nonatomic) UIView *view;

@end

@implementation SIMOrderChooseCountCell

- (instancetype)initWithViewController:(UIViewController<SIMOptionViewDelegate> *)viewController {
    if (self=[super init]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _view = [[UIView alloc] init];
        _view.backgroundColor = ZJYColorHex(@"#f7f7f7");
        [self.contentView addSubview:_view];
        [_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        
        _optionView = [[SIMOptionView alloc] init];
        _optionView.titleFontSize = 14;
        _optionView.delegate = viewController;
        [self.contentView addSubview:_optionView];
        
        _textF = [[UITextField alloc] init];
        _textF.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
        _textF.layer.borderWidth = 1;
        _textF.layer.cornerRadius = 5;
        _textF.layer.masksToBounds = YES;
        _textF.font = FontRegularName(14);
        _textF.textAlignment = NSTextAlignmentRight;
        _textF.keyboardType = UIKeyboardTypeNumberPad;
        [self.contentView addSubview:_textF];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _textF.rightView = rightView;
        _textF.rightViewMode = UITextFieldViewModeAlways;
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(14);
        [self.contentView addSubview:_label];
       
    }return self;
}
- (void)setDetailModel:(SIMNewPlanDetailModel *)detailModel {
    _detailModel = detailModel;
    if ([_detailModel.isNowSer isEqualToString:@"nowS"]) {
        self.userInteractionEnabled = NO;
    }else {
        self.userInteractionEnabled = YES;
    }

    if ([_detailModel.serviceType intValue] == 3) {
        [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_view.mas_bottom).offset(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(35);
            make.left.mas_equalTo(15);
        }];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_optionView);
            make.left.mas_equalTo(_optionView.mas_right).offset(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(-20);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_textF);
            make.left.mas_equalTo(_textF.mas_right).offset(10);
        }];
        _label.text = _detailModel.price_unit;
        _optionView.dataSource = _detailModel.optionList;
        
        if ([_detailModel.isNowSer isEqualToString:@"nowS"]) {
            _optionView.imagename = @"";
        }else {
            _optionView.imagename = @"通讯录页-箭头";
        }
        SIMOptionList *listm = _detailModel.optionList[[_detailModel.index intValue]];
        NSRange range = [listm.optionKey rangeOfString:@" "];
        if (range.location != NSNotFound) {
            _optionView.title = [listm.optionKey substringToIndex:range.location];//截取范围内的字符串
        }
//        NSLog(@"optionView.title %@",_optionView.title);
        _textF.text = [_detailModel.main stringValue];
    }else if ([_detailModel.serviceType intValue] == 2) {
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_view.mas_bottom).offset(20);
            make.left.mas_equalTo(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(-20);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_textF);
            make.left.mas_equalTo(_textF.mas_right).offset(10);
        }];
        _label.text = _detailModel.price_unit;
        _textF.text = [_detailModel.main stringValue];
    }else  {
        [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_view.mas_bottom).offset(20);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(35);
            make.left.mas_equalTo(15);
        }];
        [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_optionView);
            make.left.mas_equalTo(_optionView.mas_right).offset(10);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
            make.bottom.mas_equalTo(-20);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_textF);
            make.left.mas_equalTo(_textF.mas_right).offset(10);
        }];
        _label.text = _detailModel.price_unit;
        _optionView.dataSource = _detailModel.optionList;
        
        if ([_detailModel.isNowSer isEqualToString:@"nowS"]) {
            _optionView.imagename = @"";
        }else {
            _optionView.imagename = @"通讯录页-箭头";
        }
        SIMOptionList *listm = _detailModel.optionList[[_detailModel.index intValue]];
        NSRange range = [listm.optionKey rangeOfString:@" "];
        if (range.location != NSNotFound) {
            _optionView.title = [listm.optionKey substringToIndex:range.location];//截取范围内的字符串
        }
//        NSLog(@"optionView.title %@",_optionView.title);
        _textF.text = [_detailModel.main stringValue];
    }

}


@end
