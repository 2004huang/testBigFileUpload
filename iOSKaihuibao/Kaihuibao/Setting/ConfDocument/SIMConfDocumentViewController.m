//
//  SIMConfDocumentViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/5.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfDocumentViewController.h"
#import "SIMConfDocListCell.h"
#import "SIMConfDocModel.h"
#import "SIMTempCompanyViewController.h"
#import "SIMConfShorthandViewController.h"
#import "SIMConfDocSearchViewController.h"
#import "SIMCofShorthandModel.h"
#import "SIMCustomFooterView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface SIMConfDocumentViewController ()<UIDocumentPickerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *cellDatas;
@property (nonatomic, strong) UIButton *findBtn;
@property (strong,nonatomic) NSMutableArray *searchResult;
@property(nonatomic,strong) SIMConfDocSearchViewController *mySRTVC;// 展示搜索结果的VC
@property(nonatomic,strong) UISearchController *searchController;// 搜索条
@property(nonatomic,strong) SIMCustomFooterView *headerView;

@end

@implementation SIMConfDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    _cellDatas = [[NSMutableArray alloc] init];
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    if ([self.pageType isEqualToString:@"shorthand"]) {
        self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    }else if ([self.pageType isEqualToString:@"doc"]) {
        self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    }else {
        self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 45);
    }
    
    [self.tableView registerClass:[SIMConfDocListCell class] forCellReuseIdentifier:@"SIMConfDocListCell"];
    [self.view addSubview:self.tableView];
