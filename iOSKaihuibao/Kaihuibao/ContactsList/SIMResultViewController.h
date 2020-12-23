//
//  SIMResultViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/5/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SIMPicture.h"
//#import "SIMNFList.h"
//#import "SIMNFPic.h"
//#import "SIMSquareList.h"

@interface SIMResultViewController : UIViewController

//@property (nonatomic, strong) SIMPicture *webAdress;
@property (nonatomic, strong) SIMBaseTableView *tableView;
//@property (nonatomic, assign) BOOL isNewHaveBtn;
@property (nonatomic, strong) NSArray *searchResults;
//@property (nonatomic, assign) BOOL isKeepfitlast;
//@property (nonatomic, assign) NSInteger shareType;
//@property (nonatomic, assign) NSInteger selectPage; // 1是本地通讯录分享进入 2是后台获取通讯录进入
//@property (nonatomic, assign) BOOL isUserContant;// 现在这个参数不需要了
@property (nonatomic, assign) BOOL isNeedChange; // 是从邀请进入还是添加
//@property (nonatomic, strong) SIMNFPic *nfPic;
//@property (nonatomic, strong) SIMSquareList_goodlist *gdDetail;
//@property (nonatomic, strong) SIMNFList_advert_all *adDetail;
//在MySearchResultViewController添加一个指向展示页的【弱】引用属性。
@property (nonatomic, weak) UIViewController *mainSearchController;


@end
