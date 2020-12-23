//
//  SIMCloudSpaceImageController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/1/8.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMCloudSpaceImageController.h"

@interface SIMCloudSpaceImageController ()
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UIButton *button;
@end

@implementation SIMCloudSpaceImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imageV = [[UIImageView alloc] init];
    _imageV.image = [UIImage imageNamed:@"会议控制器"];
    _imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageV];
    [_imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.mas_equalTo(0);
    }];
    
    _button = [[UIButton alloc] init];
    [_button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    _button.titleLabel.font = FontMediumName(40);
    [self.view addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarH + 15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    [_button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"×" forState:UIControlStateNormal];
}
- (void)buttonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
