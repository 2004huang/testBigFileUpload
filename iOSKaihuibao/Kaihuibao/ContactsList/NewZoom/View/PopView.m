//
//  PopView.m
//  Kaihuibao
//
//  Created by 王小琪 on 2017/5/25.
//  Copyright © 2017年 Ferris. All rights reserved.
//



#import "PopView.h"

@interface PopView () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^action)(NSInteger index);
@property (nonatomic, strong) NSArray *imagesArr;
@property (nonatomic, strong) NSArray *dataSourceArr;
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) NSTimeInterval come;
@property (nonatomic, assign) NSTimeInterval go;
@end

static PopView *backgroundView;
static UITableView *tableViewQ;
@implementation PopView
/*
 * frame               设定tableView的位置
 * imagesArr           图片数组
 * dataSourceArr       文字信息数组
 * anchorPoint         tableView进行动画时候的锚点
 * action              通过block回调 确定菜单中 被选中的cell
 * animation           是否有动画效果
 * come                菜单出来动画的时间
 * go                  菜单收回动画的时间
 */
+ (void)configCustomPopViewWithFrame:(CGRect)frame imagesArr:(NSArray *)imagesArr dataSourceArr:(NSArray *)dataourceArr seletedRowForIndex:(void(^)(NSInteger index))action animation:(BOOL)animation timeForCome:(NSTimeInterval)come timeForGo:(NSTimeInterval)go{
    if (backgroundView) {
        [PopView removed];
        return;
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //背景色
    backgroundView = [[PopView alloc] initWithFrame:window.bounds];
    backgroundView.action = action;
    backgroundView.imagesArr = imagesArr;
    backgroundView.dataSourceArr = dataourceArr;
    backgroundView.animation = animation;
    backgroundView.come = come;
    backgroundView.go = go;
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.4;
    //添加手势 点击背景能够回收菜单
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:backgroundView action:@selector(handleRemoved)];
    [backgroundView addGestureRecognizer:tap];
    
    
    //tableView
    tableViewQ = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    tableViewQ.delegate = backgroundView;
    tableViewQ.dataSource = backgroundView;
//    tableViewQ.layer.anchorPoint = anchorPoint;
    tableViewQ.layer.cornerRadius = 10;
    tableViewQ.alpha = 0;
//    tableViewQ.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
//    tableViewQ.backgroundColor = ZJYColorHex(@"#464646");
    tableViewQ.backgroundColor = [UIColor whiteColor];
    tableViewQ.scrollEnabled = NO;
    if (animation) {
        [UIView animateWithDuration:come animations:^{
            [window addSubview:backgroundView];
            [window addSubview:tableViewQ];
            tableViewQ.alpha = 1;
            
//            tableViewQ.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    
    
}

+ (void)removed {
    if (backgroundView.animation) {
        backgroundView.alpha = 0;
        [UIView animateWithDuration:backgroundView.go animations:^{
//            tableViewQ.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
            tableViewQ.alpha = 0;
//            backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
            backgroundView = nil;
            [tableViewQ removeFromSuperview];
            tableViewQ = nil;
        }];
    }
}

- (void)handleRemoved {
    if (backgroundView) {
        [PopView removed];
    }
}

#pragma mark ---- UITableViewDelegateAndDatasource --
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifile = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifile];
    if (!cell) {
        //选择普通的tableviewCell 左边是图片 右边是文字
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifile];
    }
    cell.imageView.image = [UIImage imageNamed:_imagesArr[indexPath.row]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.textLabel.text = _dataSourceArr[indexPath.row];
    cell.textLabel.textColor = BlackTextColor;
    cell.textLabel.font = FontRegularName(15);
//    cell.backgroundColor = ZJYColorHex(@"#464646");
    cell.backgroundColor = [UIColor whiteColor];
//    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    if ([cell respondsToSelector:@selector(layoutMargins)]) {
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableViewQ.frame.size.height / _dataSourceArr.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (backgroundView.action) {
        //利用block回调 确定选中的row
        _action(indexPath.row);
        [PopView removed];
    }
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
}

@end
