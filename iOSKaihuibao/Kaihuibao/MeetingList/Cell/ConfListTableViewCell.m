//
//  ConfListTableViewCell.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/22.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "ConfListTableViewCell.h"
#import "NSDate+SIMConvenient.h"

@interface ConfListTableViewCell()
// 时间 标题 会议ID 开始会议按钮
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *detail;


@end

@implementation ConfListTableViewCell
// 会议列表cell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews {
    // 时间label
    _time = [[UILabel alloc] init];
    _time.textColor = ZJYColorHex(@"#666666");
    _time.font = FontRegularName(12);
    _time.textAlignment = NSTextAlignmentLeft;
    _time.numberOfLines = 0;
    //    _time.text = [NSString stringWithFormat:@"%@\n%@",@"3:00",@"下午"];// 以后在setmodel里面赋值
    [self.contentView addSubview:self.time];
    // 主标题label
    _title = [[UILabel alloc] init];
    //    _title.text = @"开会宝云会议体验中心";
    _title.font =FontRegularName(16);
    _title.textColor = ZJYColorHex(@"#333333");
    _title.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.title];
    // 会议号label
    _detail = [[UILabel alloc] init];
    _detail.textColor = ZJYColorHex(@"#666666");
    _detail.font = FontRegularName(13);
    //    _detail.text = @"138-273-215";
    _detail.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:self.detail];
    // 开始按钮
    _start = [UIButton buttonWithType:UIButtonTypeCustom];
    [_start setTitle:SIMLocalizedString(@"MMainConfStartBtn", nil) forState:UIControlStateNormal];
    _start.titleLabel.font = FontRegularName(13);
    _start.layer.cornerRadius = 7;
    _start.layer.masksToBounds = YES;
    [_start setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [_start setBackgroundColor:[UIColor whiteColor]];
    _start.layer.borderWidth = 1;
    _start.layer.borderColor = BlueButtonColor.CGColor;
    [_start setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_start setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
    [self.contentView addSubview:self.start];
    [_start addTarget:self action:@selector(startBtn) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)setMyVideoM:(SIMMyServiceVideo *)myVideoM {
    _myVideoM = myVideoM;
    _title.text = @"我的营销客服";
    
    _detail.text = [NSString transTheConfIDToTheThreeApart:_myVideoM.cid];
    

    _time.text = @"";

    _start.hidden = NO;
    _start.enabled = YES;
    self.accessoryType = UITableViewCellAccessoryNone;
    
    // 适配
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_time.mas_right).offset(20);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-kWidthScale(90));
        make.height.mas_equalTo(20);
    }];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_title.mas_left);
        make.top.mas_equalTo(_title.mas_bottom).offset(6);
        make.right.mas_equalTo(-kWidthScale(80));
        make.height.mas_equalTo(15);
    }];
    [_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(55);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(28);
    }];
}
// setModel方法赋值
- (void)setConflistModel:(ArrangeConfModel *)conflistModel {
    _conflistModel = conflistModel;
    
    _title.text = _conflistModel.name;
    
    // 为字符串加“-”进行分割
    _detail.text = [NSString transTheConfIDToTheThreeApart:_conflistModel.cid];
    
//    // 日期赋值 时间格式为 上午几点 下午几点 是12小时制
    NSString *dateStart = _conflistModel.startTime;// 首先将拿到的日期字符串转化为date
    _time.text = [NSString dateTranformTimeStrFromTimeStr:dateStart withFromformat:@"yyyy-MM-dd HH:mm:ss" withToformat:@"HH:mm"];// 最后将转化后的字符串赋值

    // 如果是周期会议那么时间不显示
    if (![_conflistModel.repeat isEqualToString:@"n"]) {
        _start.hidden = NO;
        _start.enabled = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
    }else {
        NSString *nowDate = [NSString dateTranformTimeStrFromDate:[NSDate date] withformat:@"yyyy-MM-dd"];
        NSString *modelDate = [NSString dateTranformTimeStrFromTimeStr:dateStart withFromformat:@"yyyy-MM-dd HH:mm:ss" withToformat:@"yyyy-MM-dd"];
        NSLog(@"nowDate %@,modelDate %@",nowDate,modelDate);
        if ([nowDate isEqualToString:modelDate]) {
            _start.hidden = NO;
            _start.enabled = YES;
            self.accessoryType = UITableViewCellAccessoryNone;
        }else {
            _start.hidden = YES;
            _start.enabled = NO;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    // 适配
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_time.mas_right).offset(20);
        make.top.mas_equalTo(8);
        make.right.mas_equalTo(-kWidthScale(90));
        make.height.mas_equalTo(20);
    }];
    [_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_title.mas_left);
        make.top.mas_equalTo(_title.mas_bottom).offset(6);
        make.right.mas_equalTo(-kWidthScale(80));
        make.height.mas_equalTo(15);
    }];
    [_start mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(55);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(28);
    }];
}


// 开始按钮block
- (void)startBtn {
    if (self.startClick) {
        self.startClick();
    }
}



@end
