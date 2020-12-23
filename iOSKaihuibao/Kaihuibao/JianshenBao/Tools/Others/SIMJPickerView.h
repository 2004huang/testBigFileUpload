//
//  SIMJPickerView.h
//  Kaihuibao
//
//  Created by mac126 on 2019/3/20.
//  Copyright © 2019年 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^selectPickBlock)(NSString *pickDate);
@interface SIMJPickerView : UIView

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *selectStr;

@property (nonatomic,strong)selectPickBlock callBlock;

-(void)show;
-(void)hidden;

@end

NS_ASSUME_NONNULL_END
