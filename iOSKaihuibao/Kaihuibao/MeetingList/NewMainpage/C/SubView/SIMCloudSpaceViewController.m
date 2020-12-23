//
//  SIMCloudSpaceViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/1/8.
//  Copyright © 2020 Ferris. All rights reserved.
//
#define Start_X  kWidthScale(50)        // 第一个按钮的X坐标
#define Start_Y kWidthScale(10)          // 第一个按钮的Y坐标
#define Button_Height 44    // 高
#define Button_Width (self.frame.size.width - Start_X * 2)      // 宽
#define Width_Space Start_X        // 2个按钮之间的横间距
#define Height_Space kWidthScale(10)      // 竖间距


#import "SIMCloudSpaceViewController.h"

#import "SIMMessNotifListViewController.h"
#import "SIMCloudSpaceImageController.h"
#import "SIMNewMainPayViewController.h"
#import "SIMNewPlanChossen.h"

@interface SIMCloudSpaceViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (nonatomic, strong) SIMNewPlanChossen *segmentView;

@end

@implementation SIMCloudSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.model.titleName;
}

- (void)setModel:(SIMNModel_btnList *)model {
    _model = model;
    if ([_model.space_type isEqualToString:@"hardware"]) {
        [self.view addSubview:self.segmentView];
    }
    [self addSubViews];
    _label.text = _model.descriptionStr;
    NSLog(@"descriptionStrdescriptionStr %@",_model.descriptionStr);
    NSArray *arr = _model.buttons_info;
    _array = arr;
    
    NSUInteger rowNum = arr.count; // 行数
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(Start_Y + Button_Height* rowNum + Height_Space* (rowNum-1));
        make.bottom.mas_equalTo(-(BottomSaveH + 30));
    }];
    
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int index = 0 ; index < arr.count; index++) {
        NSDictionary *dic = arr[index];
        UIButton *aBt = [[UIButton alloc] init];
        [aBt setTitle:dic[@"button_text"] forState:UIControlStateNormal];
        aBt.tag = index;
        [aBt setTitleColor:BlueButtonColor forState:UIControlStateNormal];
        [aBt setBackgroundColor:[UIColor whiteColor]];
        aBt.layer.cornerRadius = 22;
        aBt.layer.masksToBounds = YES;
        aBt.layer.borderColor = BlueButtonColor.CGColor;
        aBt.layer.borderWidth = 1;
        aBt.titleLabel.font = FontRegularName(17);
        [self.backView addSubview:aBt];
        [aBt addTarget:self action:@selector(aBtClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:aBt];
        
        [aBt mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(index  * (Button_Height + Height_Space)+Start_Y);
            make.left.mas_equalTo(Start_X);
            make.right.mas_equalTo(-Start_X);
            make.height.mas_equalTo(Button_Height);
        }];
    }
}
- (void)addSubViews {
    _label = [[UILabel alloc] init];
    _label.textColor = BlackTextColor;
    _label.font = FontRegularName(19);
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_label];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(150);
    }];
    
}
// 底部按钮有区分
- (void)aBtClick:(UIButton *)sender {
    NSDictionary *dic = _array[sender.tag];
    if ([dic[@"button_type"] isEqualToString:@"plan"]) {
        // 支付页面
        SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
        [self.navigationController pushViewController:planVC animated:YES];
    }else if ([dic[@"button_type"] isEqualToString:@"confterminal"]) {
        // 会议控制器固定图片
        SIMCloudSpaceImageController *imageVC = [[SIMCloudSpaceImageController alloc] init];
        imageVC.modalPresentationStyle = 0;
        [self presentViewController:imageVC animated:YES completion:nil];
    }else if ([dic[@"button_type"] isEqualToString:@"cloudspace"]) {
        SIMMessNotifListViewController *messVC = [[SIMMessNotifListViewController alloc] init];
        messVC.title = self.model.titleName;
        messVC.isCloudSpace = YES;
        messVC.classification_id = self.model.serial;
        [self.navigationController pushViewController:messVC animated:YES];
    }
}

#pragma mark -- lazyload
- (SIMNewPlanChossen *)segmentView {
    if (!_segmentView) {
        self.segmentView = [[SIMNewPlanChossen alloc] initWithTitles:@[@"我的",@"团队"]  frame:CGRectMake(0, 0, screen_width, 46) selectIndex:0 hasLine:NO hasSlider:YES];
        __weak typeof(self) weakSelf = self;
        [self.segmentView setDidClickAtIndex:^(NSInteger index) {
            [weakSelf navigationDidSelectedControllerIndex:index];
        }];
    }
    return _segmentView;
}

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

-(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [self.view addSubview:self.backView];
    }return _backView;
}

#pragma mark - PrivateMethod
- (void)navigationDidSelectedControllerIndex:(NSInteger)index {
    [self.segmentView scrollToIndex:index * screen_width];
}

@end
