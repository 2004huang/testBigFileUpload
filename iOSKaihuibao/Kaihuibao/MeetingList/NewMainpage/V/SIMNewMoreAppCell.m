//
//  SIMNewMoreAppCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/18.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height 75.0f    // 高
#define Button_Width 70.0f      // 宽
#define Start_X  (screen_width - Button_Width * 4)/8           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space (screen_width - Button_Width * 4)/4        // 2个按钮之间的横间距
#define Height_Space 30.0f      // 竖间距


#import "SIMNewMoreAppCell.h"
#import "SIMMeetBtn.h"
@interface SIMNewMoreAppCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) NSMutableArray *tempButtonArray;

@end
@implementation SIMNewMoreAppCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }return self;
}

#pragma mark -- lazyload
- (NSMutableArray *)tempButtonArray{
    if (!_tempButtonArray) {
        _tempButtonArray = [NSMutableArray array];
    }
    return _tempButtonArray;
}
-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self.contentView addSubview:self.backView];
    }return _backView;
}


- (void)setModel:(SIMNModel *)model {
    _model = model;
    //    [_mutArr removeAllObjects];
    //    [_buttonArray removeAllObjects];
    NSArray *arr = _model.btn_list;
    
    NSUInteger rowNum = (arr.count + 3) / 4; // 行数
    
    if (self.tempButtonArray.count > 0) {
        [self.tempButtonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int i = 0 ; i < arr.count; i++) {
        NSInteger index = i % 4;
        NSInteger page = i / 4;
        
        SIMMeetBtn *aBt = [[SIMMeetBtn alloc] init];
        [aBt setTitle:[arr[i] titleName] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:[arr[i] bannerPic]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * (Button_Height + Height_Space)+Start_Y, Button_Width, Button_Height);
        aBt.tag = i;
        aBt.titleLabel.font = FontRegularName(13);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#333333") forState:UIControlStateNormal];
        [self.backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.tempButtonArray addObject:aBt];
    }
    self.backView.sd_layout.leftEqualToView(self).rightEqualToView(self).topSpaceToView(self.contentView,20).heightIs(Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
    
    
    [self setupAutoHeightWithBottomView:self.backView bottomMargin:17];
    
    
}

- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}



@end
