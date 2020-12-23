

//
//  SIMOrderPayNextViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2018/10/12.
//  Copyright © 2018年 Ferris. All rights reserved.
//

#import "SIMOrderPayNextViewController.h"
#import "SIMOrderOneCell.h"
#import "SIMPlanDeviceCell.h"
#import "SIMMineOrderCell.h"
#import "SIMOrderThreeCell.h"
#import "SIMPayPicTableViewCell.h"

#import "WXApi.h"
#import "SIMWechatModel.h"
#import "SIMPayHistoryModel.h"
#import "SIMPayResultAlertView.h"
#import "SIMOrderChooseCountCell.h"
#import "SIMAppPurchaseTool.h"

@interface SIMOrderPayNextViewController ()<UITableViewDelegate,UITableViewDataSource,SIMOptionViewDelegate,UITextFieldDelegate,SIMAppPurchaseDelegate>

@property (strong,nonatomic) UITableView* tableView;
@property (strong,nonatomic) UIButton* gotoBuy;
@property (nonatomic, strong) SIMWechatModel *wechatPay;
@property (nonatomic, strong) SIMNewPlanDetailModel *detailModel;
@property (assign,nonatomic) NSInteger btnIndex;
@property (nonatomic, strong) SIMPayResultAlertView *little;
@property (nonatomic, strong) UIView *backView;// 蒙层
@property (nonatomic, strong) SIMOptionList *selectListModel;
@property (nonatomic, strong) NSString *selectCount;
@property (nonatomic, strong) NSString *selectIndex;

@end
static NSString *oneCell = @"SIMOrderOneCell";
static NSString *deviceCell = @"SIMPlanDeviceCell";
static NSString *twoCell = @"SIMMineOrderCell";
static NSString *threeCell = @"SIMOrderThreeCell";
static NSString *picCell = @"SIMPayPicTableViewCell";

@implementation SIMOrderPayNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.btnIndex = 0;
    self.navigationItem.title = SIMLocalizedString(@"NPayAllNext_Title", nil);
    NSLog(@"teachmodelID%@",self.teachID);

    if (self.teachID != nil) {
        [self requestTeachModelDetailID:self.teachID];
    }else {
        if (self.nowSModel != nil) {
            [self requestServiceDetailID:[self.nowSModel.pid stringValue] orderType:[self.nowSModel.orderType stringValue]];
        }else {
            if ([_type isEqualToString:@"plan"]) {
                [self requestPlanDetailID:[self.model.pid stringValue] orderType:[self.model.orderType stringValue]];
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
                    #if TypeClassBao || TypeXviewPrivate

                    #else
                        [[SIMAppPurchaseTool shareInstace] startManager];
                    #endif
                }
            }else {
                [self requestServiceDetailID:[self.model.pid stringValue] orderType:[self.model.orderType stringValue]];
            }
        }
        
    }

//    if ([_type isEqualToString:@"plan"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] == YES && [self.cloudVersion.plan boolValue]) {
//    }else {
//        #if TypeClassBao
//
//        #else
//            [[SIMAppPurchaseTool shareInstace] startManager];
//        #endif
//
//    }

}

- (void)initSubTableView {
    // 创建表格
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView = [[SIMBaseTableView alloc] initInViewController:self];
    _tableView.frame = CGRectMake(0, 0, screen_width, screen_height - StatusNavH - (BottomSaveH + 60));
    _tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 60;
//    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SIMPlanDeviceCell class] forCellReuseIdentifier:deviceCell];
    [self.tableView registerClass:[SIMMineOrderCell class] forCellReuseIdentifier:twoCell];
    [self.tableView registerClass:[SIMOrderOneCell class] forCellReuseIdentifier:oneCell];
    [self.tableView registerClass:[SIMOrderThreeCell class] forCellReuseIdentifier:threeCell];
    [self.tableView registerClass:[SIMPayPicTableViewCell class] forCellReuseIdentifier:picCell];
    
    
    _gotoBuy = [[UIButton alloc] init];
    [_gotoBuy setTitle:SIMLocalizedString(@"NPayMain_PayLast", nil) forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_gotoBuy setTitleColor:HightLightButtonTitleColor forState:UIControlStateHighlighted];
    [_gotoBuy setBackgroundImage:[UIImage imageWithColor:HightLightButtonColor] forState:UIControlStateHighlighted];
    _gotoBuy.backgroundColor = BlueButtonColor;
    _gotoBuy.titleLabel.font = FontRegularName(18);
    _gotoBuy.layer.masksToBounds = YES;
    _gotoBuy.layer.cornerRadius = 45/4;
    [_gotoBuy addTarget:self action:@selector(gotoBuythegood) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_gotoBuy];
    [_gotoBuy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(BottomSaveH + 15));
        make.left.mas_equalTo(15);
        make.height.mas_equalTo(45);
        make.right.mas_equalTo(-15);
    }];
    
}


