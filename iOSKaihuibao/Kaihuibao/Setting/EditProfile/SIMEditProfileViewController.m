//
//  SIMEditProfileViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMEditProfileViewController.h"

#import "SIMBaseCommonTableViewCell.h"
#import "SIMLoginMainViewController.h"
#import "SIMLoginViewController.h"
#import "SIMEditNameViewController.h"
#import "SIMConfRoomViewController.h"
#import "SIMEntranceViewController.h"
#import "SIMPassWViewController.h"
#import "SIMCompanyNameViewController.h"

#import <Photos/PHPhotoLibrary.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#import "TUIKit.h"

@interface SIMEditProfileViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseCommonTableViewCell* _editAvatarCell;
//    NSArray<NSArray<UITableViewCell*>*>* _cells;
    
    UIButton *_logoutBtn;
    UIImage *imageFace;
//    NSURLSessionDataTask *_task;
}
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) SIMBaseTableView *tableView;
@property (strong, nonatomic) NSMutableArray *cells;
@end

@implementation SIMEditProfileViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareCells];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _cells = [NSMutableArray array];
    self.title = SIMLocalizedString(@"SMineData", nil);
    self.tableView  = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
}
-(void)prepareCells
{
    [_cells removeAllObjects];
    // 头像
    _editAvatarCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataIcon", nil) rightViewImage:[NSURL URLWithString: self.currentUser.avatar]];
    
    // 姓名
    SIMBaseCommonTableViewCell* nicnNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataName", nil) prompt:self.currentUser.nickname];
    nicnNameCell.tag = 1001;
    
    // 公司名
    SIMBaseCommonTableViewCell* companyNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataCompany", nil) prompt:  self.currentUser.currentCompany.company_name];
    companyNameCell.tag = 1002;
    
    // 登录密码
    SIMBaseCommonTableViewCell *arrangeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataPSW", nil)];
    arrangeCell.tag = 1003;
    
    // 注销账号
    SIMBaseCommonTableViewCell* logoutCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SettingLogOutCellTitle", nil) prompt:SIMLocalizedString(@"SettingLogOutCellDetail", nil)];
    logoutCell.tag = 1004;
    
    // 根据开关判断是否可以点击更改
    if (![self.cloudVersion.avatar_update boolValue]) {
        _editAvatarCell.userInteractionEnabled = NO;
        _editAvatarCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (![self.cloudVersion.nickname_update boolValue]) {
        nicnNameCell.userInteractionEnabled = NO;
        nicnNameCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (![self.cloudVersion.companyname_update boolValue]) {
        companyNameCell.userInteractionEnabled = NO;
        companyNameCell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (![self.cloudVersion.update_password boolValue]) {
        arrangeCell.userInteractionEnabled = NO;
        arrangeCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // 个人会议室id
    SIMBaseCommonTableViewCell* idividCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataConfID", nil) prompt:self.currentUser.self_conf];
    idividCell.selectionStyle = UITableViewCellSelectionStyleNone;
    idividCell.accessoryType = UITableViewCellAccessoryNone;
    
    // 根据开关判断是否展示
    if ([self.cloudVersion.avatar_show boolValue]) {
        [_cells addObject:@[_editAvatarCell]];
    }
    NSMutableArray *arr = [NSMutableArray array];
    if ([self.cloudVersion.nickname_show boolValue]) {
        [arr addObject:nicnNameCell];
    }
    if ([self.cloudVersion.companyname_show boolValue]) {
        [arr addObject:companyNameCell];
    }
    if ([self.cloudVersion.update_password boolValue]) {
        [arr addObject:arrangeCell];
    }
    [arr addObject:logoutCell];
    if (arr == nil) {
        [_cells addObject:@[]];
    }else {
        [_cells addObject:arr];
    }
    [_cells addObject:@[idividCell]];
    
}
#pragma mark - TableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 80;
    }else {
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    }else {
        return 20;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 100;
    }else {
        return CGFLOAT_MIN;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section==2)
    {
        UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 100)];
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutBtn setTitle:SIMLocalizedString(@"SLogoutTheApp", nil) forState:UIControlStateNormal];
        
        [_logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_logoutBtn];
        
        [_logoutBtn setTitleColor:RedButtonColor forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:GrayPromptTextColor] forState:UIControlStateHighlighted];
        _logoutBtn.backgroundColor = [UIColor whiteColor];
        _logoutBtn.layer.borderColor = ZJYColorHex(@"#ededed").CGColor;
        _logoutBtn.layer.borderWidth = 1;
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 11;
        
        [_logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(20);
            make.height.mas_equalTo(44);
        }];
        return footerView;
    }else {
        return nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cells[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(indexPath.section ==0)
    {
        //选择头像
        [self addActionSheet];
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = _cells[indexPath.section][indexPath.row];
        NSLog(@"cell.tagcell.tagcell.tag %ld",cell.tag);
        
        if (cell.tag == 1001) {
            // 姓名
            SIMEditNameViewController *edit = [[SIMEditNameViewController alloc] init];
            [self.navigationController pushViewController:edit animated:YES];
        }else if (cell.tag == 1002) {
            // 设置公司
            SIMCompanyNameViewController *pass = [[SIMCompanyNameViewController alloc] init];
            [self.navigationController pushViewController:pass animated:YES];
        }else if (cell.tag == 1003) {
            // 密码
            SIMPassWViewController *pass = [[SIMPassWViewController alloc] init];
            [self.navigationController pushViewController:pass animated:YES];
        }else if (cell.tag == 1004) {
            // 注销账号
            [self addAlertControllerWithTitle:SIMLocalizedString(@"SettingLogOutCellTitle", nil) detailTitle:SIMLocalizedString(@"SettingLogOutCellContent", nil)];
        }
    }
    
}
// 登出按钮
- (void)logoutClick {
    [self addAlertControllerWithTitle:nil detailTitle:SIMLocalizedString(@"SAlreadyLogoutTheApp", nil)];
}

#pragma mark -- UIAlertViewDelegate
// 退出登录提示框
- (void)addAlertControllerWithTitle:(nullable NSString *)string detailTitle:(nullable NSString *)detailTitle {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:string message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCOk", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self logoutRequest];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    [alertC addAction:action3];
    [self presentViewController:alertC animated:YES completion:nil];
}
// 修改头像提示框
- (void)addActionSheet {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action = [UIAlertAction actionWithTitle:SIMLocalizedString(@"STakePhotos", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 拍照
        [self readImageFromCamera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"SChooseAtPicture", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 从相册中读取
        [self readImageFromAlbum];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [action3 setValue:RedButtonColor forKey:@"_titleTextColor"];
    
    [alertC addAction:action];
    [alertC addAction:action2];
    [alertC addAction:action3];
    alertC.popoverPresentationController.sourceView = self.view;
    alertC.popoverPresentationController.sourceRect = _editAvatarCell.frame;
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)readImageFromAlbum {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
        // 没有权限
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Setting_Info_Picture", nil) message:SIMLocalizedString(@"Setting_Info_PictureText", nil) preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //跳入当前App设置界面,
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                }];
            }
        }]];
        [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertView animated:YES completion:nil];
    }else {
        // 已经获取权限
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
            //创建对象
            self.imagePicker = [[UIImagePickerController alloc] init];
            //（选择类型）表示仅仅从相册中选取照片
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            //指定代理
            self.imagePicker.delegate = self;
            //设置在相册选完照片后，是否跳到编辑模式进行图片剪裁。(允许用户编辑)
            self.imagePicker.allowsEditing = YES;
            //显示相册
            self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }
    
}
- (void)readImageFromCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied || authStatus == AVAuthorizationStatusRestricted) {
        // 没有权限
//        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:SIMLocalizedString(@"Setting_Info_Camera", nil)  message:SIMLocalizedString(@"Setting_Info_CameraText", nil) preferredStyle:UIAlertControllerStyleAlert];
            [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCSet", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //跳入当前App设置界面
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if( [[UIApplication sharedApplication]canOpenURL:url] ) {
                    [[UIApplication sharedApplication]openURL:url options:@{}completionHandler:^(BOOL        success) {
                    }];
                }
            }]];
            [alertView addAction:[UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alertView animated:YES completion:nil];
//        });
        
    }else{
        //获取了权限，直接调用相机接口
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            self.imagePicker = [[UIImagePickerController alloc] init];
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.delegate = self;
            self.imagePicker.allowsEditing = YES; //允许用户编辑
//            self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"Setting_NO_Camera", nil)];
            
        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    imageFace = [info objectForKey:UIImagePickerControllerEditedImage];
    // 上传图片到服务器
    [self changeAvatarPicture:imageFace];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
/** 修改头像*/
- (void)changeAvatarPicture:(UIImage *)image {
    [MainNetworkRequest sendMyHeaderPicRequestParams:nil bodys:^(id bodys) {
        [MBProgressHUD cc_showLoading:nil];// 正在加载框
        
        NSData *data = UIImageJPEGRepresentation(image, 0.3);
        [bodys appendPartWithFileData:data name:@"file" fileName:@"file.jpeg" mimeType:@"multipart/form-data"];
       
    } progress:^(id progress) {
        
    } success:^(id success) {
        [MBProgressHUD cc_showSuccess:success[@"msg"]];
        if ([success[@"code"] integerValue] == successCodeOK) {
            
            NSDictionary *dd = success[@"data"];
            NSString *pathface = dd[@"url"];
            // 以后拼接这个路径 拿设置的头像 转化字符串目的是加入到user类中
            NSString *urlString = kApiBaseUrl;
            
            NSString *pathFace = [NSString stringWithFormat:@"%@/%@",urlString,pathface];
             self.currentUser.avatar = pathFace;
            [self.currentUser synchroinzeCurrentUser];
            
            NSLog(@"nowface1++%@", self.currentUser.avatar);
            
            [_editAvatarCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString: self.currentUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
            [self.tableView reloadData];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

// 退出登录网络请求
- (void)logoutRequest {
    [MBProgressHUD cc_showLoading:nil];
    // 登出  现在做的是不管成功与否都 回到登录界面 防止切换了服务器啥的导致没法收到接口回调退步出去和web同步协定改的
    [MainNetworkRequest logoutRequestParams:@{} success:^(id success) {
        NSLog(@"logoutResult %@",success[@"msg"]);
        
    } failure:^(id failure) {
//        [self logoutRequestAfter];
    }];
    __weak typeof(self)weakSelf = self;
    
    [[TUIKit sharedInstance] logoutKit:^{
        NSLog(@"logout succ");
        [weakSelf logoutRequestAfter];
    } fail:^(int code, NSString *msg) {
        [weakSelf logoutRequestAfter];
        NSLog(@"logout fail: code=%d err=%@", code, msg);
    }];
    
}
// 退出登录网络请求 之后的操作
- (void)logoutRequestAfter {
    self.currentUser.currentCompany = [SIMCompany new];
    self.currentUser = [CCUser new]; // 释放主用户对象
    self.currentCompany = [SIMCompany new];// 释放公司模型
    [self.currentCompany synchroinzeCurrentCompany];
    [self.currentUser synchroinzeCurrentUser];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userToken"]; // 立即清token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYCONF"];// 清空我的会议室model
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"MYLIVE"];// 清空我的直播间model
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanName"]; // 当前的会议计划名称
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentPlanID"]; // 当前的会议计划名称
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginConfServerSuccess"];// 登录服务器的状态记录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"IsHaveAdressBook"]; // 是否传了通讯录
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"showTheWechat"];// 是否上线显示微信
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"OneConfServerAdress"]; // 链接入会一次性地址 也要删掉 防止链接唤起app被挤掉线
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    [[NSNotificationCenter defaultCenter] bk_removeAllBlockObservers];
    
    [MainNetworkRequest cancelAllRequest];
    
    // 注意！！延时是为了 开会中 账号互踢 被踢出会议时sdk先给的被踢回调 收到被踢就会调用下面的登录界面 之后sdk才走的退会 不退会没法释放当前VC  所以延时2秒 让sdk先释放VC
    [SIMNewEnterConfTool exitTheConf];
//    [self.navigationController dismissViewControllerAnimated:NO completion:^{}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 且根视图 返回登录页
        [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
        
        UIViewController *loginNavigationViewController = [[SIMEntranceViewController alloc] init];
        windowRootViewController = loginNavigationViewController;
        
//        if ([self.cloudVersion.version isEqualToString:@"privatization"]) {
//            // 私有 判断私有 因为私有界面特殊 其余情况全部正常界面
//            UIViewController *loginVC = [[[SIMLoginViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [loginNavigationViewController presentViewController:loginVC animated:YES completion:nil];
//        }else {
//            // 公有
//            UIViewController *loginVC = [[[SIMLoginMainViewController alloc] init] sim_wrappedByNavigationViewControllerClass:[SIMBaseWhiteNavigationViewController class]];
//            loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//            loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [loginNavigationViewController presentViewController:loginVC animated:YES completion:nil];
//        }
        
    });
}


//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [_task cancel];
//}



@end