//    [self addSearchBarUI];

    if ([self.pageType isEqualToString:@"shorthand"]) {
        self.title = SIMLocalizedString(@"CloudSpaceMinutesTitle", nil);
        [self getShorthandDatas]; // 请求网络列表数据
    }else if ([self.pageType isEqualToString:@"doc"]) {
        self.title = SIMLocalizedString(@"CloudSpaceDocTitle", nil);
        [self getDatas]; // 请求网络列表数据
        [self addBottomUI];
    }else {
        self.title = @"云空间";
        [self getDatas]; // 请求网络列表数据
        [self addBottomUI];
    }
    
}
- (void)addBottomUI {
    _findBtn = [[UIButton alloc] init];
    [_findBtn setTitle:SIMLocalizedString(@"ConfDocAdd", nil) forState:UIControlStateNormal];
    _findBtn.layer.borderColor = BlueButtonColor.CGColor;
    _findBtn.layer.borderWidth = 1;
    [_findBtn setBackgroundColor:[UIColor whiteColor]];
    [_findBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [_findBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_findBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _findBtn.titleLabel.font = FontRegularName(15);
    _findBtn.layer.masksToBounds = YES;
    _findBtn.layer.cornerRadius = 17;
    [_findBtn addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findBtn];
    [_findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-15);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(43);
        make.width.mas_equalTo(kWidthScale(220));
    }];
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return BottomSaveH;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SIMConfDocListCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMConfDocListCell"];
    if ([self.pageType isEqualToString:@"shorthand"]) {
        commonCell.shortmodel = self.cellDatas[indexPath.row];
    }else {
        commonCell.model = self.cellDatas[indexPath.row];
    }
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.pageType isEqualToString:@"shorthand"]) {
        SIMConfShorthandViewController *confVC = [[SIMConfShorthandViewController alloc] init];
        confVC.model = _cellDatas[indexPath.row];
        [self.navigationController pushViewController:confVC animated:YES];
    }else {
        SIMTempCompanyViewController *webVC = [[SIMTempCompanyViewController alloc] init];
        SIMConfDocModel *model = self.cellDatas[indexPath.row];
        webVC.navigationItem.title = model.name;
        webVC.webStr = model.url;
        [self.navigationController pushViewController:webVC animated:YES];
//        SIMAdvertWebViewController *companyVC = [[SIMAdvertWebViewController alloc] init];
//        companyVC.navigationItem.title = SIMLocalizedString(@"SAbortUSConnect", nil);
//        SIMConfDocModel *model = self.cellDatas[indexPath.row];
//        companyVC.webStr = model.url;
//        [self.navigationController pushViewController:companyVC animated:YES];
    }
    
}
- (void)addSearchBarUI {
    self.mySRTVC = [[SIMConfDocSearchViewController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.mySRTVC];
//    [self.searchController.searchBar sizeToFit];   //大小调整
    _searchController.searchBar.placeholder = SIMLocalizedString(@"CGSearchBarTitle", nil);
    _searchController.searchBar.barTintColor = [UIColor whiteColor];
    _searchController.searchBar.backgroundColor = [UIColor whiteColor];
    UITextField *searchField = [self.searchController.searchBar valueForKey:@"searchField"];
    searchField.textColor = BlackTextColor;
    searchField.font = FontRegularName(16);
    searchField.backgroundColor=ZJYColorHex(@"#ededee");
    // 更改背景颜色并去掉黑线
    UIImageView *barimag = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
    barimag.layer.borderColor = [UIColor whiteColor].CGColor;
    barimag.layer.borderWidth = 1;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //设置搜索控制器的结果更新代理对象
    self.searchController.searchResultsUpdater=self;
    self.searchController.searchBar.delegate=self;
    self.definesPresentationContext=YES;
}
#pragma mark - UISearchResultsUpdating
/**实现更新代理*/
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //获取到用户输入的数据
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *conArr = [[NSMutableArray alloc] init];
    if ([self.pageType isEqualToString:@"shorthand"]) {
        for (SIMCofShorthandModel *model in _cellDatas) {
            if ([model.conf_name.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [conArr addObject:model];
            }
        }
    }else {
        for (SIMConfDocModel *model in _cellDatas) {
            if ([model.name.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [conArr addObject:model];
            }
        }
    }
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.mySRTVC.datas = conArr;
    self.mySRTVC.pageType = self.pageType;
    /**通知结果ViewController进行更新*/
    [self.mySRTVC.tableView reloadData];
    // 修改按钮文字为中文
//    searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [searchController.searchBar subviews])
    {
        for (id zz in [sousuo subviews])
        {
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:SIMLocalizedString(@"AlertCCancel", nil) forState:UIControlStateNormal];
                [btn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
            }
        }
    }
}
- (void)getShorthandDatas {
    [MainNetworkRequest shorthandListRequestParams:nil success:^(id success) {
        NSLog(@"shorthandListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_cellDatas removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMCofShorthandModel *model = [[SIMCofShorthandModel alloc] initWithDictionary:dic];
                [_cellDatas addObject:model];
            }
            NSLog(@"_cellDatasShorthandsuccess %@",_cellDatas);
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
- (void)getDatas {
    [MainNetworkRequest confDocListRequestParams:nil success:^(id success) {
        NSLog(@"confDocListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [_cellDatas removeAllObjects];
            for (NSDictionary *dic in success[@"data"]) {
                SIMConfDocModel *model = [[SIMConfDocModel alloc] initWithDictionary:dic];
                [_cellDatas addObject:model];
            }
            NSLog(@"_cellDatassuccess %@",_cellDatas);
            self.tableView.emptyDataSetSource = self;
            self.tableView.emptyDataSetDelegate = self;
            [self.tableView reloadData];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
    
}
- (void)pushTheNextPage {
    NSLog(@"点击了上传文档");
    UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(NSString *)kUTTypeData] inMode:UIDocumentPickerModeOpen];
    picker.delegate = self;
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url
{
    [url startAccessingSecurityScopedResource];
    NSFileCoordinator *coordinator = [[NSFileCoordinator alloc] init];
    NSError *error;
    __weak typeof(self) ws = self;
    [coordinator coordinateReadingItemAtURL:url options:0 error:&error byAccessor:^(NSURL *newURL) {
//        NSData *fileData = [NSData dataWithContentsOfURL:url];
//        NSString *fileName = [url lastPathComponent];
//        NSString *filePath = [[NSHomeDirectory() stringByAppendingString:@"/Library/Caches/confDoc/file/"] stringByAppendingString:fileName];
//        NSLog(@"1filename: %@ filePath: %@",fileName,filePath);
//
//        [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileData attributes:nil];
//        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            NSLog(@"2filename: %@ filedata: %@",fileName,data);
////
//        }
        NSString *string = [url absoluteString];
        NSString *filename = [string lastPathComponent];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSString *pdString = [url pathExtension];
        //        NSLog(@"filename: %@ 3filedata: %@",filename,data);
                NSArray *arr = @[@"jpg",@"jpeg",@"webp",@"png",@"gif",@"bmp",@"svg",@"txt",@"doc",@"docx",@"pdf",@"xls",@"xlsx",@"ppt",@"pptx"];
                if ([arr containsObject: pdString]) {
                    [ws uploadConfDocRequest:data filename:filename];
                }else {
                    [MBProgressHUD cc_showText:@"不支持该格式文件"];
                }
    }];
    [url stopAccessingSecurityScopedResource];
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}
// 上传文件
- (void)uploadConfDocRequest:(NSData *)data filename:(NSString *)filename {
    NSLog(@"filenamegetname: %@ 3filedata: %@",filename,data);
    [MainNetworkRequest confDocUploadRequestParams:nil bodys:^(id bodys) {
        [MBProgressHUD cc_showLoading:nil];// 正在加载框
        
        [bodys appendPartWithFileData:data name:@"file" fileName:filename mimeType:@"multipart/form-data"];
    } progress:^(id progress) {
        
    } success:^(id success) {
        [MBProgressHUD cc_showSuccess:success[@"msg"]];
        NSLog(@"uploadConfDocSuccess++ %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
//            NSDictionary *dd = success[@"data"];
//            NSString *pathface = dd[@"url"];
            [self getDatas]; // 请求网络列表数据
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"empty_tableview_icon"];
}
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SIMLocalizedString(@"MMainSquareNoneTitle", nil);
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(15),
                                 NSForegroundColorAttributeName:TableViewHeaderColor,
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text;
    if ([self.pageType isEqualToString:@"shorthand"]) {
        text = @"请前往会议室开启速记记录体验吧";
    }else {
        text = @"请点击‘添加会议文档’添加本地文档";
    }
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:FontRegularName(14),
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
@end

