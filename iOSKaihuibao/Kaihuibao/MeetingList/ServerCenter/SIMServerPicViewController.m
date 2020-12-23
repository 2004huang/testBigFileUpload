//
//  SIMServerPicViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/5/28.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMServerPicViewController.h"

@interface SIMServerPicViewController ()
{
    NSInteger total;
}
@property (nonatomic, strong) UIImageView *img;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SIMServerPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    total = 1;
    [self addUISubviews];
    [self startTimer];
    
}
- (void)addUISubviews {
    _img = [[UIImageView alloc] init];
    _img.backgroundColor = ZJYColorHex(@"#eeeeee");
    _img.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_img];
    [_img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kApiBaseUrl,_dic[@"loading_image"]]] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    // 主标题label
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = FontRegularName(15);
    _titleLab.text = _dic[@"loading_word"];
    _titleLab.textColor = [UIColor whiteColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kWidthScale(100));
        make.left.mas_equalTo(kWidthScale(60));
        make.right.mas_equalTo(-kWidthScale(60));
    }];
    
}
//
//- (void)exitConference:(NSError * _Nullable)error {
//    NSLog(@"serverpicpage退出会议");
//    UIViewController *vc =self.presentingViewController;
//
//    while ([vc isKindOfClass:[SIMServerPicViewController class]]) {
//        vc = vc.presentingViewController;
//    }
//    [vc dismissViewControllerAnimated:YES completion:nil];
//
//    self.tabBarController.tabBar.tintColor = TabbarBtnSelectColor;
//    self.tabBarController.tabBar.unselectedItemTintColor = TabbarBtnNormalColor;
//
//    [UIApplication sharedApplication].statusBarHidden = NO;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//
//}
// 定时器 及重发方法
-(void)startTimer
{
    _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(overrunnPrompt) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

- (void)overrunnPrompt {
    NSLog(@"totaltotal %ld",total);
    if (total == 0) {
        [self postTheEnterConf];
        return;
    }
    total --;

}

- (void)invalidateTheTimer {
    NSLog(@"调用了invalidateTheTimer");
    if (_timer != nil) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self invalidateTheTimer];
    NSLog(@"调用了viewWillDisappear");
}
- (void)dealloc {
    [self invalidateTheTimer];
    NSLog(@"调用了dealloc");
}
- (void)postTheEnterConf {
    [self invalidateTheTimer];
    NSDictionary *myDictionary = @{@"confId":self.conf_id};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SEVERCENTERENTERCONF" object:nil userInfo:myDictionary];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
