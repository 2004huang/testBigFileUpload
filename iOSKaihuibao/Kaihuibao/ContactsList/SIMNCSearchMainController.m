//
//  SIMNCSearchMainController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/9/13.
//  Copyright © 2018年 Ferris. All rights reserved.
//
#define searchHei 65

#import "SIMNCSearchMainController.h"
#import "SIMNewConverViewController.h"
#import "SIMListTableViewCell.h"
#import "SIMContants.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface SIMNCSearchMainController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,strong) UITextField *searchF;
@property(nonatomic,strong) UIView *searchListView;
@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SIMNCSearchMainController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_searchF becomeFirstResponder];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addSearchBarNew];
    [self addTableView];
    
}
- (void)addTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, searchHei + StatusBarH, screen_width, screen_height - searchHei - StatusBarH) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorColor:ZJYColorHex(@"#eeeeee")];
    self.tableView.hidden = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[SIMListTableViewCell class] forCellReuseIdentifier:@"SIMListTableViewCell"];
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SIMListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIMListTableViewCell"];
    cell.contants = self.searchResults[indexPath.row];
    return cell;
}
// 跳转
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SIMNewConverViewController *conver = [[SIMNewConverViewController alloc] init];
    conver.person = self.searchResults[indexPath.row];
    conver.person.isContant = NO;
    // 将本页的model数组按下标传递给下一页 下一页用一个model属性接受
    [self.navigationController pushViewController:conver animated:YES];
    
}

#pragma mark -- UISearchBarInit
- (void)addSearchBarNew {
    // 承载搜索控制器的view
    UIView *searchBackV = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarH, screen_width, searchHei)];
    searchBackV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchBackV];
    
    _searchF = [[UITextField alloc] initWithFrame:CGRectMake(10,15,screen_width - 20 - kWidthScale(60),35)];
    _searchF.font = FontRegularName(15) ;
    _searchF.layer.cornerRadius = 3;
    _searchF.layer.masksToBounds = YES;
    _searchF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchF.backgroundColor =  ZJYColorHex(@"#efefef");
    _searchF.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [_searchF setReturnKeyType:UIReturnKeySearch];
    _searchF.placeholder=SIMLocalizedString(@"NFindMainSearch", nil);
    _searchF.delegate=self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (self.searchF.frame.size.height - 15)*0.5, 35, 15)];
    UIImageView *leftPhoneImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 15, 15)];
    leftPhoneImgView.image = [UIImage imageNamed:@"companySquare_searchicon"];
    leftPhoneImgView.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:leftPhoneImgView];
    self.searchF.leftView = view;
    self.searchF.leftViewMode = UITextFieldViewModeAlways;
    [_searchF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged]; // textField的文本发生变化时相应事件
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(screen_width - kWidthScale(60), 15, kWidthScale(60), 35)];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitleColor:BlueButtonColor forState:UIControlStateNormal];
    [cancelBtn setTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelPopClick) forControlEvents:UIControlEventTouchUpInside];
    
    [searchBackV addSubview:_searchF];
    [searchBackV addSubview:cancelBtn];
    
}
- (void)cancelPopClick {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)clearButtonDidClick: (UIButton *)button {
    self.searchF.text = nil;
    _searchListView.hidden = NO;
    self.tableView.hidden = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField*)theTextField {
    [theTextField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField{
    NSLog(@"searchtextField %@",textField.text);
    NSString *searchText = textField.text;
    // 模糊查询本地数据
    if (textField.text.length > 0) {
        _searchListView.hidden = YES;
        self.tableView.hidden = NO;
        NSMutableArray *conArr = [[NSMutableArray alloc] init];
        for (SIMContants *person in _listDatas) {
            if ([person.nickname.lowercaseString rangeOfString:searchText.lowercaseString].location != NSNotFound) {
                [conArr addObject:person];
            }
        }
        self.searchResults = [NSArray arrayWithArray:conArr];
        NSLog(@"self.mySRTVC.searchResults %@ %@",self.searchResults,conArr);
    }else {
        _searchListView.hidden = NO;
        self.tableView.hidden = YES;
    }
    [self.tableView reloadData];
}

#pragma mark -- DZNEmptyDataSetSource
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"logo"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = SIMLocalizedString(@"MMainSquareNoneTitle", nil);
    
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end
