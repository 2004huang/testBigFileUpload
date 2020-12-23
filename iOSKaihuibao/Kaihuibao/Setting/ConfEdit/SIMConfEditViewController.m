//
//  SIMConfEditViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMConfEditViewController.h"
#import "SIMBaseSwitchTableViewCell.h"
#import "SIMBaseCommonTableViewCell.h"
#import "SIMRepeatViewController.h"

@interface SIMConfEditViewController ()<UITableViewDelegate,UITableViewDataSource,SIMRepeatViewDelegate>
{
    SIMBaseSwitchTableViewCell* _autoAudioCell;
    SIMBaseSwitchTableViewCell* _autosilentCell;
    SIMBaseSwitchTableViewCell* _unAutoVideoCell;
    SIMBaseSwitchTableViewCell* _confTimeCell;
    SIMBaseSwitchTableViewCell* _beautiCell;
    SIMBaseCommonTableViewCell *_repeatCell;
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    
}
@property (nonatomic, strong) NSArray *repeatArr;
@property (nonatomic,strong) SIMBaseTableView* tableView;
@property (nonatomic,assign) BOOL saveBtnOnce;
@end

@implementation SIMConfEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = SIMLocalizedString(@"SConfSetting", nil);
    _saveBtnOnce = YES;
    
    _repeatArr = @[SIMLocalizedString(@"ConfSettingSharpnessSpeed", nil), SIMLocalizedString(@"ConfSettingSharpnessSmooth", nil), SIMLocalizedString(@"ConfSettingSharpnessClear", nil), SIMLocalizedString(@"ConfSettingSharpnessHD", nil), SIMLocalizedString(@"ConfSettingSharpnessBluelight", nil)];

    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    
    // 点击保存对相应设置上传到服务器
   
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    
    self.navigationItem.leftBarButtonItem = cancel;

}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setUpCells
{
    _autoAudioCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _autoAudioCell.titleLab.text = SIMLocalizedString(@"SAutoOnVoice", nil);
//    _autoAudioCell.switchButton.on = [self.currentUser.audio_auto_link intValue];
    _autoAudioCell.userInteractionEnabled = NO;
    _autoAudioCell.titleLab.textColor = GrayPromptTextColor;
    _autoAudioCell.switchButton.on = NO;
    
    _autosilentCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _autosilentCell.titleLab.text = SIMLocalizedString(@"SAutoSilent", nil);
//    _autosilentCell.switchButton.on = [self.currentUser.auto_silence intValue];
    _autosilentCell.userInteractionEnabled = NO;
    _autosilentCell.titleLab.textColor = GrayPromptTextColor;
    _autosilentCell.switchButton.on = NO;
    
    _unAutoVideoCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _unAutoVideoCell.titleLab.text = SIMLocalizedString(@"SAutoOnCamera", nil);
//    _unAutoVideoCell.switchButton.on = [self.currentUser.auto_camera_on intValue];
    _unAutoVideoCell.userInteractionEnabled = NO;
    _unAutoVideoCell.titleLab.textColor = GrayPromptTextColor;
    _unAutoVideoCell.switchButton.on = NO;
    
    _confTimeCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _confTimeCell.titleLab.text = SIMLocalizedString(@"SShowConfTime", nil);
//    _confTimeCell.switchButton.on = [self.currentUser.show_conf_duration intValue];
    _confTimeCell.userInteractionEnabled = NO;
    _confTimeCell.titleLab.textColor = GrayPromptTextColor;
    _confTimeCell.switchButton.on = NO;
    
    _beautiCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _beautiCell.titleLab.text =SIMLocalizedString(@"SShowBeauty", nil);
//    _beautiCell.switchButton.on = [self.currentUser.beauty_camera intValue];
    _beautiCell.userInteractionEnabled = NO;
    _beautiCell.titleLab.textColor = GrayPromptTextColor;
    _beautiCell.switchButton.on = NO;
    
    NSInteger resolution = [[NSUserDefaults standardUserDefaults] integerForKey:@"confConfig.resolution"];
    _repeatCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"ConfSettingSharpnessTitle", nil) prompt:_repeatArr[resolution]];

//    @[_repeatCell]
    _cells = @[@[_autoAudioCell],@[_autosilentCell,_unAutoVideoCell],@[_confTimeCell],@[_beautiCell]];
//    [self.tableView reloadData];
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 0) {
//        // 点击了选择视频清晰度
//        SIMRepeatViewController *repeatVC = [[SIMRepeatViewController alloc] init];
//        repeatVC.delegate = self;// 遵守代理 重复页面传值
//        repeatVC.arr = _repeatArr;
//        NSInteger resolution = [[NSUserDefaults standardUserDefaults] integerForKey:@"confConfig.resolution"];
//        repeatVC.index = resolution;
//
//        [self.navigationController pushViewController:repeatVC animated:YES];
//    }
}

- (void)postOn {
    // 正在加载框
    [MBProgressHUD cc_showLoading:nil];
    // 将姓名传到服务器 这里转化字符串了 也可以直接包装NSNumber
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] init];
    [dicM setObject:[NSNumber numberWithBool:_autoAudioCell.switchButton.on] forKey:@"audio_auto_link"];
    [dicM setObject:[NSNumber numberWithBool:_autosilentCell.switchButton.on] forKey:@"auto_silence"];
    [dicM setObject:[NSNumber numberWithBool:_unAutoVideoCell.switchButton.on] forKey:@"auto_camera_on"];
    [dicM setObject:[NSNumber numberWithBool:_confTimeCell.switchButton.on] forKey:@"show_conf_duration"];
    [dicM setObject:[NSNumber numberWithBool:_beautiCell.switchButton.on] forKey:@"beauty_camera"];
    [MainNetworkRequest editConfInfoRequestParams:dicM success:^(id success) {
        
        if ([success[@"status"] isEqualToString:@"ok"]) {
            NSLog(@"success+%@",success);
//            self.currentUser.audio_auto_link = [NSString stringWithFormat:@"%d",_autoAudioCell.switchButton.on];
//            self.currentUser.auto_silence = [NSString stringWithFormat:@"%d",_autosilentCell.switchButton.on];
//            self.currentUser.auto_camera_on = [NSString stringWithFormat:@"%d",_unAutoVideoCell.switchButton.on];
//            self.currentUser.show_conf_duration = [NSString stringWithFormat:@"%d",_confTimeCell.switchButton.on];
//            self.currentUser.beauty_camera = [NSString stringWithFormat:@"%d",_beautiCell.switchButton.on];
            
//            [self.currentUser synchroinzeCurrentUser];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        _saveBtnOnce = YES;
    } failure:^(id failure) {
        NSError *error = failure;
        // 取消网络用 如果是取消了 不提示失败的弹框
        if (error.code == -999) {
        }else {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ME_Setting_Fail", nil) ];
            
        }
        _saveBtnOnce = YES;
    }];
    
}
// 点击重复回传值
- (void)inputString:(NSString *)textStr index:(NSInteger)indexTag{
    _repeatCell.promptLabel.text = textStr;
//    [[NSUserDefaults standardUserDefaults] setInteger:indexTag forKey:@"confConfig.resolution"];
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"confConfig.resolution.isset"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [MainNetworkRequest cancelAllRequest];
//}



@end
