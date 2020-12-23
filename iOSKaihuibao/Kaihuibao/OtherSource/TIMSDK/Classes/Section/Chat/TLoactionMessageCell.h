//
//  TLoactionMessageCell.h
//  Kaihuibao
//
//  Created by mac126 on 2019/8/8.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "TMessageCell.h"
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface TLoactionMessageCellData : TMessageCellData
@property (nonatomic, strong) NSString *loacionStr;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@end

@interface TLoactionMessageCell : TMessageCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subLab;
@property (nonatomic, strong) MAMapView *mapView;
@end

NS_ASSUME_NONNULL_END
