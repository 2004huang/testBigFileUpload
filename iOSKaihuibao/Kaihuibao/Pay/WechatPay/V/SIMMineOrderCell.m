//
//  SIMMineOrderCell.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/11.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define Button_Height 65    // 高
#define Button_Width (screen_width - 30) /3     // 宽
#define Start_X  0           // 第一个按钮的X坐标
#define Start_Y 0.0f          // 第一个按钮的Y坐标
#define Width_Space 0        // 2个按钮之间的横间距

#import "SIMMineOrderCell.h"
@interface SIMMineOrderCell()
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *asscoryImage;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIButton *detail;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSMutableArray<UILabel *> *buttonArray;


@property (nonatomic, strong) UILabel *titleName;
@property (nonatomic, strong) UILabel *liuliang;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *sepline;
@property (nonatomic, strong) UIButton *start;

@end
@implementation SIMMineOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.buttonArray = [[NSMutableArray alloc] init];
        [self addBackViews];
    }return self;
}

- (void)addBackViews {
    UIView *backV = [[UIView alloc] init];
    backV.backgroundColor = [UIColor whiteColor];
    backV.layer.borderColor = ZJYColorHex(@"#ebebeb").CGColor;
    backV.layer.borderWidth = 1;
    backV.layer.cornerRadius = 5;
    backV.layer.masksToBounds = YES;
    [self.contentView addSubview:backV];
    
    _titleName = [[UILabel alloc] init];
    _titleName.font = FontRegularName(kWidthS(14));
    _titleName.textColor = BlackTextColor;
    [backV addSubview:_titleName];
    
    _backView = [[UIView alloc] init];
    [backV addSubview:self.backView];
    
    [backV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(15);
        make.right.bottom.mas_equalTo(-15);
//        make.height.mas_equalTo(120);
    }];
    [_titleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(15);
        make.width.mas_equalTo(screen_width - 60);
    }];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_titleName.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(Button_Height + 5);
        make.bottom.mas_equalTo(-10);
    }];
    
    
}
- (void)setDetailModel:(SIMNewPlanDetailModel *)detailModel {
    _detailModel = detailModel;
    _titleName.text = [NSString stringWithFormat:@"%@",_detailModel.name];
    NSString *manstr = [NSString stringWithFormat:@"%@\n%@%@",SIMLocalizedString(@"NPayMainSeverce_titleOne_Man", nil),[_detailModel.participant stringValue],SIMLocalizedString(@"NPayAllNext_manunit", nil)];
    NSString *roomStr = [NSString stringWithFormat:@"%@\n%@%@",SIMLocalizedString(@"NPayMainSeverce_titleOne_Room", nil),[_detailModel.conferenceRoom stringValue],SIMLocalizedString(@"NPayAllNext_roomunit", nil)];
    NSString *freeStr = [NSString stringWithFormat:@"%@\n%@%@",SIMLocalizedString(@"NPayMainSeverce_titleThree_Man", nil),[_detailModel.main stringValue],SIMLocalizedString(@"NPayAllNext_hostunit", nil)];
   
    //    NSString *partStr;
    //    if ([_hismodel.participant integerValue] == 1024) {
    //        partStr = [NSString stringWithFormat:@"%@\n不限",manstr];
    //    }else {
    //        partStr = [NSString stringWithFormat:@"%@\n%ld名",manstr,[_hismodel.participant integerValue]];
    //    }
    //    NSString *partStr = [NSString stringWithFormat:@"%@\n%ld名",manstr,[_hismodel.participant integerValue]];
    //    NSString *roomCountStr = [NSString stringWithFormat:@"%@\n不限",roomStr];
    
    //    NSString *priceStr;
    //    if ([_hismodel.total floatValue] == 0.0) {
    //        priceStr = [NSString stringWithFormat:@"%@\n免费",freeStr];
    //    }else {
    //        priceStr = [NSString stringWithFormat:@"%@\n￥%@/%@",freeStr,[_hismodel.total stringValue],_hismodel.plantype];
    //    }
    NSArray *arrOrder = @[manstr,roomStr,freeStr];
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    for (int buttonIndex = 0 ; buttonIndex < arrOrder.count; buttonIndex++) {
        NSInteger index = buttonIndex % 3;
        NSInteger page = buttonIndex / 3;
        UILabel *back = [[UILabel alloc] init];
        back.text = arrOrder[buttonIndex];
        back.numberOfLines = 0;
        back.font = FontRegularName(kWidthS(14));
        back.textColor = BlackTextColor;
        back.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X, page  * Button_Height+Start_Y, Button_Width, Button_Height);
        [_backView addSubview:back];
        [self setLabelSpace:back withValue:arrOrder[buttonIndex] withFont:FontRegularName(kWidthS(14))];
        [self.buttonArray addObject:back];
    }
}

-(void)setLabelSpace:(UILabel*)label withValue:(NSString*)str withFont:(UIFont*)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentCenter;
    
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