#pragma mark -- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 10.0;
//    }else {
        return 0.001;
//    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screen_width, 10)];
//        view.backgroundColor = ZJYColorHex(@"#f7f7f7");
//        return view;
//    }else {
        return nil;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//分区中行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.teachID != nil) {
//        if ([_detailModel.valuationType intValue] == 1) {
//            // 和计划一样的
//            return 4;
//        }else {
            return 5;
//        }
    }else if ([self.type isEqualToString:@"plan"]) {
        return 4;
    }else {
        if ([_detailModel.serviceType intValue] == 3 || [_detailModel.serviceType intValue] == 2) {
            return 4;
        }else {
            return 3;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 0.01;
    }else if (self.teachID != nil && [_detailModel.valuationType intValue] == 1 && indexPath.row == 1) {
        // 和计划一样的
        return 0.01;
    }else {
        return UITableViewAutomaticDimension;
    }
//            return [self.tableView cellHeightForIndexPath:indexPath model:nil keyPath:@"model" cellClass:[SIMChoosePayPlanCell class] contentViewWidth:screen_width];
}

//设置单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.teachID != nil) {
        // 教学模式
        if (indexPath.row == 0) {
            SIMPlanDeviceCell *conCell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
//            conCell.detailModel = _detailModel;
            return conCell;
        }else if (indexPath.row == 1) {
            if ([_detailModel.valuationType intValue] == 2) {
                // 和服务一样的
                SIMOrderChooseCountCell *commonCell = [[SIMOrderChooseCountCell alloc] initWithViewController:self];
                commonCell.textF.delegate = self;
                [commonCell.textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                commonCell.detailModel = _detailModel;
                return commonCell;
            }else {
                // 用一个空cell 替代一下index位置
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
                if (cell == nil) {
                     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                }
                return cell;
            }
        }else if (indexPath.row == 2) {
            SIMOrderOneCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
            _detailModel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
            if ([_detailModel.valuationType intValue] == 2) {
                if (_selectListModel == nil) {
                    SIMOptionList *listmodel = _detailModel.optionList[[_detailModel.index intValue]];
                    listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                    listmodel.time_unit = _detailModel.time_unit;
                    listmodel.price_unit = _detailModel.price_unit;
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    listmodel.countStr = _selectCount;
                    listmodel.main = _detailModel.main;
                    commonCell.listmodel = listmodel;
                    _selectListModel = listmodel;
                }else {
                    SIMOptionList *listmodel = _selectListModel;
                    listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                    listmodel.time_unit = _detailModel.time_unit;
                    listmodel.price_unit = _detailModel.price_unit;
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    listmodel.countStr = _selectCount;
                    listmodel.main = _detailModel.main;
                    commonCell.listmodel = listmodel;
                }
            }else {
                commonCell.detailModel = _detailModel;
            }
            __weak typeof(self) weakSelf = self;
            [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
                weakSelf.btnIndex = buttonIndex;
                //一个cell刷新
                [UIView performWithoutAnimation:^{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }];
            
            return commonCell;
        }else if (indexPath.row == 3){
            SIMOrderThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
            
            theCell.types = [NSString stringWithFormat:@"%ld",self.btnIndex + 1];// 按月付款的总金额就是total  年付是YearBilling 后台参数不同需要区分 1是月付 2是年付 每次刷新改变
            if ([_detailModel.valuationType intValue] == 2) {
                SIMOptionList *listmodel = _selectListModel;
                if (_selectCount == nil) {
                    _selectCount = @"1";
                }
                listmodel.countStr = _selectCount;
                listmodel.main = _detailModel.main;
                theCell.nameStr = _detailModel.name;
                theCell.listmodel = _selectListModel;
            }else  {
                theCell.detailModel = _detailModel;
            }
            
            return theCell;
        }else {
            SIMPayPicTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:picCell];
            pictureCell.picStr = _detailModel.mode_image;
            pictureCell.imageHeight = _detailModel.height;
            return pictureCell;
        }
    }
    if ([self.type isEqualToString:@"plan"]) {
        if (indexPath.row == 0) {
            // 计划
            SIMMineOrderCell *conCell = [tableView dequeueReusableCellWithIdentifier:twoCell];
//            conCell.detailModel = _detailModel;
            //        SIMOrderTwoCell *conCell = [tableView dequeueReusableCellWithIdentifier:twoCell];
            //        conCell.model = [[SIMPayPlanModel alloc] init];
            return conCell;
        }else if (indexPath.row == 1) {
            SIMOrderOneCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
            _detailModel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
            commonCell.detailModel = _detailModel;
            
            __weak typeof(self) weakSelf = self;
            [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
                weakSelf.btnIndex = buttonIndex;
                //一个cell刷新
                [UIView performWithoutAnimation:^{
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }];
                //一个cell刷新
                //                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                //                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }];
            
            return commonCell;
        }else if (indexPath.row == 2){
            SIMOrderThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
            theCell.types = [NSString stringWithFormat:@"%ld",self.btnIndex + 1];// 按月付款的总金额就是total  年付是YearBilling 后台参数不同需要区分 1是月付 2是年付 每次刷新改变
            //        if ([self.model.orderType intValue] == 2) {
            //            theCell.isUpPlan = YES;
            //        }else {
            //            theCell.isUpPlan = NO;
            //        }
            theCell.detailModel = _detailModel;
            return theCell;
        }else {
            SIMPayPicTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:picCell];
            pictureCell.picStr = _detailModel.image;
            pictureCell.imageHeight = _detailModel.height;
            return pictureCell;
        }
    }else if ([self.type isEqualToString:@"device"]) {
        if ([_detailModel.serviceType intValue] == 3 || [_detailModel.serviceType intValue] == 2) {
            // 服务
            if (indexPath.row == 0) {
                SIMPlanDeviceCell *conCell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
//                conCell.detailModel = _detailModel;
                return conCell;
            }else if (indexPath.row == 1) {
                SIMOrderChooseCountCell *commonCell = [[SIMOrderChooseCountCell alloc] initWithViewController:self];
                commonCell.textF.delegate = self;
                [commonCell.textF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
                commonCell.detailModel = _detailModel;
                return commonCell;
            }else if (indexPath.row == 2) {
                SIMOrderOneCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
                _detailModel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                if ([_detailModel.serviceType intValue] == 3) {
                    if (_selectListModel == nil) {
                        SIMOptionList *listmodel = _detailModel.optionList[[_detailModel.index intValue]];
                        listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                        listmodel.time_unit = _detailModel.time_unit;
                        listmodel.price_unit = _detailModel.price_unit;
                        if (_selectCount == nil) {
                            _selectCount = @"1";
                        }
                        listmodel.countStr = _selectCount;
                        listmodel.main = _detailModel.main;
                        commonCell.listmodel = listmodel;
                        _selectListModel = listmodel;
                    }else {
                        SIMOptionList *listmodel = _selectListModel;
                        listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                        listmodel.time_unit = _detailModel.time_unit;
                        listmodel.price_unit = _detailModel.price_unit;
                        if (_selectCount == nil) {
                            _selectCount = @"1";
                        }
                        listmodel.countStr = _selectCount;
                        listmodel.main = _detailModel.main;
                        commonCell.listmodel = listmodel;
                    }
                }else {
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    _detailModel.countStr = _selectCount;
                    commonCell.detailModel = _detailModel;
                }
                __weak typeof(self) weakSelf = self;
                [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
                    weakSelf.btnIndex = buttonIndex;
                    //一个cell刷新
                    [UIView performWithoutAnimation:^{
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    //一个cell刷新
                    //                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    //                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }];
                
                return commonCell;
            }else if (indexPath.row == 3){
                SIMOrderThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
                
                theCell.types = [NSString stringWithFormat:@"%ld",self.btnIndex + 1];// 按月付款的总金额就是total  年付是YearBilling 后台参数不同需要区分 1是月付 2是年付 每次刷新改变
                //        if ([self.model.orderType intValue] == 2) {
                //            theCell.isUpPlan = YES;
                //        }else {
                //            theCell.isUpPlan = NO;
                //        }
                if ([_detailModel.serviceType intValue] == 3) {
                    SIMOptionList *listmodel = _selectListModel;
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    listmodel.countStr = _selectCount;
                    listmodel.main = _detailModel.main;
                    theCell.nameStr = _detailModel.name;
                    theCell.listmodel = _selectListModel;
                }else if ([_detailModel.serviceType intValue] == 2) {
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    _detailModel.countStr = _selectCount;
                    theCell.detailModel = _detailModel;
                }else  {
                    _detailModel.countStr = _selectCount;
                    theCell.detailModel = _detailModel;
                }
                
                return theCell;
            }
//            else {
//                SIMPayPicTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:picCell];
//                pictureCell.picStr = _detailModel.image;
//                pictureCell.imageHeight = _detailModel.height;
////                pictureCell.picStr = @"https://www.kaihuibao.net/uploads/20190928/2e54f77d39f06fba07b73a7f78bcc365.jpeg";
//                return pictureCell;
//            }
        }else {
            
            if (indexPath.row == 0) {
                SIMPlanDeviceCell *conCell = [tableView dequeueReusableCellWithIdentifier:deviceCell];
//                conCell.detailModel = _detailModel;
                return conCell;
            }else if (indexPath.row == 1) {
                SIMOrderOneCell *commonCell = [tableView dequeueReusableCellWithIdentifier:oneCell];
                _detailModel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                if ([_detailModel.serviceType intValue] == 3) {
                    if (_selectListModel == nil) {
                        SIMOptionList *listmodel = _detailModel.optionList[[_detailModel.index intValue]];
                        listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                        listmodel.time_unit = _detailModel.time_unit;
                        listmodel.price_unit = _detailModel.price_unit;
                        if (_selectCount == nil) {
                            _selectCount = @"1";
                        }
                        listmodel.countStr = _selectCount;
                        listmodel.main = _detailModel.main;
                        commonCell.listmodel = listmodel;
                        _selectListModel = listmodel;
                    }else {
                        SIMOptionList *listmodel = _selectListModel;
                        listmodel.selectBtn = [NSString stringWithFormat:@"%ld",self.btnIndex];
                        listmodel.time_unit = _detailModel.time_unit;
                        listmodel.price_unit = _detailModel.price_unit;
                        if (_selectCount == nil) {
                            _selectCount = @"1";
                        }
                        listmodel.countStr = _selectCount;
                        listmodel.main = _detailModel.main;
                        commonCell.listmodel = listmodel;
                    }
                }else {
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    _detailModel.countStr = _selectCount;
                    commonCell.detailModel = _detailModel;
                }
                __weak typeof(self) weakSelf = self;
                [commonCell setDidClickAtIndex:^(NSInteger buttonIndex) {
                    weakSelf.btnIndex = buttonIndex;
                    //一个cell刷新
                    [UIView performWithoutAnimation:^{
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
                        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                    //一个cell刷新
                    //                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                    //                [tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }];
                
                return commonCell;
            }else if (indexPath.row == 2){
                SIMOrderThreeCell *theCell = [tableView dequeueReusableCellWithIdentifier:threeCell];
                theCell.types = [NSString stringWithFormat:@"%ld",self.btnIndex + 1];// 按月付款的总金额就是total  年付是YearBilling 后台参数不同需要区分 1是月付 2是年付 每次刷新改变
                //        if ([self.model.orderType intValue] == 2) {
                //            theCell.isUpPlan = YES;
                //        }else {
                //            theCell.isUpPlan = NO;
                //        }
                if ([_detailModel.serviceType intValue] == 3) {
                    SIMOptionList *listmodel = _selectListModel;
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    listmodel.countStr = _selectCount;
                    listmodel.main = _detailModel.main;
                    theCell.nameStr = _detailModel.name;
                    theCell.listmodel = _selectListModel;
                }else if ([_detailModel.serviceType intValue] == 2) {
                    if (_selectCount == nil) {
                        _selectCount = @"1";
                    }
                    _detailModel.countStr = _selectCount;
                    theCell.detailModel = _detailModel;
                }else  {
                    _detailModel.countStr = _selectCount;
                    theCell.detailModel = _detailModel;
                }
                
                return theCell;
            }
//            else {
//                SIMPayPicTableViewCell *pictureCell = [tableView dequeueReusableCellWithIdentifier:picCell];
//                pictureCell.picStr = _detailModel.image;
//                pictureCell.imageHeight = _detailModel.height;
////                pictureCell.picStr = @"https://www.kaihuibao.net/uploads/20190928/2e54f77d39f06fba07b73a7f78bcc365.jpeg";
//                return pictureCell;
//            }
        }
        
    }
    
    return nil;
    
}
- (void)gotoBuythegood {
    if (self.teachID != nil) {
        if (![WXApi isWXAppInstalled]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
            return ;
        }
        if (![WXApi isWXAppSupportApi]){
            [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
            return ;
        }
        NSString *ss;
        if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"月"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"m"] ) {
            ss = @"m";
        }else if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"季"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"q"]) {
            ss = @"q";
        }else {
            ss = @"y";
        }
        
        [self teachmodelweChatPayWithPid:[self.detailModel.pid stringValue] payType:ss];
        
    }else if ([_type isEqualToString:@"plan"]) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
            // 微信支付
            if (![WXApi isWXAppInstalled]) {
                [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
                
            }else if (![WXApi isWXAppSupportApi]){
                [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
            }else {
                NSString *ss;
                if ([[self.detailModel.info_array[self.btnIndex] name] isEqualToString:@"月"] || [[self.detailModel.info_array[self.btnIndex] time_type] isEqualToString:@"m"] ) {
                    ss = @"m";
                }else if ([[self.detailModel.info_array[self.btnIndex] name] isEqualToString:@"季"] || [[self.detailModel.info_array[self.btnIndex] time_type] isEqualToString:@"q"]) {
                    ss = @"q";
                }else {
                    ss = @"y";
                }
                //        [self weChatGet:ss order:self.model.serial];
                if (self.nowSModel != nil) {
                    [self weChatPayWithPid:[self.nowSModel.pid stringValue] payType:ss distinct:@"s"];
                }else {
                    if ([_type isEqualToString:@"plan"]) {
                        [self weChatPayWithPid:[self.detailModel.pid stringValue] payType:ss distinct:@"p"];
                    }else {
                        [self weChatPayWithPid:[self.detailModel.pid stringValue] payType:ss distinct:@"s"];
                    }
                }
                //        [self presentTheAlertView];
            }
        }else {
            // 苹果内购
            #if TypeClassBao || TypeXviewPrivate
                
            #else
                NSString *ss;
                if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"月"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"m"]) {
                    ss = @"m";
                }else if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"季"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"q"]) {
                    ss = @"q";
                }else {
                    ss = @"y";
                    
                }
                [self inappPayWithPid:[self.detailModel.pid stringValue] payType:ss productID:[self.detailModel.info[self.btnIndex] IOS_ID]];
                
            #endif
            
        }
    }else {
        // 服务购买
        if (![WXApi isWXAppInstalled]) {
            [MBProgressHUD cc_showText:SIMLocalizedString(@"ThirdLoginNoWechatTitle", nil)];
            
        }else if (![WXApi isWXAppSupportApi]){
            [MBProgressHUD cc_showText:SIMLocalizedString(@"TopUpwithdraw_noWechat", nil)];
        }else {
            NSString *ss;
            if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"月"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"m"]) {
                ss = @"m";
            }else if ([[self.detailModel.info[self.btnIndex] name] isEqualToString:@"季"] || [[self.detailModel.info[self.btnIndex] time_type] isEqualToString:@"q"]) {
                ss = @"q";
            }else {
                ss = @"y";
            }
            //        [self weChatGet:ss order:self.model.serial];
            if (self.nowSModel != nil) {
                [self weChatPayWithPid:[self.nowSModel.pid stringValue] payType:ss distinct:@"s"];
            }else {
                if ([_type isEqualToString:@"plan"]) {
                    [self weChatPayWithPid:[self.detailModel.pid stringValue] payType:ss distinct:@"p"];
                }else {
                    [self weChatPayWithPid:[self.detailModel.pid stringValue] payType:ss distinct:@"s"];
                }
            }
            //        [self presentTheAlertView];
        }
    }
    
    
}
- (void)inappPayWithPid:(NSString *)pid payType:(NSString *)payType productID:(NSString *)productID {
    // 先创建苹果预付单
    [MBProgressHUD cc_showLoading:nil];
    [MainNetworkRequest inappPayGetorderRequestParams:@{@"id":pid,@"payType":payType} success:^(id success) {
        NSLog(@"payinapppaysuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
            if ([success[@"data"] isEqual:[NSNull null]] || success[@"data"] == nil) {
                NSLog(@"不可以支付哦");
                [self presentTheAlertView];
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:success[@"data"][@"orderNum"] forKey:@"appleinappPayOrderID"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[SIMAppPurchaseTool shareInstace] startPurchase:productID];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 教学计划的请求支付接口
- (void)teachmodelweChatPayWithPid:(NSString *)pid payType:(NSString *)payType {
    [MBProgressHUD cc_showLoading:nil];
    // 上线之后用微信
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:pid forKey:@"id"];
    [dic setObject:payType forKey:@"payType"];
    [dic setObject:APPWechatTitle forKey:@"type"];
    
    if ([_detailModel.valuationType intValue] == 2) {
        if (_selectCount.length <= 0 || [_selectCount isEqualToString:@"0"]) {
            [MBProgressHUD cc_showText:@"请输入主持人数量"];
            return ;
        }
        [dic setObject:_selectCount forKey:@"main"];
        [dic setObject:_selectIndex forKey:@"index"];
    }
    
    NSLog(@"payclassappsuccessdic %@",dic);
    [MainNetworkRequest classmodelgotopayRequestParams:dic success:^(id success) {
        NSLog(@"payappsuccess %@ %@",success,dic);
        if ([success[@"code"] integerValue] == successCodeOK) {
            if ([success[@"data"] isEqual:[NSNull null]] || success[@"data"] == nil) {
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                NSLog(@"不可以支付哦");
                [self presentTheAlertView];
            }else {
                _wechatPay = [[SIMWechatModel alloc] initWithDictionary:success[@"data"]];
                NSLog(@"wechatPayappid  %@",_wechatPay.appid);
                [[NSUserDefaults standardUserDefaults] setObject:success[@"data"][@"orderNum"] forKey:@"newPayOrderNum"];
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                [self wechatNowPay];
                // 支付种类  钱包和计划
                [[NSUserDefaults standardUserDefaults] setObject:@"ProjectAdd" forKey:@"newOrderType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 计划的请求支付接口
- (void)weChatPayWithPid:(NSString *)pid payType:(NSString *)payType distinct:(NSString *)distinct {

    [MBProgressHUD cc_showLoading:nil];
    // 上线之后用微信
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:pid forKey:@"id"];
    [dic setObject:payType forKey:@"payType"];
    [dic setObject:distinct forKey:@"distinct"];
    [dic setObject:APPWechatTitle forKey:@"type"];
    if (self.nowSModel != nil) {
        [dic setObject:_nowSModel.orderType forKey:@"orderType"];
    }else {
        [dic setObject:_model.orderType forKey:@"orderType"];
    }
    
    if ([distinct isEqualToString:@"s"] && ([_detailModel.serviceType intValue] == 3 || [_detailModel.serviceType intValue] == 2)) {
        if (_selectCount.length <= 0 || [_selectCount isEqualToString:@"0"]) {
            [MBProgressHUD cc_showText:@"请输入主持人数量"];
            return ;
        }
        [dic setObject:_selectCount forKey:@"main"];
    }
    if ([distinct isEqualToString:@"s"] && [_detailModel.serviceType intValue] == 3) {
        [dic setObject:_selectIndex forKey:@"index"];
    }
    
    NSLog(@"payappsuccessdic %@",dic);
    [MainNetworkRequest newPayAppPayResult:dic success:^(id success) {
        NSLog(@"payappsuccess %@ %@",success,dic);
        if ([success[@"code"] integerValue] == successCodeOK) {
            if ([success[@"data"] isEqual:[NSNull null]] || success[@"data"] == nil) {
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                NSLog(@"不可以支付哦");
                [self presentTheAlertView];
            }else {
                _wechatPay = [[SIMWechatModel alloc] initWithDictionary:success[@"data"]];
                NSLog(@"wechatPayappid  %@",_wechatPay.appid);
                [[NSUserDefaults standardUserDefaults] setObject:success[@"data"][@"orderNum"] forKey:@"newPayOrderNum"];
                [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
                [self wechatNowPay];
                // 支付种类  钱包和计划
                [[NSUserDefaults standardUserDefaults] setObject:@"ProjectAdd" forKey:@"newOrderType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

- (void)presentTheAlertView {
    _backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backView.backgroundColor = [UIColor blackColor];
    _backView.alpha = 0.2;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    // 添加到窗口
    [window addSubview:_backView];
    
    _little = [[SIMPayResultAlertView alloc] initWithFrame:CGRectMake((screen_width - 280)/2, (screen_height - 180)/2, 280,155)];
    _little.dicFreeM = @{@"msg":@"升级成功",@"detail":@"您可前往->当前计划查看"};
    [window addSubview:_little];

    __weak typeof(self)weakSelf = self;
    // 保存按钮方法
    _little.saveClick = ^{
        [weakSelf tapClick];
//        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshMainPageData object:nil];
        SIMTabBarViewController *tabVc = (SIMTabBarViewController *)[UIApplication sharedApplication].delegate.window.rootViewController;
        UINavigationController *selectedNavc = (UINavigationController *)tabVc.selectedViewController;
        [selectedNavc popToRootViewControllerAnimated:NO];
        [tabVc setSelectedIndex:0];
        
    };
}
- (void)tapClick {
    [_backView removeFromSuperview];
    [_little removeFromSuperview];
}
#pragma mark 微信支付方法
- (void)wechatNowPay{
    //需要创建这个支付对象
    
    PayReq *req   = [[PayReq alloc] init];
    //由用户微信号和AppID组成的唯一标识，用于校验微信用户
    req.openID = _wechatPay.appid;
    
    // 商家id，在注册的时候给的
    req.partnerId = _wechatPay.partnerid;
    
    // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
    req.prepayId  = _wechatPay.prepayid;
    
    // 根据财付通文档填写的数据和签名
    //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
    req.package   = _wechatPay.package;
    
    // 随机编码，为了防止重复的，在后台生成
    req.nonceStr  = _wechatPay.noncestr;
    
    // 这个是时间戳，也是在后台生成的，为了验证支付的
    NSString * stamp = _wechatPay.timestamp;
    req.timeStamp = stamp.intValue;
    NSLog(@"stampone%@",stamp);
    NSLog(@"timeStamptwo%d",req.timeStamp);
    //    NSNumber *ts = [params valueForKey:@"timestamp"];
    //
    //    request.timeStamp = (UInt32) ts.longValue;
    
    
    // 这个签名也是后台做的
    req.sign = _wechatPay.sign;
    
    //发送请求到微信，等待微信返回onResp
//    [WXApi sendReq:req];
    [WXApi sendReq:req completion:^(BOOL success) {
        NSLog(@"aa");
    }];

//    [self.navigationController popViewControllerAnimated:YES];
}
// 计划详情
- (void)requestPlanDetailID:(NSString *)pid orderType:(NSString *)orderType {
    [MainNetworkRequest newPayPlanDetailResult:@{@"id":pid,@"orderType":orderType} success:^(id success) {
        NSLog(@"plandetailsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            _detailModel = [[SIMNewPlanDetailModel alloc] initWithDictionary:success[@"data"]];
            _detailModel.type = self.type;
            NSArray *infoarray = _detailModel.info_array;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
                if (infoarray.count == 0) {
                    // 如果infoarray为空 那么就用原先的info参数 infoarray是带季度价格的数组 info是不带季度价格的数组 只有年月
                    self.btnIndex = _detailModel.info.count-1;
                }else {
                    self.btnIndex = _detailModel.info_array.count-1;
                }
            }else {
                self.btnIndex = _detailModel.info.count-1;
            }
            
//            _selectCount = [_detailModel.main stringValue];
//            _selectIndex = [_detailModel.index stringValue];
            
            [self initSubTableView];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 设备详情
- (void)requestServiceDetailID:(NSString *)pid orderType:(NSString *)orderType {
    [MainNetworkRequest newPayServiceDetailResult:@{@"id":pid,@"orderType":orderType} success:^(id success) {
        NSLog(@"servicedetailsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            _detailModel = [[SIMNewPlanDetailModel alloc] initWithDictionary:success[@"data"]];
            _detailModel.type = self.type;
            if ([_detailModel.main intValue] == 0 || _detailModel.main == nil) {
                _selectCount = @"1";
            }else {
                _selectCount = [_detailModel.main stringValue];
            }
            if (_detailModel.index == nil) {
                _selectIndex = @"0";
            }else {
                _selectIndex = [_detailModel.index stringValue];
            }
            if (self.nowSModel != nil) { 
                _detailModel.isNowSer = @"nowS";
            }else {
                _detailModel.isNowSer = @"";
            }
            
            NSLog(@"ceshi_selectCount %@ %@",_selectCount,_selectIndex);
            [self initSubTableView];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}
// 教学模式详情
- (void)requestTeachModelDetailID:(NSString *)pid {
    [MainNetworkRequest classmodelDetailpayRequestParams:@{@"id":pid} success:^(id success) {
        NSLog(@"teachModelDetailsuccess %@",success);
        if ([success[@"code"] integerValue] == successCodeOK) {
            _detailModel = [[SIMNewPlanDetailModel alloc] initWithDictionary:success[@"data"]];
            _detailModel.type = self.type;
            if ([_detailModel.main intValue] == 0 || _detailModel.main == nil) {
                _selectCount = @"1";
            }else {
                _selectCount = [_detailModel.main stringValue];
            }
            if (_detailModel.index == nil) {
                _selectIndex = @"0";
            }else {
                _selectIndex = [_detailModel.index stringValue];
            }
            _detailModel.isNowSer = @""; // 教学模式没有当前计划查看的编辑
//            self.btnIndex = _detailModel.info.count-1;
            NSLog(@"ceshi_selectCount %@ %@",_selectCount,_selectIndex);
            [self initSubTableView];
        }else {
            [MBProgressHUD cc_showText:success[@"msg"]];
        }
    } failure:^(id failure) {
        [MBProgressHUD cc_showText:SIMLocalizedString(@"NETWORK_error_other", nil)];
    }];
}

// 选择器点击的回调
- (void)optionView:(SIMOptionView *)optionView selectedModel:(SIMOptionList *)listmodel {
    NSLog(@"optionView %@ listmodel: %@",optionView,listmodel.optionKey);
    //一个cell刷新
    _selectListModel = listmodel;
    _selectIndex = [listmodel.index stringValue];
    [UIView performWithoutAnimation:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

#pragma mark -- textFieldMethod
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string length] > 0) {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        //数据格式正确
        if (single >= '0' && single <= '9') {
            //首字母不能为0和小数点
            if([textField.text length] == 0) {
                if (single == '0') {
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    return NO;
                }
            }
        }
        return YES;
    }else {
        return YES;
    }
}
- (void)textFieldDidChange:(UITextField *)textField {
    
//    if (textField.text.length == 0) {
//        _selectCount = @"1";
//        textField.text = @"1";
//    }else {
        _selectCount = textField.text;
//    }
    NSLog(@"_selectCount %@",_selectCount);
    [UIView performWithoutAnimation:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:3 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark -- AppPurchaseDelegate
- (void)AppPurchaseShowErrorWithErrorDescription:(NSString *)description {
    [MBProgressHUD cc_showText:@"交易失败"];
}
- (void)AppPurchasedidBeginRequestProduct {
    [MBProgressHUD cc_showLoading:nil];
}
- (void)AppPurchaseBeingRequestPayment {
    [MBProgressHUD cc_showLoading:nil];
}
- (void)AppPurchaseDidEndPurchase {
    [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
}
- (void)AppPurchaseHasRestored {
    [MBProgressHUD hideHUDForView:[NSObject cc_keyWindow]];
}
- (void)AppPurchaseSuccess {
    [MBProgressHUD cc_showText:@"交易成功"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([_type isEqualToString:@"plan"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        #if TypeClassBao || TypeXviewPrivate

        #else
            [[SIMAppPurchaseTool shareInstace] stopManager];
        #endif
    }
}
- (void)dealloc {
    if ([_type isEqualToString:@"plan"] && ![[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"]) {
        #if TypeClassBao ||TypeXviewPrivate

        #else
            [[SIMAppPurchaseTool shareInstace] stopManager];
        #endif
    }
}


@end
