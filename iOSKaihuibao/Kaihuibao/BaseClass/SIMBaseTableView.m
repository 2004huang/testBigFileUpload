//
//  SIMBaseTableView.m
//  Kaihuibao
//
//  Created by Ferris on 2017/3/30.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseTableView.h"

@implementation SIMBaseTableView

-(instancetype)initInViewController:(UIViewController<UITableViewDelegate,UITableViewDataSource> *)viewController
{
    if(self = [super initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:UITableViewStyleGrouped])
    {
        
        self.backgroundColor = TableViewBackgroundColor;
        [self setSeparatorColor:ZJYColorHex(@"#eeeeee")];
        [self setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        self.delegate = viewController;
        self.dataSource = viewController;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.estimatedRowHeight =0;
        self.estimatedSectionHeaderHeight =0;
        self.estimatedSectionFooterHeight =0;
        
        self.rowHeight = 50;
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
//        self.tableFooterView = footerView;
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)touchesBegan:(NSSet<UITouch*> *)touches withEvent:(UIEvent *)event{
//    [self endEditing:YES];
//    
//}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end
