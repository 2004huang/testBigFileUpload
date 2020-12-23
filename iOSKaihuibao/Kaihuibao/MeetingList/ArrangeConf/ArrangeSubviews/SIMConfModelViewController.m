//
//  SIMConfModelViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/3.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMConfModelViewController.h"

@interface SIMConfModelViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    NSArray *arr;
    NSInteger current;
}
@property (nonatomic, strong) NSMutableArray *chooseArr;
@property (nonatomic,strong) UITableView* tableView;

@end

@implementation SIMConfModelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择会议模式";
    NSInteger index = 0;
//    _chooseArr = [NSMutableArray arrayWithObjects:@"自由视角",@"与主持人广播视频一致",@"与主持人视角一致",@"对讲模式", nil];
    for (ConfModelModel *model in _confArr) {
        if ([model.name isEqualToString:self.tagStr]) {
           index = [_confArr indexOfObject:model];
        }
    }
//    NSInteger index = [_confArr indexOfObject:self.tagStr];
    current = index;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight =0;
    self.tableView.estimatedSectionHeaderHeight =0;
    self.tableView.estimatedSectionFooterHeight =0;
    [self.view addSubview:self.tableView];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackCancelTitle", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:SIMLocalizedString(@"NavBackComplete", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    self.navigationItem.rightBarButtonItem = done;
    
}
- (void)cancelClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)doneClick {
    [self.delegate confModeModel:_confArr[current] type:current];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableView
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _confArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGSize titleSize = [[_confArr[section] detail] boundingRectWithSize:CGSizeMake(screen_width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontRegularName(14)} context:nil].size;
    return titleSize.height + 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGSize titleSize = [[_confArr[section] detail] boundingRectWithSize:CGSizeMake(screen_width - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FontRegularName(13)} context:nil].size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, titleSize.height + 20)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screen_width - 30, titleSize.height)];
    label.font = FontRegularName(13);
    label.numberOfLines = 0;
    label.text = [_confArr[section] detail];
    label.textColor = ZJYColorHex(@"#747485");
    [view addSubview:label];
    return view;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuse];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16];
    cell.textLabel.textColor = BlackTextColor;
    ConfModelModel *model = _confArr[indexPath.section];
    cell.textLabel.text = model.name;
//    if ([model.serial isEqualToString:@"trainingConference"]) {
//        cell.userInteractionEnabled = NO;
//        cell.textLabel.textColor = GrayPromptTextColor;
//    }else {
//        cell.userInteractionEnabled = YES;
//        cell.textLabel.textColor = BlackTextColor;
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    current = indexPath.section;
    [tableView reloadData];
}
- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    if (current==indexPath.section) {
        return UITableViewCellAccessoryCheckmark;
    }else {
        return UITableViewCellAccessoryNone;
    }
}

@end
