//
//  SIMMessNotifListViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/10/29.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMMessNotifListViewController.h"
#import "SIMMessNotifDetailTableViewCell.h"
#import "SIMMessNotiModel.h"
#import "SIMTempCompanyViewController.h"
#import "SIMNewMainPayViewController.h"

@interface SIMMessNotifListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (nonatomic, strong) NSMutableArray *messlistArr;
@property (strong,nonatomic) UIButton* gotoBuy;

@end

@implementation SIMMessNotifListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _messlistArr = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.classification_id == nil) {
        [self addListDatas];
    }else {
        [self addDatas];
    }
    
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    [self.tableView registerClass:[SIMMessNotifDetailTableViewCell class] forCellReuseIdentifier:@"SIMMessNotifDetailTableViewCell"];
    [self.view addSubview:self.tableView];
    
//    if (self.classification_id == nil) {
//        UIButton *gotoBuy = [[UIButton alloc] init];
//        [gotoBuy setTitle:SIMLocalizedString(@"WellBeingBottomTitle", nil) forState:UIControlStateNormal];
//        [gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
//        [gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
//        gotoBuy.backgroundColor = BlueButtonColor;
//        gotoBuy.titleLabel.font = FontRegularName(18);
//        gotoBuy.layer.masksToBounds = YES;
//        gotoBuy.layer.cornerRadius = 45/4;
//        [gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:gotoBuy];
//        [gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH + 15));
//            make.left.mas_equalTo(15);
//            make.height.mas_equalTo(45);
//            make.right.mas_equalTo(-15);
//        }];
//    }
    
    if (self.isConfVC) {
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
        self.navigationItem.leftBarButtonItem = backBtn;
    }
}
- (void)backClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 13;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _messlistArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMMessNotifDetailTableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMMessNotifDetailTableViewCell"];
    commonCell.model = _messlistArr[indexPath.row];
    return commonCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 跳转到链接页面
    SIMMessNotiDetailModel *model = _messlistArr[indexPath.row];
    SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
    webVC.model = model;
    webVC.hasShare = YES;
    webVC.navigationItem.title = model.title;
    NSString *allurl = [NSString stringWithFormat:@"%@%@",model.url,model.message_id];
    NSLog(@"allurlallurl %@",allurl);
    webVC.webStr = allurl;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)addDatas {
    if (self.isCloudSpace) {
        [MainNetworkRequest cloudspaceDetailRequestParams:@{@"spaceclass_id":self.classification_id} success:^(id success) {
            NSLog(@"cloudSpaceDetailList %@ %@",success,self.classification_id);
            if ([success[@"code"] integerValue] == successCodeOK) {
                for (NSDictionary *dic in success[@"data"]) {
                    SIMMessNotiDetailModel *model = [[SIMMessNotiDetailModel alloc] initWithDictionary:dic];
                    [_messlistArr addObject:model];
                }
                [_tableView reloadData];
                
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }else {
        [MainNetworkRequest messageDetailListRequestParams:@{@"classification_id":self.classification_id} success:^(id success) {
            NSLog(@"messageDetailList %@",success);
            if ([success[@"code"] integerValue] == successCodeOK) {
                for (NSDictionary *dic in success[@"data"]) {
                    SIMMessNotiDetailModel *model = [[SIMMessNotiDetailModel alloc] initWithDictionary:dic];
                    [_messlistArr addObject:model];
                }
                [_tableView reloadData];
                
            }else {
                [MBProgressHUD cc_showText:success[@"msg"]];
            }
        } failure:^(id failure) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
        }];
    }
    
}
- (void)addListDatas {
    [MainNetworkRequest homeMessageRequestParams:nil success:^(id success) {
        NSLog(@"messageDetailListList %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            for (NSDictionary *dic in success[@"data"]) {
                SIMMessNotiDetailModel *model = [[SIMMessNotiDetailModel alloc] initWithDictionary:dic];
                [_messlistArr addObject:model];
            }
            [_tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

//- (void)gotoBuythegood {
//    SIMNewMainPayViewController *planVC = [[SIMNewMainPayViewController alloc] init];
//    [self.navigationController pushViewController:planVC animated:YES];
//}
@end
