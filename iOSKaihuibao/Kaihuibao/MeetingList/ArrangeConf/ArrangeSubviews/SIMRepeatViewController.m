//
//  SIMRepeatViewController.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/24.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMRepeatViewController.h"
@interface SIMRepeatViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSArray *arr;
    NSInteger current;
}
@property (nonatomic,strong) UITableView* tableView;
@end

@implementation SIMRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"MArrangeConfRepeat", nil);
    
//    if (self.tagStr != nil) {
//        _index = [_arr indexOfObject:self.tagStr];
//    }
    current = _index;
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:self.tableView];
   
    UIBarButtonItem* cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    UIBarButtonItem* done = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackComplete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBtnClick)];
    self.navigationItem.rightBarButtonItem = done;
    
}
- (void)cancelBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneBtnClick {
    [self.delegate inputString:self.arr[current] index:current];
    [self.navigationController popViewControllerAnimated:YES];
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
    cell.textLabel.text = _arr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    current = indexPath.row;
    [tableView reloadData];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (current==indexPath.row) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}


@end
