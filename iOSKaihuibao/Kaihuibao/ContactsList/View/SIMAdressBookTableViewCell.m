//
//  SIMAdressBookTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/7/31.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAdressBookTableViewCell.h"
@interface SIMAdressBookTableViewCell()
{
    NSArray *colorArr;
}
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *detail;
//@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation SIMAdressBookTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        colorArr = @[@"#4faaf0",@"f7b55e",@"f4735e",@"17c295"];
        CGFloat iconHeight = 36;
        _iconBtn = [[UIButton alloc] init];
        _iconBtn.layer.cornerRadius = 3;
        _iconBtn.layer.masksToBounds = YES;
        [_iconBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _iconBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
        _iconBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _iconBtn.backgroundColor = ZJYColorHex(@"#7a86cc");
        _iconBtn.backgroundColor = ZJYColorHex(colorArr[arc4random()%4]);

        [self.contentView addSubview:_iconBtn];
        
        _label = [[UILabel alloc] init];
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(16);
        [self.contentView addSubview:_label];
        
        _detail = [[UILabel alloc] init];
        _detail.textColor = GrayPromptTextColor;
        _detail.font = FontRegularName(12);
        [self.contentView addSubview:_detail];
        
        [_iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(iconHeight);
            make.width.mas_equalTo(iconHeight);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_iconBtn.mas_top);
            make.left.mas_equalTo(_iconBtn.mas_right).offset(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-100);
        }];
        [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_iconBtn.mas_bottom);
            make.left.mas_equalTo(_label.mas_left);
            make.right.mas_equalTo(_label.mas_right);
        }];
        
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setTitle:SIMLocalizedString(@"NavBackADD", nil) forState:UIControlStateNormal];
        [_addBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        _addBtn.layer.borderColor = BlueButtonColor.CGColor;
        _addBtn.layer.borderWidth = 1;
        _addBtn.layer.masksToBounds = YES;
        _addBtn.layer.cornerRadius = 25/4;
        _addBtn.titleLabel.font = FontRegularName(13);
        [_addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_addBtn];
        
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(25);
            make.width.mas_equalTo(60);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        }];

        
    }
    return self;
}

// 开始按钮block
- (void)addBtnClick {
    if (self.addClick) {
        self.addClick();
    }
}

- (void)setSont:(SIMContants *)sont {
    _sont = sont;
    [_iconBtn setTitle:[NSString firstCharactorWithString:_sont.nickname] forState:UIControlStateNormal];
    _label.text = _sont.nickname;
    _detail.text = _sont.mobile;
}


@end
