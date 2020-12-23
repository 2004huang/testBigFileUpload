//
//  SIMNCHeader.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/8.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#define Start_X  kWidthScale(0) // 第一个按钮的X坐标
#define Button_Height 80.0f    // 高
#define Button_Width (screen_width - Start_X * 2)/3      // 宽


#import "SIMNCHeader.h"
#import "SIMNCButton.h"

@interface SIMNCHeader()

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *confNumber;
@property (nonatomic, strong) UILabel *mytitle;

@end

@implementation SIMNCHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addTheSearchBarButton];
        
    }return self;
}

- (void)addTheSearchBarButton {
    _searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidthScale(10), 15, screen_width - kWidthScale(20), 35)];
    _searchBtn.backgroundColor = ZJYColorHex(@"#ededee");
    _searchBtn.layer.cornerRadius = 3;
    _searchBtn.layer.masksToBounds = YES;
    _searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _searchBtn.contentEdgeInsets = UIEdgeInsetsMake( 0, 15, 0, 0);
    _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    _searchBtn.titleLabel.font = FontRegularName(15);
    [_searchBtn setTitleColor:GrayPromptTextColor forState:UIControlStateNormal];
    [_searchBtn setTitle:SIMLocalizedString(@"CGSearchBarPlaceHolder", nil) forState:UIControlStateNormal];
    [_searchBtn setImage:[UIImage imageNamed:@"companySquare_searchicon"] forState:UIControlStateNormal];
    [_searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_searchBtn];
    
    // 三个按钮,@"Square",SIMLocalizedString(@"MMainConfHeaderAdress", nil)
    NSArray *image = @[@"Contacts",@"myfriend_new",@"group"];
    NSArray *textLabel = @[SIMLocalizedString(@"CContactPhoneContant", nil),SIMLocalizedString(@"CContactMineAdress", nil),SIMLocalizedString(@"ContantGroup_mine", nil)];
    
    for (int i = 0 ; i < textLabel.count; i++) {
        NSInteger index = i % 3;
        
        SIMNCButton *aBt = [[SIMNCButton alloc] init];
        [aBt setTitle:textLabel[i] forState:UIControlStateNormal];
        [aBt setImage:[UIImage imageNamed:image[i]] forState:UIControlStateNormal];
        aBt.frame = CGRectMake(index * Button_Width + Start_X, 65, Button_Width, Button_Height);
        aBt.imageView.contentMode = UIViewContentModeScaleAspectFit;
        aBt.titleLabel.font = FontRegularName(12);
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitleColor:ZJYColorHex(@"#6b6868") forState:UIControlStateNormal];
        [self addSubview:aBt];

//        CGFloat imageHeight = [UIImage imageNamed:image[i]].size.height;
//        CGFloat titleHeight = [textLabel[i] sizeWithAttributes:@{NSFontAttributeName:FontRegularName(11]}].height;
//        CGFloat titleWidth = [textLabel[i] sizeWithAttributes:@{NSFontAttributeName:FontRegularName(14]}].width;
//        CGFloat imageWidth = [UIImage imageNamed:image[i]].size.width;
//        CGFloat space = 5;// 图片和文字的间距
//
//        [aBt setImageEdgeInsets:UIEdgeInsetsMake(-(imageHeight*0.5 + space*0.5), titleWidth*0.5, imageHeight*0.5, -titleWidth*0.5 - space*0.5)];
//        [aBt setTitleEdgeInsets:UIEdgeInsetsMake(titleHeight*0.5 + space*0.5, -imageWidth*0.5, -(titleHeight*0.5 + space*0.5), imageWidth*0.5)];

        aBt.tag = i + 1000;
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
- (void)aBtClick:(UIButton *)sender {
    if (self.indexTagBlock) {
        self.indexTagBlock(sender.tag);
    }
}
- (void)searchBtnClick {
    if (self.btnClick) {
        self.btnClick();
    }
}

@end
