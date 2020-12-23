//
//  TLoactionMessageCell.m
//  Kaihuibao
//
//  Created by mac126 on 2019/8/8.
//  Copyright © 2019 Ferris. All rights reserved.
//

#import "TLoactionMessageCell.h"
#import "THeader.h"


@implementation TLoactionMessageCellData
@end

@interface TLoactionMessageCell ()
@end
@implementation TLoactionMessageCell
//- (CGFloat)getHeight:(TLoactionMessageCellData *)data;
//{
//    return 100;
//}

- (CGSize)getContainerSize:(TLoactionMessageCellData *)data
{
    return TLoactionMessageCell_Container_Size;
}

- (void)setupViews
{
    [super setupViews];
    
    super.container.backgroundColor = [UIColor whiteColor];
    super.container.layer.cornerRadius = 5;
    [super.container.layer setMasksToBounds:YES];
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    [super.container addSubview:_backView];
    
    _titleLab = [[UILabel alloc] init];
    _titleLab.font = [UIFont systemFontOfSize:16];
    _titleLab.textColor = BlackTextColor;
    [_backView addSubview:_titleLab];
    
    _subLab = [[UILabel alloc] init];
    _subLab.font = [UIFont systemFontOfSize:12];
    _subLab.textColor = GrayPromptTextColor;
    [_backView addSubview:_subLab];
    
    _mapView = [[MAMapView alloc] init];
    _mapView.scrollEnabled = NO;
    _mapView.rotateEnabled = NO;
    _mapView.zoomEnabled = NO;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    _mapView.userInteractionEnabled = NO;
    [_mapView setZoomLevel:15 animated:YES];
    [super.container addSubview:_mapView];
    
}
- (void)setData:(TLoactionMessageCellData *)data {
    [super setData:data];
    NSLog(@"IM接受到的位置信息:{lat:%f; lon:%f; str:%@} ",data.latitude,data.longitude,data.loacionStr);
    if ([data.loacionStr containsString:@","]) {
        NSArray *array = [data.loacionStr componentsSeparatedByString:@","];
        
        _titleLab.text = array[0];
        _subLab.text = array[1];
    }else {
        _titleLab.text = data.loacionStr;
        _subLab.text = @"";
    }
    
    
    _backView.frame = CGRectMake(0, 0, super.container.frame.size.width, 50);
    _mapView.frame = CGRectMake(0, 50, super.container.frame.size.width, super.container.frame.size.height - 50);
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(data.latitude, data.longitude);
    [_mapView addAnnotation:pointAnnotation];
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(data.latitude, data.longitude)];

    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(22);
    }];
    [_subLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLab.mas_bottom).offset(3);
        make.height.mas_equalTo(15);
    }];
}

@end
