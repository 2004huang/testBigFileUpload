//
//  SIMManTranslationController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/15.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMManTranslationController.h"
#import "SIMTeacherCollectionCell.h"
#import "SIMInterpreter.h"
#import "SIMManTransDetailViewController.h"
@interface SIMManTranslationController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) NSString *identStr;
@property (nonatomic, strong) UICollectionView *collectionV;
@property (nonatomic, strong) UIButton *searchNavBtn;
@end

@implementation SIMManTranslationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mutArray = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"译员认证" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    if (self.serial == 5035) {
//        self.identStr = @"105";
//        self.navigationItem.title = @"行业大咖";
//    }else if (self.serial == 5036) {
//        self.identStr = @"103";
//    }else if (self.serial == 5039) { // 现在这个5039是英语流利说 但是这个102是原来微律师的 微律师去掉了暂用
//        self.identStr = @"102";
//        self.navigationItem.title = SIMLocalizedString(@"TabBarFindTitle", nil);
        
//    }else if (self.serial == 5038) {
//        self.identStr = @"104";
//        self.navigationItem.title = @"微医";
//    }else {
//        self.identStr = @"101";
//        self.navigationItem.title = @"管理助手";
//    }
    
    [self requestInterpreterList];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpViews];
}
// 添加导航上的搜索按钮
- (void)addSearchNavView {
    _searchNavBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidthScale(50), 7, screen_width - kWidthScale(100), 30)];
    _searchNavBtn.layer.cornerRadius = 15;
    _searchNavBtn.layer.masksToBounds = YES;
    _searchNavBtn.titleLabel.font = FontRegularName(14);

    [_searchNavBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _searchNavBtn;
}
- (void)searchBtnClick {
//    SIMNFSearchMainController *searchMainVC = [[SIMNFSearchMainController alloc] init];
//    [self.navigationController pushViewController:searchMainVC animated:NO];
}
- (void)rightBtnClick {
    SIMManTransDetailViewController *classVC = [[SIMManTransDetailViewController alloc] init];
    [self.navigationController pushViewController:classVC animated:YES];
}

- (void)setUpViews {
    NSInteger itemCount = 3;
    CGFloat itemSpace = (screen_width - 120 * itemCount) / 6;
    NSLog(@"itemSpace itemSpace %lf",itemSpace);
//    NSInteger itemCount = screen_width/125;
//    CGFloat itemSpace = ((NSInteger)screen_width % 125)/itemCount;
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc] init];
    flow.itemSize = CGSizeMake(120, 145);
    flow.minimumLineSpacing = 1;
    flow.minimumInteritemSpacing = itemSpace*2;
    flow.sectionInset = UIEdgeInsetsMake(0, itemSpace, 0, itemSpace);

    
    _collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) collectionViewLayout:flow];
    _collectionV.backgroundColor = [UIColor whiteColor];
    _collectionV.delegate = self;
    _collectionV.dataSource = self;
    _collectionV.bounces = NO;
    [self.view addSubview:self.collectionV];
    [_collectionV registerClass:[SIMTeacherCollectionCell class] forCellWithReuseIdentifier:@"SIMTeacherCollectionCell"];
    
}

#pragma mark UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mutArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SIMTeacherCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SIMTeacherCollectionCell" forIndexPath:indexPath];
    SIMInterpreter *model = _mutArray[indexPath.item];
    cell.contants = model;
//    cell.imageStr = model.face;
//    cell.countryStr = model.nickname;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath.item %ld",indexPath.item);
//    SIMManTransDetailViewController *classVC = [[SIMManTransDetailViewController alloc] init];
//    [self.navigationController pushViewController:classVC animated:YES];
}

//// 请求我的联系人列表
//- (void)requestUserList {
//    [MainNetworkRequest manageAssisRequestParams:nil success:^(id success) {
//        NSLog(@"manageTeacherListsuccess %@",success);
//        if ([success[@"code"] integerValue] == successCodeOK) {
//            [_mutArray removeAllObjects];
//            for (NSDictionary *dic in success[@"data"]) {
//                SIMContants *cont = [[SIMContants alloc] initWithDictionary:dic];
//                [_mutArray addObject:cont];
//            }
//            [self.collectionV reloadData];
//        }else {
//            [MBProgressHUD cc_showText:success[@"msg"]];
//        }
//    } failure:^(id failure) {
//        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
//    }];
//}

// 请求同声传译列表
- (void)requestInterpreterList {
    [MainNetworkRequest interpreterListRequestParams:nil success:^(id success) {
        NSLog(@"interpreterListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_mutArray removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMInterpreter *cont = [[SIMInterpreter alloc] initWithDictionary:dic];
                [_mutArray addObject:cont];
            }
            [self.collectionV reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
@end
