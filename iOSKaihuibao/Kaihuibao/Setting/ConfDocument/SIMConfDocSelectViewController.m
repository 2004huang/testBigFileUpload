//
//  SIMConfDocSelectViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/9/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfDocSelectViewController.h"
#import "SIMConfDocSelectCell.h"

#import "SIMConfDocSelectSearchController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
@interface SIMConfDocSelectViewController ()<UIDocumentPickerDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (strong,nonatomic) SIMBaseTableView* tableView;
@property (strong,nonatomic) NSMutableArray *cellDatas;
@property (nonatomic, strong) UIButton *findBtn;
@property (strong,nonatomic) NSMutableArray *searchResult;
@property(nonatomic,strong) SIMConfDocSelectSearchController *mySRTVC;// 展示搜索结果的VC
@property(nonatomic,strong) UISearchController *searchController;// 搜索条
@property (nonatomic, strong) NSMutableArray *choseIndexArr;

@end

@implementation SIMConfDocSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"SConfDocument", nil);
    _cellDatas = [[NSMutableArray alloc] init];
    _choseIndexArr = [NSMutableArray array];
    
    [self getDatas]; // 请求网络列表数据
    // 加载tableview
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - 75);
    [self.tableView registerClass:[SIMConfDocSelectCell class] forCellReuseIdentifier:@"SIMConfDocSelectCell"];
    [self.view addSubview:self.tableView];
    [self addSearchBarUI];
    [self addBottomUI];
}
- (void)addBottomUI {
    _findBtn = [[UIButton alloc] init];
    [_findBtn setTitle:SIMLocalizedString(@"JSBNextConfirmClick", nil) forState:UIControlStateNormal];
    [_findBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_findBtn setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_findBtn setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _findBtn.layer.masksToBounds = YES;
    _findBtn.layer.cornerRadius = 45/4;
    _findBtn.backgroundColor = BlueButtonColor;
    [_findBtn addTarget:self action:@selector(pushTheNextPage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findBtn];
    [_findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH+15));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - TableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
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
    SIMConfDocSelectCell *commonCell = [tableView dequeueReusableCellWithIdentifier:@"SIMConfDocSelectCell"];
    commonCell.model = self.cellDatas[indexPath.row];
    return commonCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SIMConfDocModel *confDoc = self.cellDatas[indexPath.row];
    confDoc.isSelect = !confDoc.isSelect;
    if (confDoc.isSelect) {
        [_choseIndexArr addObject:confDoc];
    }else {
        [_choseIndexArr removeObject:confDoc];
    }
    [self.tableView reloadData];
}
- (void)addSearchBarUI {
    self.mySRTVC = [[SIMConfDocSelectSearchController alloc] init];
    self.mySRTVC.mainSearchController = self;
    self.searchController=[[UISearchController alloc]initWithSearchResultsController:self.mySRTVC];
    [self.searchController.searchBar sizeToFit];   //大小调整
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
    for (SIMConfDocModel *model in _cellDatas) {
        if ([model.name.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
            [conArr addObject:model];
        }
    }
    self.mySRTVC.datas = conArr;
    self.mySRTVC.chooseArr = self.choseIndexArr;
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

- (void)getDatas {
    [MainNetworkRequest confDocListRequestParams:nil success:^(id success) {
        NSLog(@"confDocListsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            for (NSDictionary *dic in success[@"data"]) {
                SIMConfDocModel *model = [[SIMConfDocModel alloc] initWithDictionary:dic];
                
                if ([_docIDArr containsObject:model.docId]) {
                    model.isSelect = YES;
                    [_choseIndexArr addObject:model];
                }
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
    NSLog(@"点击了选择的文档确定");
    [self.delegate confDocSelectAlreadyArr:_choseIndexArr];
    [self.navigationController popViewControllerAnimated:YES];
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
    NSString *text = @"请去‘我的’里面添加会议文档";
    
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
