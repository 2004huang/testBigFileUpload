//
//  SIMContactTableView.m
//  Kaihuibao
//
//  Created by mac126 on 2019/5/14.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import "SIMContactTableView.h"

@implementation SIMContactTableView
-(instancetype)initPlainInViewController:(UIViewController<UITableViewDelegate,UITableViewDataSource> *)viewController style:(UITableViewStyle)style{
    if(self = [super initWithFrame:CGRectMake(0, 0, screen_width, screen_height - StatusNavH) style:style])
    {
        self.delegate = viewController;
        self.dataSource = viewController;
        
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        self.estimatedRowHeight =0;
        self.estimatedSectionHeaderHeight =0;
        self.estimatedSectionFooterHeight =0;
        
        [self setSeparatorColor:ZJYColorHex(@"#e3e3e4")];
        self.backgroundColor = [UIColor whiteColor];
        self.tableFooterView = [[UIView alloc] init];
    }
    return self;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
    [super touchesBegan:touches withEvent:event];
}

@end
