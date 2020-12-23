//
//  ClassdetailController.m
//  Kaihuibao
//
//  Created by Mac on 2017/11/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "ClassdetailController.h"

#import "UILabel+changeAligment.h"
#import "UIView+SDAutoLayout.h"
#import "SIMCallingViewController.h"


@interface ClassdetailController ()
{
    UIScrollView *bgScrollView;
    NSString *timeString;
}
@property (nonatomic, strong) UIButton *gotoBuy;

@end

@implementation ClassdetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_contants.nickname;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 50 - BottomSaveH)];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    
    UIButton  *headimg=[[UIButton alloc]init];
    headimg.layer.masksToBounds = YES;
    headimg.layer.cornerRadius = 50;
    headimg.layer.borderWidth = 3;
    headimg.layer.borderColor =ZJYColorHex(@"#f0ece6").CGColor;
    [scrollView addSubview:headimg];
    [headimg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.offset(100);
        make.width.offset(100);
        make.top.mas_equalTo(kWidthScale(30));
    }];
    if (_contants.avatar.length > 0) {
        if (![_contants.avatar isEqualToString:@"/assets/img/avatar.png"]) {
            [headimg setTitle:@"" forState:UIControlStateNormal];
            
            [headimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_contants.avatar]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
            headimg.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }else {
            // 取人名首字母
            NSString *name = _contants.nickname;
            if ([headimg sd_currentImageURL]) {
                [headimg setImage:nil forState:UIControlStateNormal];
            }
            headimg.backgroundColor = BlueButtonColor;
            [headimg setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
        }
    }else {
        // 取人名首字母
        NSString *name = _contants.nickname;
        if ([headimg sd_currentImageURL]) {
            [headimg setImage:nil forState:UIControlStateNormal];
        }
        headimg.backgroundColor = BlueButtonColor;
        [headimg setTitle:[NSString firstCharactorWithString:name] forState:UIControlStateNormal];
        
    }
    
//    UILabel *line=[[UILabel alloc]init];
//    line.backgroundColor=ZJYColorHex(@"#d3d3d3");
//    [scrollView addSubview:line];
//
//    [line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(90);
//        make.height.mas_equalTo(1);
//        make.left.mas_equalTo(90);
//        make.top.mas_equalTo(headimg).offset(kWidthScale(25));
//    }];
    
    
//    UILabel  *namelb=[[UILabel alloc]init];
//    namelb.frame=CGRectMake(0,CGRectGetMaxY(headimg.frame)+kWidthScale(20), screen_width, 30);
//    namelb.text=self.contants.nickname;
//    namelb.textColor=NewBlackTextColor;
//    namelb.font = FontRegularName(18];
//    namelb.textAlignment=NSTextAlignmentCenter;
//    CGAffineTransform matrix =CGAffineTransformMake(1, 0, tanf(10 * (CGFloat)M_PI / 180), 1, 0, 0);//设置反射。倾斜角度。
//    UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[UIFont fontWithName:@"PingFangSC-Regular" size:19].fontName matrix :matrix];//取得系统字符并设置反射。

//    namelb.font=[ UIFont fontWithDescriptor :desc size :19];
//    [scrollView addSubview:namelb];
//    [namelb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.view).offset(-20);
//        make.height.offset(25);
//        make.left.mas_equalTo(self.view).offset(20);
//        make.top.mas_equalTo(line.mas_bottom).offset(kWidthScale(25));
//    }];


    
    
//    UILabel *langlB=[[UILabel alloc]init];
//    langlB.textColor=ZJYColorHex(@"#77777C");
//    langlB.font=FontRegularName(15);
//    langlB.text=@"语言:中文";
//    [scrollView addSubview:langlB];
//    [langlB mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(screen_width-60);
//        make.height.offset(22);
//        make.left.mas_equalTo(self.view).offset(30);
//        make.top.mas_equalTo(namelb).offset(kWidthScale(45));
//    }];
    
    
    UILabel *gradelB=[[UILabel alloc]init];
    gradelB.textColor=NewBlackTextColor;
    gradelB.font=FontRegularName(16);
    gradelB.text= @"个人简介";
    [scrollView addSubview:gradelB];
    [gradelB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(screen_width-60);
        make.height.mas_equalTo(22);
        make.left.mas_equalTo(self.view).offset(30);
        make.top.mas_equalTo(headimg.mas_bottom).offset(kWidthScale(40));
    }];

    
    UILabel *gradelIn = [[UILabel alloc]init];
    gradelIn.textColor = TableViewHeaderColor;
    gradelIn.font = FontRegularName(15);
//    gradelB.backgroundColor = [UIColor yellowColor];
    gradelIn.numberOfLines = 0;
    [gradelIn sizeToFit];
    gradelIn.text = self.contants.introduction;
    [scrollView addSubview:gradelIn];
    [gradelIn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(screen_width-60);
        make.left.mas_equalTo(self.view).offset(30);
        make.top.mas_equalTo(gradelB).offset(40);
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    if (self.contants.introduction != nil) {
        [gradelIn changeAlignmentRightandLeft];
    }
    
    
    CGFloat hei = gradelIn.frame.origin.y + gradelIn.frame.size.height;
    NSLog(@"heihei %lf",hei);
    
    

    scrollView.contentSize = CGSizeMake(screen_width,hei + 30);

    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:@"呼叫老师" forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = BlueButtonColor;
    
    _gotoBuy.titleLabel.font = FontRegularName(16);
    [_gotoBuy addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH+50));
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.right.mas_equalTo(0);
    }];
    
}



- (void)pushTheNextPage {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    if (!manager.isReachable) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"ENTER_NETWORK_NO_CONNECT", nil)];
        return ;
    }
    
    SIMCallingViewController *callVC = [[SIMCallingViewController alloc] init];
    if(self.contants != nil){
        callVC.person = self.contants;//上一页人名
    }
    callVC.kindOfCall = @"videoCall";
    callVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:callVC animated:YES completion:nil];
               
}


@end

