//
//  SIMEntranceViewController.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/29.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMEntranceViewController.h"

#import "SIMLoginViewController.h"
#import "SIMRegisterViewController.h"
#import "SIMJoinMeetingViewController.h"
#import "SIMNetSettingViewController.h"
#import "SIMLoginMainViewController.h"
#import "SIMAppSettingViewController.h"
#import "SIMFirstLoginPageViewController.h"
#import "SIMTempCompanyViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"

@interface SIMEntranceViewController () <UIScrollViewDelegate,UITextFieldDelegate,CLConferenceDelegate>
{
    CGFloat scrollViewHeight;
    UITextField *userEmail;
    UIAlertAction *okAction;
    NSDictionary *successDic;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageController;
//@property (nonatomic, strong) UIButton* registerBT;
@property (nonatomic, strong) UIButton* loginBT;
@property (nonatomic, strong) UIButton *joinMeetingBT;
@property (nonatomic, strong) UIButton *settingBT;
//@property (nonatomic, strong) UIButton *onlineBT;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@property (strong,nonatomic) NSArray *locationArr;
@property (strong,nonatomic) NSString *httpStr;
@property (strong,nonatomic) NSString *hostStr;
@property (strong,nonatomic) NSString *portStr;
@property (strong,nonatomic) UILabel *agreementLab;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@end

@implementation SIMEntranceViewController
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterConfBYShareLogin:) name:EnterConfBYShare object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTheServerRefreshPage) name:@"changeTheServerRefreshPage" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)enterConfBYShareLogin:(NSNotification *)notification {
    NSDictionary *shareTheConfEnter = [notification userInfo];
    [self postToEnterTheConfID:shareTheConfEnter[@"confId"] psw:shareTheConfEnter[@"webStr"]];
}
- (void)changeTheServerRefreshPage {
    [self addUIMasnory]; // 因为私有云会调整界面视图
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"entrancecomcomteo %@ %@ %@", self.currentUser.uid, self.currentCompany.company_name,self.currentUser.currentCompany.company_name);
    [self setUISubviews];           // 布局子UI
}

