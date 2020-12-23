//
//  SIMMineDetailTable.m
//  Kaihuibao
//
//  Created by mac126 on 2019/1/7.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMMineDetailTable.h"
#import "SIMBaseCommonTableViewCell.h"

@interface SIMMineDetailTable()<UITableViewDelegate,UITableViewDataSource>
{
    SIMBaseCommonTableViewCell* _editAvatarCell;
    NSArray<NSArray*>* _cells;
    UIButton *_logoutBtn;
}
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIButton *settingBtn;
@end

@implementation SIMMineDetailTable
- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        _cells = @[@[SIMLocalizedString(@"SMineDataName", nil),SIMLocalizedString(@"SMineDataCompany", nil),SIMLocalizedString(@"SMineDataPSW", nil)],@[SIMLocalizedString(@"SMineDataConfID", nil)]];
        [self prepareCells];
        self.tableView  = [[SIMBaseTableView alloc] initInViewController:self];
        [self addSubview:self.tableView];
    }return self;
}

-(void)prepareCells
{
    _editAvatarCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataIcon", nil) rightViewImage:[NSURL URLWithString: self.currentUser.avatar]];
    
    SIMBaseCommonTableViewCell* nicnNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataName", nil) prompt:self.currentUser.nickname];
    SIMBaseCommonTableViewCell* companyNameCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataCompany", nil) prompt:  self.currentUser.currentCompany.company_name];
    SIMBaseCommonTableViewCell *arrangeCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataPSW", nil)];
    
    SIMBaseCommonTableViewCell* idividCell = [[SIMBaseCommonTableViewCell alloc] initWithTitle:SIMLocalizedString(@"SMineDataConfID", nil) prompt:self.currentUser.self_conf];
    idividCell.selectionStyle = UITableViewCellSelectionStyleNone;
    idividCell.accessoryType = UITableViewCellAccessoryNone;
    
    _cells = @[@[_editAvatarCell],@[nicnNameCell,companyNameCell,arrangeCell],@[idividCell]];
    //    [self.tableView reloadData];
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
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
        [_logoutBtn setBackgroundImage:[UIImage imageWithColor:HightLightRedButtonColor] forState:UIControlStateHighlighted];
        
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = 11;
        _logoutBtn.backgroundColor = RedButtonColor;
        [_logoutBtn addTarget:self action:@selector(logoutClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_logoutBtn];
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
    return _cells[section].count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _cells[indexPath.section][indexPath.row];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.indexBlock) {
        self.indexBlock(indexPath.section, indexPath.row);
    }
}

- (void)logoutClick {
    if (self.logoutBtnClick) {
        self.logoutBtnClick();
    }
}

@end
