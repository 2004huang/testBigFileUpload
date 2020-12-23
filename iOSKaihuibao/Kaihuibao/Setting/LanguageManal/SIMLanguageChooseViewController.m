//
//  SIMLanguageChooseViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/5/22.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMLanguageChooseViewController.h"
#import "SIMEntranceViewController.h"

@interface SIMLanguageChooseViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_arr;
    NSInteger current; // 记录当前选中的值
    
}
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,assign) BOOL isClickChanges;
@end

@implementation SIMLanguageChooseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _isClickChanges = NO;
    self.title = SIMLocalizedString(@"SLanguages", nil);
    
//    _arr = @[@{@"type":@"followSystem",@"name":@"系统语言"},
//    @{@"type":@"zh-Hans",@"name":@"简体中文"},
//     @{@"type":@"zh-Hant",@"name":@"繁体中文"},
//    @{@"type":@"en",@"name":@"English"},
//    @{@"type":@"ja",@"name":@"Japanese"}];
    _arr = [SIMInternationalController getLanguageArr];
    
//    arr = @[@"系统语言",@"简体中文",@"繁体中文",@"English",@"Japanese"];
    
    // 从本地拿用户选了哪个（ 因为没有后台参与 并且需要用户手动选择语言而不是仅仅跟随系统）
    NSString *currentLang = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];
    for (int i = 0; i < _arr.count; i++) {
        NSDictionary *dic = _arr[i];
        if ([[dic objectForKey:@"type"] isEqualToString:currentLang]) {
            current = i;
            break ;
        }
    }
//    NSString *lll = [[NSUserDefaults standardUserDefaults] objectForKey:kLanguage];
//    if ([lll isEqualToString:@"ja"]) {
//        current = 4;
//    }else if ([lll isEqualToString:@"en"]) {
//        current = 3;
//    }else if ([lll isEqualToString:@"zh-Hant"]) {
//        current = 2;
//    }else if ([lll isEqualToString:@"zh-Hans"]) {
//        current = 1;
//    }else {
//        current = 0;
//    }
    
    
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    back.imageInsets = UIEdgeInsetsMake(0, -10,0, 0);
    self.navigationItem.leftBarButtonItem = back;
}
- (void)backClick {
    if ([self.pageType isEqualToString:@"unlog"]) {
        // 判断是否进行了更改 如果没更改直接返回
        if (_isClickChanges == YES) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                SIMEntranceViewController *entanceVC = [[SIMEntranceViewController alloc] init];
                delegate.window.rootViewController = entanceVC;
            }];
            
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
        // 判断是否进行了更改 如果没更改直接返回
        if (_isClickChanges == YES) {
            // 返回的时候 重新刷新所有的tabbar控制器
            [SIMInternationalController resetRootViewController];
        }
    }
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.textLabel.font = FontRegularName(16);
    cell.textLabel.textColor = BlackTextColor;
    cell.textLabel.text = [_arr[indexPath.row] objectForKey:@"name"];
//    _arr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    current = indexPath.row;
    [self.tableView reloadData];
    _isClickChanges = YES;
    [SIMInternationalController setUserLanguage:[_arr[indexPath.row] objectForKey:@"type"]];
//    if (indexPath.row == 0) {
////        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kLanguage];
//        [SIMInternationalController setUserLanguage:@"followSystem"];
////        [SIMInternationalController initUserLanguage]; //初始化应用语言
//    }else if (indexPath.row == 1) {
//        // 简体中文
//        [SIMInternationalController setUserLanguage:@"zh-Hans"];
//    }else if (indexPath.row == 2) {
//        // 繁体中文
//        [SIMInternationalController setUserLanguage:@"zh-Hant"];
//    }else if (indexPath.row == 3) {
//        //英文
//        [SIMInternationalController setUserLanguage:@"en"];
//    }else if (indexPath.row == 4) {
//        //日语
//        [SIMInternationalController setUserLanguage:@"ja"];
//    }
    [self reInitUI];   // 刷新当前页面的UI
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (current==indexPath.row) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}

- (void)reInitUI {
    self.title = SIMLocalizedString(@"SLanguages", nil);
    [self.tableView reloadData];
}


@end