- (void)setUISubviews {
    scrollViewHeight = screen_height  - BottomSaveH - StatusBarH - 50 - kWidthScale(230);
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
//    scrollView.bounces = NO;
    _scrollView.showsVerticalScrollIndicator  = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(StatusBarH + 50);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(scrollViewHeight);
    }];
    
    _pageController = [[UIPageControl alloc] init];
    _pageController.pageIndicatorTintColor = ZJYColorHex(@"#D6D6D6");
    _pageController.currentPageIndicatorTintColor = ZJYColorHex(@"#dbdbdb");
    
    // 公有云
    _joinMeetingBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _joinMeetingBT.backgroundColor = [UIColor whiteColor];
    _joinMeetingBT.titleLabel.font = FontRegularName(18);
    _joinMeetingBT.layer.masksToBounds = YES;
    _joinMeetingBT.layer.cornerRadius = 11;
    _joinMeetingBT.layer.borderColor = BlueButtonColor.CGColor;
    _joinMeetingBT.layer.borderWidth = 1;
    [_joinMeetingBT setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [_joinMeetingBT setTitle:SIMLocalizedString(@"MMainConfHeaderJoin", nil) forState:UIControlStateNormal];
    [_joinMeetingBT setBackgroundImage:[UIImage imageWithColor:HightLightButtonTitleColor] forState:UIControlStateHighlighted];
    [_joinMeetingBT addTarget:self action:@selector(joinClickMethod) forControlEvents:UIControlEventTouchUpInside];

    _loginBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBT.backgroundColor = BlueButtonColor;
    _loginBT.titleLabel.font = FontRegularName(18);
    _loginBT.layer.masksToBounds = YES;
    _loginBT.layer.cornerRadius = 11;
    [_loginBT setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBT setTitle:SIMLocalizedString(@"OnlineLearn", nil) forState:UIControlStateNormal];
    [_loginBT setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_loginBT setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    [_loginBT addTarget:self action:@selector(loginClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
//    _onlineBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    _onlineBT.titleLabel.font = FontRegularName(14);
//    _onlineBT.enabled = YES;
//    [_onlineBT setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//    //    onlineBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [_onlineBT setTitle:SIMLocalizedString(@"OnlineLearn", nil) forState:UIControlStateNormal];
//    [_onlineBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [_onlineBT addTarget:self action:@selector(onlineClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
//    _joinMeetingBT = [UIButton buttonWithType:UIButtonTypeCustom];
//    _joinMeetingBT.titleLabel.font = FontRegularName(14);
//    _joinMeetingBT.enabled = YES;
//    [_joinMeetingBT setTitleColor:BlueButtonColor forState:UIControlStateNormal];
//    [_joinMeetingBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//    [_joinMeetingBT setTitle:SIMLocalizedString(@"MMainConfHeaderJoin", nil) forState:UIControlStateNormal];
//    [_joinMeetingBT addTarget:self action:@selector(joinClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    _settingBT = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingBT.titleLabel.font = FontRegularName(14);
    [_settingBT setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    //    settingBT.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_settingBT setTitle:SIMLocalizedString(@"AlertCSet", nil) forState:UIControlStateNormal];
    [_settingBT setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_settingBT addTarget:self action:@selector(setClickMethod) forControlEvents:UIControlEventTouchUpInside];
    
    [self addUIMasnory]; // 因为私有云会调整界面视图
}

- (void)addUIMasnory {
    NSLog(@"changeTheServerRefreshPage %d",[self.cloudVersion.version isEqualToString:@"privatization"]);
    NSArray *headerImages;
    if ([self.cloudVersion.start_img boolValue]) {
        headerImages = @[@"entranceview_imageOne",@"entranceview_imageTwo",@"entranceview_imageThree",@"entranceview_imageFour",@"entranceview_imageFive"];
        
        _pageController.numberOfPages = headerImages.count;
        [self.view addSubview:_pageController];
        [_pageController mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(_scrollView.mas_bottom);
            make.height.mas_equalTo(kWidthScale(20));
        }];
    }else {
        headerImages = @[@"entranceview_imageOne"];
        [_pageController removeFromSuperview];
    }
    _scrollView.contentSize = CGSizeMake(screen_width*headerImages.count, scrollViewHeight);
    if (self.buttonArray.count > 0) {
        [self.buttonArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i=0; i<headerImages.count; i++) {
        UIImageView* sloganImageView = [[UIImageView alloc] init];
        sloganImageView.contentMode = UIViewContentModeScaleAspectFit;
        sloganImageView.image = [UIImage imageNamed:[SIMInternationalController getLanPicNameWithPicName:headerImages[i]]];
        sloganImageView.frame = CGRectMake(screen_width*i, 0, screen_width, scrollViewHeight);
        [_scrollView addSubview:sloganImageView];
        [self.buttonArray addObject:sloganImageView];
    }
    
    UIButton *button = nil;
    
    [self.view addSubview:_loginBT];
    if ([self.cloudVersion.join_meeting boolValue]) {
        [self.view addSubview:_joinMeetingBT];
        [_joinMeetingBT mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(kWidthScale(75) + BottomSaveH));
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-48);
            make.height.mas_equalTo(46);
        }];
        [_loginBT mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_joinMeetingBT.mas_top).offset(-15);
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-48);
            make.height.mas_equalTo(46);
        }];
        
        button = _joinMeetingBT;
    }else {
        [_joinMeetingBT removeFromSuperview];
        [_loginBT mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-(kWidthScale(75) + BottomSaveH + 46));
            make.left.mas_equalTo(48);
            make.right.mas_equalTo(-48);
            make.height.mas_equalTo(46);
        }];
        button = _loginBT;
    }
    
//    NSMutableArray *btmThreeBtnArr = [NSMutableArray array];
//    if ([self.cloudVersion.join_meeting boolValue]) {
//        [btmThreeBtnArr addObject:_joinMeetingBT];
//    }
//    [btmThreeBtnArr addObject:_settingBT];
//    if ([self.cloudVersion.online_experience boolValue]) {
//        [btmThreeBtnArr addObject:_onlineBT];
//    }
    
