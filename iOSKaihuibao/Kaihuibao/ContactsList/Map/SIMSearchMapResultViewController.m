//
//  SIMSearchMapResultViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/8/9.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMSearchMapResultViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface SIMSearchMapResultViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL isNoMoreData;      // 上拉加载标记是否是没有更多数据了
    NSInteger  _pageNumber; // 上拉加载第几页 从0开始
}
@end

@implementation SIMSearchMapResultViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.frame = CGRectMake(0, isIPhoneXAll ? StatusNavH + 10 : StatusNavH, screen_width, screen_height - (isIPhoneXAll ? StatusNavH + 10 : StatusNavH));
    [self.view addSubview:self.tableView];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"mapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuse];
    }
    AMapTip *tips = self.datas[indexPath.row];
    cell.textLabel.font = FontRegularName(17);
    cell.textLabel.textColor = BlackTextColor;
    cell.detailTextLabel.font = FontRegularName(12);
    cell.detailTextLabel.textColor = GrayPromptTextColor;
    
    cell.textLabel.text = tips.name;
    cell.detailTextLabel.text = tips.address;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *tips = self.datas[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchLoactionWithLat:andLon:locationStr:)]) {
        [self.delegate searchLoactionWithLat:tips.location.latitude andLon:tips.location.longitude locationStr:[NSString stringWithFormat:@"%@,%@",tips.name,tips.address]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}
@end
