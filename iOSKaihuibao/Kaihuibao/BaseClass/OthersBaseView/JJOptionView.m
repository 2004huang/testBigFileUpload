//
//  JJOptionView.m
//  DropdownListDemo
//
//  Created by 俊杰  廖 on 2018/9/20.
//  Copyright © 2018年 HoYo. All rights reserved.
//

#import "JJOptionView.h"
#import "Masonry.h"
#import "SIMAddMember.h"
#import "SIMCompany.h"
#define WEAKSELF __weak typeof(self) weakSelf = self;

@interface JJOptionView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *choseIndexArr;

/**
 标题控件
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 右边箭头图片
 */
@property (nonatomic, strong) UIImageView *rightImageView;

/**
 控件透明按钮，也可以给控件加手势
 */
@property (nonatomic, strong) UIButton *maskBtn;

/**
 选项列表
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 蒙版
 */
@property (nonatomic, strong) UIButton *backgroundBtn;
/**
 tableView的高度
 */
@property (nonatomic, assign) CGFloat tableViewHeight;
@property (nonatomic, assign) BOOL isDirectionUp;
@end

static CGFloat const animationTime = 0.3;
static CGFloat const rowheight = 42;

@implementation JJOptionView


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource {
    if (self = [super initWithFrame:frame]) {
        self.dataSource = dataSource;
        [self setUI];
    }
    return self;
}

- (void)setUI {
    _choseIndexArr = [NSMutableArray array];
    
    self.cornerRadius = 5;
    self.borderWidth = 1;
    self.borderColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    
    [self addSubview:self.rightImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.maskBtn];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.titleLabel.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.mas_right).offset(-10);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.lessThanOrEqualTo(self.rightImageView.mas_left);
    }];
    [self.maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
}


- (void)show {
    WEAKSELF;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.backgroundBtn];
    [window addSubview:self.tableView];
    
    // 获取按钮在屏幕中的位置
    CGRect frame = [self convertRect:self.bounds toView:window];
    CGFloat tableViewY = frame.origin.y + frame.size.height;
    CGRect tableViewFrame;
    tableViewFrame.size.width = frame.size.width;
    tableViewFrame.size.height = self.tableViewHeight;
    tableViewFrame.origin.x = frame.origin.x;
    
    if (tableViewY + self.tableViewHeight < CGRectGetHeight([UIScreen mainScreen].bounds)) {
        tableViewFrame.origin.y = tableViewY;
        self.isDirectionUp = NO;
    }else {
        tableViewFrame.origin.y = frame.origin.y - self.tableViewHeight;
        self.isDirectionUp = YES;
    }
    self.tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y+(self.isDirectionUp?self.tableViewHeight:0), tableViewFrame.size.width, 0);
    [UIView animateWithDuration:animationTime animations:^{
        weakSelf.rightImageView.transform = CGAffineTransformRotate(weakSelf.rightImageView.transform,self.isDirectionUp?-M_PI:M_PI);
        weakSelf.tableView.frame = CGRectMake(tableViewFrame.origin.x, tableViewFrame.origin.y, tableViewFrame.size.width, tableViewFrame.size.height);
        NSLog(@"%@",NSStringFromCGRect(self.tableView.frame));
    }];
    
}

- (void)dismiss {
    WEAKSELF;
    [UIView animateWithDuration:animationTime animations:^{
        weakSelf.rightImageView.transform = CGAffineTransformIdentity;
        weakSelf.tableView.frame = CGRectMake(weakSelf.tableView.frame.origin.x, weakSelf.tableView.frame.origin.y+(self.isDirectionUp?self.tableViewHeight:0), weakSelf.tableView.frame.size.width, 0);
    } completion:^(BOOL finished) {
        [weakSelf.backgroundBtn removeFromSuperview];
        [weakSelf.tableView removeFromSuperview];
    }];
    if (_isMoreChoose) {
        NSMutableArray *arrM = [NSMutableArray array];
        NSMutableArray *pidarrM = [NSMutableArray array];
        for (SIMAddMember *person in _choseIndexArr) {
            [arrM addObject:person.title];
            [pidarrM addObject:person.pid];
        }
        NSString *string = [arrM componentsJoinedByString:@","];
        NSString *pidstring = [pidarrM componentsJoinedByString:@","];
        
        self.title = string;
        if ([self.delegate respondsToSelector:@selector(optionView:chooseArr:)]) {
            [self.delegate optionView:self chooseArr:pidstring];
        }
    }
    
}


