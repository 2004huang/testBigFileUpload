//
//  SIMEditCompanyViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/28.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMEditCompanyViewController.h"

#import "SIMBaseCommonTableViewCell.h"
#import "SIMConfRoomViewController.h"
#import "SIMMyConf.h"

@interface SIMEditCompanyViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,SIMConfRoomViewdelegate>
{
    SIMBaseCommonTableViewCell * _confIDCell;
    SIMBaseCommonTableViewCell * _confNameCell;
    SIMBaseCommonTableViewCell *_passwordCell;
//    SIMBaseCommonTableViewCell *_mainPSWCell;
    
    NSArray<NSArray<UITableViewCell*>*>* _cells;
    BOOL editBtnOnce;
}
@property (nonatomic,strong) SIMBaseTableView* tableView;

@end

@implementation SIMEditCompanyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@会议室",  self.currentUser.currentCompany.company_name];
    
    [self setUpCells];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    [self.view addSubview:self.tableView];
    
}
- (void)setUpCells
{
    // 为字符串加“-”进行分割
    NSString *idStr = SIMLocalizedString(@"MEMineConfID", nil);
    NSString *nameStr = SIMLocalizedString(@"MEMineConfName", nil);
    NSString *pswStr = SIMLocalizedString(@"MEMineConfPSW", nil);

    _confIDCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:idStr prompt:[NSString transTheConfIDToTheThreeApart:self.currentUser.currentCompany.company_conf]];
    _confIDCell.accessoryType = UITableViewCellAccessoryNone;
    _confIDCell.userInteractionEnabled = NO;
    
    
    _confNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:nameStr prompt:[NSString stringWithFormat:@"%@会议室",  self.currentUser.currentCompany.company_name]];
    _confNameCell.accessoryType = UITableViewCellAccessoryNone;
    _confNameCell.userInteractionEnabled = NO;
    
    
    _passwordCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:pswStr prompt: self.currentUser.currentCompany.normal_password];// 待选择作为变量
    _passwordCell.accessoryType = UITableViewCellAccessoryNone;
    _passwordCell.userInteractionEnabled = NO;
    
//
//    _mainPSWCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"MEMineConfMainPSW", nil) putin:nil];
//    _mainPSWCell.putin.placeholder = @"abcd";
//    _mainPSWCell.putin.delegate=self;
//    _mainPSWCell.putin.keyboardType =  UIKeyboardTypeASCIICapable;
//    [_mainPSWCell.putin addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _cells = @[@[_confIDCell,_confNameCell],@[_passwordCell]];
}

#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }else {
        return 20;
    }
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

@end
