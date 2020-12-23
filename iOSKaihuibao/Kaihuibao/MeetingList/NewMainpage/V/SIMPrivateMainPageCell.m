//
//  SIMPrivateMainPageCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/6/17.
//  Copyright © 2019 Ferris. All rights reserved.
//
#define Button_Height 50.0f    // 高
#define Button_Width screen_width      // 宽
#define Start_X  0           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Height_Space 1.0f      // 竖间距


#import "SIMPrivateMainPageCell.h"
#import "NFButton.h"

@interface SIMPrivateMainPageCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end
@implementation SIMPrivateMainPageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }return self;
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:self.backView];
    }return _backView;
}

- (NSMutableArray *)tempButtonArray{
    if (!_tempButtonArray) {
        _tempButtonArray = [NSMutableArray array];
    }
    return _tempButtonArray;
}
- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (void)setModel:(SIMNModel *)model {
    _model = model;
    NSArray *arr = _model.btn_list;
    
    NSUInteger rowNum = arr.count; // 行数
    
    // for循环创建的button加到arr里在每次布局前移除
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i = 0 ; i < arr.count; i++) {
        NSInteger page = i;
        NFButton *aBt = [[NFButton alloc] init];
        [aBt setTitle:[arr[i] titleName] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:[arr[i] bannerPic]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.tag = [[arr[i] serial] integerValue];
        aBt.titleLabel.font = FontRegularName(15);
        aBt.titleLabel.textAlignment = NSTextAlignmentLeft;
//        aBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        aBt.contentEdgeInsets = UIEdgeInsetsMake(0,15, 0, 0);
        [aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
        [self.backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempButtonArray addObject:aBt];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self.backView addSubview:line];
        line.frame = CGRectMake( Start_X, page * (Button_Height + Height_Space)+Start_Y + Button_Height, Button_Width, 0.5);
        [self.buttonArray addObject:line];
    }
    self.backView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_title,5).heightIs(Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
    
    // sdautolayout的自动适应单元格
    [self setupAutoHeightWithBottomView:self.backView bottomMargin:1];
    
}

// 图标按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}

@end