#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if ([self.dataSource[indexPath.row] isKindOfClass:[SIMAddMember class]]) {
        SIMAddMember *person = self.dataSource[indexPath.row];
        cell.textLabel.text = person.name;
        if (person.isSelect) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else {
        SIMCompany *comM = self.dataSource[indexPath.row];
        cell.textLabel.text = comM.company_name;
        if ([self.currentUser.currentCompany.company_id isEqualToString:comM.company_id]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isMoreChoose) {
        SIMAddMember *person = self.dataSource[indexPath.row];
        person.isSelect = !person.isSelect;
        if (person.isSelect) {
            [_choseIndexArr addObject:person];
//            NSLog(@"_choseIndexArradd %@",_choseIndexArr);
        }else {
            [_choseIndexArr removeObject:person];
//            NSLog(@"_choseIndexArrremove %@",_choseIndexArr);
        }
        [self.tableView reloadData];
    }else {
        if ([self.dataSource[indexPath.row] isKindOfClass:[SIMAddMember class]]) {
            self.title = [self.dataSource[indexPath.row] name];
        }else {
//            self.title = [self.dataSource[indexPath.row] company_name];
        }
        
        [self dismiss];
        if ([self.delegate respondsToSelector:@selector(optionView:selectedIndex:)]) {
            [self.delegate optionView:self selectedIndex:indexPath.row];
        }
        if (self.selectedBlock) {
            self.selectedBlock(self, indexPath.row);
        }
    }
}

#pragma mark getter && setter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"请选择";
        _titleLabel.textColor = BlackTextColor;
        _titleLabel.font = FontRegularName(14);
    }
    return _titleLabel;
}

- (UIImageView *)rightImageView {
    if(!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"通讯录页-箭头展开"]];
        _rightImageView.clipsToBounds = YES;
    }
    return _rightImageView;
}

- (UIButton *)maskBtn {
    if (!_maskBtn) {
        _maskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _maskBtn.backgroundColor = [UIColor clearColor];
        _maskBtn.clipsToBounds = YES;
        [_maskBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = rowheight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.shadowOffset = CGSizeMake(4, 4);
        _tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _tableView.layer.shadowOpacity = 0.8;
        _tableView.layer.shadowRadius = 4;
        _tableView.layer.borderColor = [UIColor grayColor].CGColor;
        _tableView.layer.borderWidth = 0.5;
        _tableView.layer.cornerRadius = self.cornerRadius;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIApplicationBackgroundFetchIntervalNever;
        }
    }
    return _tableView;
}

- (UIButton *)backgroundBtn {
    if (!_backgroundBtn) {
        _backgroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundBtn.backgroundColor = [UIColor clearColor];
        _backgroundBtn.frame = [UIScreen mainScreen].bounds;
        [_backgroundBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundBtn;
}

- (void)setRowHeigt:(CGFloat)rowHeigt {
    _rowHeigt = rowHeigt;
    self.tableView.rowHeight = rowHeigt;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void)setIsMoreChoose:(BOOL)isMoreChoose {
    _isMoreChoose = isMoreChoose;
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    if (self.rowHeigt) {
        self.tableViewHeight = self.dataSource.count*self.rowHeigt;
    }else {
        self.tableViewHeight = self.dataSource.count*rowheight;
    }
//    NSLog(@"_choseIndexArr23323 %@",_choseIndexArr);
//    [self.tableView reloadData];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:titleFontSize];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
    return (UIColor *)self.layer.borderColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.layer.borderWidth;
}

@end
