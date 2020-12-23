//
//  SIMMessageEditViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMMessageEditViewController.h"
#import "SIMBaseSwitchTableViewCell.h"
@interface SIMMessageEditViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseSwitchTableViewCell* _messageCell;
    SIMBaseSwitchTableViewCell* _vibrateCell;
    SIMBaseSwitchTableViewCell* _voiceCell;
    SIMBaseSwitchTableViewCell* _leaveCell;

    NSArray<NSArray<UITableViewCell*>*>* _cells;
    BOOL saveBtnOnce;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;

@end

@implementation SIMMessageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SMessageNotify", nil);
    saveBtnOnce = YES;
    
    [self setUpCells];
    
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
    

}
- (void)setUpCells
{
    _messageCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _messageCell.titleLab.text = SIMLocalizedString(@"STakeOnMessNotify", nil);
//    if (!self.currentUser) {
//        _messageCell.switchButton.on = YES;
    _messageCell.userInteractionEnabled = NO;
    _messageCell.titleLab.textColor = GrayPromptTextColor;
    _messageCell.switchButton.on = NO;
//    }
    
    _vibrateCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _vibrateCell.titleLab.text = SIMLocalizedString(@"STakeOnVibrate", nil);
//    if (!self.currentUser) {
//        _vibrateCell.switchButton.on = YES;
    _vibrateCell.userInteractionEnabled = NO;
    _vibrateCell.titleLab.textColor = GrayPromptTextColor;
    _vibrateCell.switchButton.on = NO;
//    }
    
    _voiceCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _voiceCell.titleLab.text = SIMLocalizedString(@"STakeOnVoice", nil);
//    if (!self.currentUser) {
    _voiceCell.userInteractionEnabled = NO;
    _voiceCell.titleLab.textColor = GrayPromptTextColor;
    _voiceCell.switchButton.on = NO;
//    }
    
    _leaveCell = [[SIMBaseSwitchTableViewCell alloc] init];
    _leaveCell.titleLab.text =SIMLocalizedString(@"SShowLeaveMan", nil);
//    if (!self.currentUser) {
    _leaveCell.userInteractionEnabled = NO;
    _leaveCell.titleLab.textColor = GrayPromptTextColor;
    _leaveCell.switchButton.on = NO;
//    }
    
    _cells = @[@[_messageCell],@[_vibrateCell,_voiceCell],@[_leaveCell]];
//    [self.tableView reloadData];
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cells.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cells[section].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
