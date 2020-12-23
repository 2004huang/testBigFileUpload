//
//  SIMAddChooseDepartViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2019/7/22.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "SIMAddChooseDepartViewController.h"
#import "SIMAddMember.h"
@interface SIMAddChooseDepartViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSMutableArray *choseIndexArr;

@end

@implementation SIMAddChooseDepartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择部门";
//    _choseIndexArr = [NSMutableArray array];
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    self.tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH);
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"returnicon"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    static NSString * cellID=@"tableviewcellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    SIMAddMember *person = self.dataSource[indexPath.row];
    cell.textLabel.text = person.name;
    if (person.isSelect) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    SIMAddMember *person = self.dataSource[indexPath.row];
    person.isSelect = !person.isSelect;
    if (person.isSelect) {
        [_choseIndexArr addObject:person];
        NSLog(@"_choseIndexArradd %@",_choseIndexArr);
    }else {
        [_choseIndexArr removeObject:person];
        NSLog(@"_choseIndexArrremove %@",_choseIndexArr);
    }
    [self.tableView reloadData];

}
- (void)backClick {
//    NSMutableArray *arrM = [NSMutableArray array];
//    NSMutableArray *pidarrM = [NSMutableArray array];
//    for (SIMAddMember *person in _choseIndexArr) {
//        [arrM addObject:person.title];
//        [pidarrM addObject:person.pid];
//    }
//    NSString *string = [arrM componentsJoinedByString:@","];
//    NSString *pidstring = [pidarrM componentsJoinedByString:@","];
//
//    self.title = string;
    if ([self.delegate respondsToSelector:@selector(optionChooseArr:)]) {
        [self.delegate optionChooseArr:_choseIndexArr];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
