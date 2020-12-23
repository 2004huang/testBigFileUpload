//
//  SIMNMmainCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/4.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height 80.0f    // 高
#define Button_Width 80.0f      // 宽
#define Start_X  (screen_width - Button_Width * 4)/8           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 4)/4        // 2个按钮之间的横间距
#define Height_Space 30.0f      // 竖间距


#import "SIMNMmainCell.h"
#import "SIMMeetBtn.h"
@interface SIMNMmainCell()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;

@end

@implementation SIMNMmainCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }return self;
}

#pragma mark -- lazyload
- (UILabel *)title {
    if (!_title) {
        // 充当页眉作用的每一栏cell的标题
        _title = [[UILabel alloc] init];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.font = FontRegularName(16);
        _title.textColor = NewBlackTextColor;
        [self.contentView addSubview:self.title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(kWidthScale(15));
            make.right.mas_equalTo(-kWidthScale(15));
            make.top.mas_equalTo(10);
        }];
    }return _title;
}
//- (UIButton *)moreBtn {
//    if (!_moreBtn) {
//        // 更多按钮 只有当cell的index为0的时候才有
//        _moreBtn = [[UIButton alloc] init];
//        [_moreBtn setTitleColor:NewBlackTextColor forState:UIControlStateNormal];
//        _moreBtn.titleLabel.font = FontRegularName(13];
//        [_moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.contentView addSubview:_moreBtn];
//        [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-kWidthScale(15));
//            make.top.mas_equalTo(20);
//            make.height.mas_equalTo(20);
//        }];
//    }return _moreBtn;
//}

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
    
//    [_mutArr removeAllObjects];
//    [_buttonArray removeAllObjects];
    NSArray *arr = _model.btn_list;
    if (_model.isMore != nil) {
        
        self.title.text = _model.mainTitle;
//        self.moreBtn.hidden = NO;
//        self.moreBtn.tag = [_model.serial integerValue];
//        [self.moreBtn setTitle:_model.isMore forState:UIControlStateNormal];
    }else {
//        [self.moreBtn setTitle:nil forState:UIControlStateNormal];
//        self.moreBtn.hidden = YES;
        self.title.text = @"";
    }

    NSUInteger rowNum = (arr.count + 3) / 4; // 行数
    
    // for循环创建的button加到arr里在每次布局前移除
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i = 0 ; i < arr.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:[arr[i] titleName] forState:UIControlStateNormal];
        if ([arr[i] webData] == YES) {
            [aBt sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,[arr[i] bannerPic]]] forState:UIControlStateNormal placeholderImage:[UIImage imageWithColor:ZJYColorHex(@"#eeeeee")] options:SDWebImageAllowInvalidSSLCertificates];
        }else {
            [aBt setImage:[UIImage imageNamed:[arr[i] bannerPic]] forState:UIControlStateNormal];
        }
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.tag = [[arr[i] serial] integerValue];
        aBt.titleLabel.font = FontRegularName(13);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
        [self.backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempButtonArray addObject:aBt];
        
        if ([arr[i] remark] == nil) {
            
        }else {
            UIButton *nowPlan =[[UIButton alloc] init];
            [nowPlan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            nowPlan.titleLabel.font = FontRegularName(10);
            [self.backView addSubview:nowPlan];//一定要先添加到视图上
            
            [nowPlan setTitle:[arr[i] remark] forState:UIControlStateNormal];
            NSString *ss = [arr[i] remark];
            CGSize size = [ss sizeWithAttributes:@{NSFontAttributeName:FontRegularName(10)}];
            CGFloat width = size.width + 5;
            nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width-10 - width/2) , page  * (Button_Height + Height_Space)+Start_Y - 10, width, 18);
            nowPlan.titleLabel.adjustsFontSizeToFitWidth = YES;
            [nowPlan setBackgroundImage:[[UIImage imageNamed:@"mainpage_remarkback"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
            [self.buttonArray addObject:nowPlan];
        }
        
        
    }
    self.backView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(_title,10).heightIs(Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
    
    // sdautolayout的自动适应单元格
    [self setupAutoHeightWithBottomView:self.backView bottomMargin:17];
    
    
}

// 点击更多按钮的方法
- (void)moreBtnClick:(UIButton *)sender {
    if (self.btnClick) {
        self.btnClick(sender.tag);
    }
}
// 图标按钮点击方法
- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}



@end
