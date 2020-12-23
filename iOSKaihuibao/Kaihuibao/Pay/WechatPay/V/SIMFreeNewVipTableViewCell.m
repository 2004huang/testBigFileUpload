//
//  SIMFreeNewVipTableViewCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/11/2.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Start_X 10.0f + (screen_width - Button_Width * 4 - 20)/5           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 4 - 20)/5        // 2个按钮之间的横间距
#define Height_Space 15.0f      // 竖间距
#define Button_Height 95.0f    // 高
#define Button_Width 70.0f      // 宽

#import "SIMFreeNewVipTableViewCell.h"
#import "SIMFreeBtn.h"

@interface SIMFreeNewVipTableViewCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@property (nonatomic, strong) UIView *backView;
@end
@implementation SIMFreeNewVipTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.tempButtonArray = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        [self setUpTitleView];
        
    }return self;
}
- (void)setUpTitleView {
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 40)];
    _topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, screen_width-60, 40)];
    _title.text = SIMLocalizedString(@"NPayAllNext_vipTitle", nil);
    _title.textAlignment = NSTextAlignmentLeft;
    _title.font = FontRegularName(14);
    _title.textColor = NewBlackTextColor;
    [self.topView addSubview:self.title];
    
    // 白色背景 放一堆按钮的背景View
    _backView = [[UIView alloc] init];
    [self.contentView addSubview:self.backView];
}
- (void)setArr:(NSArray *)arr {
    _arr = arr;
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.tempButtonArray removeAllObjects];
    }
    for (int i = 0 ; i < _arr.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        
        NSDictionary *dic = _arr[i];
        // 圆角按钮
        
        SIMFreeBtn *aBt = [[SIMFreeBtn alloc] init];
        NSString *str = dic[@"namestr"];

        [aBt setTitle:str forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:dic[@"picstr"]] forState:UIControlStateNormal];
        
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.titleLabel.numberOfLines = 0;
        aBt.titleLabel.font = FontRegularName(10);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        aBt.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
        [_backView addSubview:aBt];
        aBt.tag = i + 1000;
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempButtonArray addObject:aBt];
    }
    
    NSUInteger rowNum = (_arr.count + 3) / 4;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space*(rowNum-1));
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-15);
    }];
}

- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}
@end
