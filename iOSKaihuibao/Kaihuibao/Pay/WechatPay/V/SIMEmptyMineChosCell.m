//
//  SIMEmptyMineChosCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMEmptyMineChosCell.h"
@interface SIMEmptyMineChosCell()
@property (nonatomic, strong) UILabel *emptyLab;
@end

@implementation SIMEmptyMineChosCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setUpTitleView];
    }return self;
}
- (void)setUpTitleView {
    
    _emptyLab = [[UILabel alloc] init];
    _emptyLab.text = @"马上添加计划，享受AI智能会议";
    _emptyLab.textAlignment = NSTextAlignmentCenter;
    _emptyLab.font = FontRegularName(14);
    _emptyLab.textColor = NewBlackTextColor;
    [self.contentView addSubview:self.emptyLab];
    
    [_emptyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}
@end