//    NSInteger arrCount = btmThreeBtnArr.count;
    
//    [self.view addSubview:_joinMeetingBT];
//    if ([self.cloudVersion.join_meeting boolValue]) {
//        [_joinMeetingBT mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(button.mas_bottom).offset(15);
//            make.left.mas_equalTo(0);
//            make.width.mas_equalTo(screen_width/arrCount);
//            make.height.mas_equalTo(20);
//        }];
//
//    }else {
//        [_joinMeetingBT mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(button.mas_bottom).offset(15);
//            make.left.mas_equalTo(0);
//            make.width.mas_equalTo(0);
//            make.height.mas_equalTo(20);
//        }];
//    }
    
    [self.view addSubview:_settingBT];
    [_settingBT mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(button.mas_bottom).offset(15);
        make.width.mas_equalTo(_joinMeetingBT.mas_width).multipliedBy(0.3);
//            make.centerX.mas_equalTo(button);
            make.right.mas_equalTo(_joinMeetingBT);
//            make.left.mas_equalTo(self.view.mas_left).priority(300);
            make.height.mas_equalTo(20);
    }];
    
//    if ([self.cloudVersion.online_experience boolValue]) {
//        [self.view addSubview:_onlineBT];
//        [_onlineBT mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(button.mas_bottom).offset(15);
//            make.width.mas_equalTo(screen_width/arrCount);
//            make.right.mas_equalTo(0);
//            make.height.mas_equalTo(20);
//        }];
//
//    }else {
//        [_onlineBT removeFromSuperview];
////        [_onlineBT mas_remakeConstraints:^(MASConstraintMaker *make) {
////            make.top.mas_equalTo(button.mas_bottom).offset(15);
////            make.width.mas_equalTo(0);
////            make.right.mas_equalTo(0);
////            make.height.mas_equalTo(20);
////        }];
//    }
    _agreementLab = [[UILabel alloc] init];
    _agreementLab.adjustsFontSizeToFitWidth = YES;
    _agreementLab.textColor = GrayPromptTextColor;
    _agreementLab.font = FontRegularName(12);
    [self.view addSubview:_agreementLab];
    __weak typeof (self)weakSelf = self;
    [_agreementLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-(10 + BottomSaveH));
        make.width.lessThanOrEqualTo(weakSelf.view.mas_width).offset(-20.0);
    }];
    
    NSString *privateStr = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
    NSString *agreeStr = SIMLocalizedString(@"KHBseverceAndListClick", nil);
    NSString *allStr = [NSString stringWithFormat:SIMLocalizedString(@"KHBPrivateAgreementTitle", nil),privateStr,agreeStr];
    NSMutableAttributedString *atstring = [[NSMutableAttributedString alloc] initWithString:allStr];
    
    NSRange range1 = [allStr rangeOfString:privateStr];
    [atstring addAttribute:NSForegroundColorAttributeName value:BlueButtonColor range:range1];
    
    NSRange range2 = [allStr rangeOfString:agreeStr];
    [atstring addAttribute:NSForegroundColorAttributeName value:BlueButtonColor range:range2];
    
    _agreementLab.attributedText = atstring;
    
    [_agreementLab yb_addAttributeTapActionWithStrings:@[privateStr,agreeStr] tapClicked:^(UILabel *label, NSString *string, NSRange range, NSInteger index) {
        if (index == 0) {
            // 跳到隐私政策
            SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
            UIViewController* navVC = [webVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            navVC.modalPresentationStyle = UIModalPresentationFullScreen;
            webVC.isPresent = YES;
            webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListPrivateClick", nil);
            webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.privacy_path];
            [self presentViewController:navVC animated:YES completion:nil];
        }else {
            // 跳到用户协议
            SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
            UIViewController* navVC = [webVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
            navVC.modalPresentationStyle = UIModalPresentationFullScreen;
            webVC.isPresent = YES;
            webVC.navigationItem.title = SIMLocalizedString(@"KHBseverceAndListClick", nil);
            webVC.webStr = [NSString stringWithFormat:@"%@%@",kApiBaseUrl,self.cloudVersion.terms_path];
            [self presentViewController:navVC animated:YES completion:nil];
        }
    }];
    
}

