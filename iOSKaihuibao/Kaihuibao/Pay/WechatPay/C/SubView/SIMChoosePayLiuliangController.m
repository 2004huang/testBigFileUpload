//
//  SIMChoosePayLiuliangController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMChoosePayLiuliangController.h"
#import "SIMPayLiuLiangCell.h"
#import "SIMPayTypeChooseCell.h"

@interface SIMChoosePayLiuliangController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger current;// 记录分区为0里 选中那个单元格
}
@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) UIButton* gotoBuy;
@end
static NSString *liuCell = @"SIMPayLiuLiangCell";
static NSString *typeCell = @"SIMPayTypeChooseCell";

@implementation SIMChoosePayLiuliangController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"NPayBuyLiuLiang_title", nil);
    [self initSubTableView];
}
- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = TableViewBackgroundColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.estimatedRowHeight = 60;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMPayLiuLiangCell class] forCellReuseIdentifier:liuCell];
    [self.tableView registerClass:[SIMPayTypeChooseCell class] forCellReuseIdentifier:typeCell];
    
    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:SIMLocalizedString(@"NPayMain_NextBnt", nil) forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightRedButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = RedButtonColor;
    _gotoBuy.titleLabel.font = FontRegularName(18);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 45/4;
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH+5));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
    
}
#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40.0;
    }else {
        return 10.0;
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return SIMLocalizedString(@"NPayBuyLiuLiang_TypeName", nil);
    }else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ) {
        return 1;
    }else {
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else {
        return 55;
    }
}
//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SIMPayLiuLiangCell *conCell = [tableView dequeueReusableCellWithIdentifier:liuCell];
        return conCell;
    }else if (indexPath.section == 1) {
        NSArray *aa = @[SIMLocalizedString(@"NPayBuyLiuLiang_TypeWechat", nil)];
        SIMPayTypeChooseCell *selectCell = [tableView dequeueReusableCellWithIdentifier:typeCell];
        selectCell.labText = aa[indexPath.row];
        if (current==indexPath.row) {
            selectCell.isSelect = YES;
        }else {
            selectCell.isSelect = NO;
        }
        return selectCell;
    }else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        current = indexPath.row;
        [self.tableView reloadData];
    }
}

@end
