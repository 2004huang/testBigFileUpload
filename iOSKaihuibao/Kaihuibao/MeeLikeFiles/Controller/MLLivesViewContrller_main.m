//
//  MLLivesViewContrller_main.m
//  MeeLike
//
//  Created by mac126 on 2020/9/16.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "MLLivesViewContrller_main.h"
#import "NSString+Helper.h"
#import "MLLivesTableCell_main.h"
#import "MLLivesView_TimeSelect.h"
#import "MLLivesEngine_mian.h"
#import "MBProgressHUD.h"

@interface MLLivesViewContrller_main ()<UITableViewDelegate,UITableViewDataSource,MLLivesView_TimeSelectDelegate>

@property (nonatomic, strong)MLLivesView_TimeSelect * dateHeadView;
@property (nonatomic, strong)UITableView * mtableView;
@property (nonatomic, strong)NSMutableArray * mArray;

@end

@implementation MLLivesViewContrller_main

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播列表";
    [self creatUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - public methods

#pragma mark - private methods

-(void)creatUI{
    [self.view addSubview:self.dateHeadView];
    [self.view addSubview:self.mtableView];
    
    __weak typeof(self) weakself = self;
    [self.dateHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.view.top);
        make.width.mas_equalTo(weakself.view.mas_width);
        make.height.mas_equalTo(kWidthScale(80.0));
    }];
    
    [self.mtableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.dateHeadView.mas_bottom);
        make.width.mas_equalTo(weakself.view.mas_width);
        make.bottom.mas_equalTo(weakself.view.mas_bottom);
    }];
}

-(void)loadData{
    [MLLivesEngine_mian toGetLivesClassCallBack:^(BOOL succeed, NSString * _Nonnull info, id  _Nonnull responseData) {
        if (succeed) {
//            NSArray * array = (NSArray *)responseData;
//            [self.mArray addObjectsFromArray:array];
            self.mArray = (NSMutableArray *)responseData;
            [self.dateHeadView uploadWithArray:self.mArray];
        }else{
            [MBProgressHUD cc_showText:info];
        }
    }];
}

#pragma mark - delegate

-(void)livesSelectDate:(id)date{
    [self loadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *idenfiter = @"MLLivesTableCell_main";
    MLLivesTableCell_main *cell = [tableView dequeueReusableCellWithIdentifier:idenfiter];
    if (cell == nil) {
        cell = [[MLLivesTableCell_main alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfiter];
    }
    cell.model = [[MLLivesModel_main alloc]init];
    cell.didClickAtIndex = ^(MLLivesModel_main * _Nonnull model) {
        //jump to
    };
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWidthScale(155.0);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index.row=%ld",(long)indexPath.row);
}

#pragma mark - selector

#pragma mark - getters and setters

-(MLLivesView_TimeSelect *)dateHeadView{
    if (!_dateHeadView) {
        _dateHeadView = [[MLLivesView_TimeSelect alloc]initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(80))];
        _dateHeadView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _dateHeadView.delegate = self;
    }
    return _dateHeadView;
}

- (UITableView *)mtableView{
    if (!_mtableView) {
        _mtableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _mtableView.delegate = self;
        _mtableView.dataSource = self;
        _mtableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _mtableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _mtableView;
}

-(NSMutableArray *)mArray{
    if (!_mArray) {
        _mArray = [NSMutableArray array];
    }
    return _mArray;
}

@end