#pragma mark -- Events
- (void)loginClickMethod {
    
//    if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
//        // 私有 判断私有 因为私有界面特殊 其余情况全部正常界面
//        UIViewController* loginNavigationViewController = [[[SIMLoginViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//        loginNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:loginNavigationViewController animated:YES completion:nil];
//    }else {
        // 公有
        UIViewController *loginNavigationViewController = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
        loginNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:loginNavigationViewController animated:YES completion:nil];
//    }
    
}
- (void)registerClickMethod {
    UIViewController* registerNVC = [[[SIMRegisterViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
    registerNVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [windowRootViewController presentViewController:registerNVC animated:YES completion:nil];
}
- (void)joinClickMethod {
    SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
    UIViewController* joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
    joinVC.isLive = NO;
    joinVC.navigationItem.title = SIMLocalizedString(@"MJoinTheMeeting", nil);
    joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [windowRootViewController presentViewController:joinMeetingNaviVC animated:YES completion:nil];
}
- (void)setClickMethod {
//    SIMNetSettingViewController *netVC = [[SIMNetSettingViewController alloc] init];
//    UIViewController* registerNavigationViewController = [netVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//    registerNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
//    [windowRootViewController presentViewController:registerNavigationViewController animated:YES completion:nil];
//    __weak typeof(self) weakSelf = self;
//    netVC.refreshClick = ^{
//        [weakSelf addUIMasnory]; // 因为私有云会调整界面视图
//    };
    
    if ([self.cloudVersion.cloud_server boolValue]) {
        SIMAppSettingViewController *appsetVC = [[SIMAppSettingViewController alloc] init];
        UIViewController* appSetNavVC = [appsetVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
        appSetNavVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [windowRootViewController presentViewController:appSetNavVC animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        appsetVC.refreshClick = ^{
            [weakSelf addUIMasnory]; // 因为私有云会调整界面视图
        };
    }else {
        SIMNetSettingViewController *netVC = [[SIMNetSettingViewController alloc] init];
        UIViewController* netNavigationViewController = [netVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
        netNavigationViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [windowRootViewController presentViewController:netNavigationViewController animated:YES completion:nil];
        __weak typeof(self) weakSelf = self;
        netVC.refreshClick = ^{
            [weakSelf addUIMasnory]; // 因为私有云会调整界面视图
        };
        
    }
    
}
- (void)onlineClickMethod {

    SIMJoinMeetingViewController *joinVC = [[SIMJoinMeetingViewController alloc] init];
    UIViewController* joinMeetingNaviVC = [joinVC sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
    joinVC.isLive = NO;
    joinVC.testCidRoom = @"888888888";
    joinVC.navigationItem.title = SIMLocalizedString(@"OnlineLearn", nil);
     joinMeetingNaviVC.modalPresentationStyle = UIModalPresentationFullScreen;
    [windowRootViewController presentViewController:joinMeetingNaviVC animated:YES  completion:nil];
}
#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _pageController.currentPage = currentPage;
}
#pragma mark - UITextFieldClick
- (void)textFieldDidChange:(UITextField *)textField
{
    // 如果不输入名字那么不可以进入会议室
    if (textField == userEmail) {
        if (textField.text.length <= 0) {
            okAction.enabled = NO;
        }else {
            okAction.enabled = YES;
        }
        [self subStringAllMethod:textField withLength:kMinLength];
    }
}
#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    if (![string isEqualToString:tem]) {
        return NO;
    }
    return YES;
}

- (void)postToEnterTheConfID:(NSString *)cidStr psw:(NSString *)pswStr {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:SIMLocalizedString(@"InputYourMeetName", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = SIMLocalizedString(@"PlaceHolderInputYourMeetName", nil);
    }];
    
    // 创建操作
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // 读取文本框的值显示出来
        NSArray *array=[alertController textFields];
        UITextField *userEmail=array[0];

        [SIMNewEnterConfTool quickEnterTheMineConfWithCid:cidStr psw:pswStr name:userEmail.text confType:EnterConfTypeConf viewController:self];
    }];
        
    [alertController addAction:okAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


@end

