//
//  MLLivesView_TimeSelect.m
//  MeeLike
//
//  Created by mac126 on 2020/9/17.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "MLLivesView_TimeSelect.h"

@interface MLLivesCollectionCell_Date : UICollectionViewCell
@property (nonatomic, strong)UILabel * weekLabel;
@property (nonatomic, strong)UILabel * dayLabel;

-(void)weakString:(NSString *)weak dayString:(NSString *)day;

@end

@implementation MLLivesCollectionCell_Date
#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.weekLabel];
        [self addSubview:self.dayLabel];
        
        __weak typeof(self) weakself = self;
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(weakself.mas_centerX);
            make.bottom.mas_equalTo(weakself.mas_centerY).offset(kWidthScale(-10));
        }];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(kWidthScale(25.0));
            make.top.mas_equalTo(weakself.mas_centerY).offset(kWidthScale(5));
            make.centerX.mas_equalTo(weakself.mas_centerX);
        }];
    }
    return self;
}

#pragma mark - public methods
-(void)weakString:(NSString *)weak dayString:(NSString *)day{
    [self.weekLabel setText:weak];
    [self.dayLabel setText:day];
    [self layoutSubviews];
}

#pragma mark - private methods
- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.backgroundColor = [UIColor greenColor];
        self.weekLabel.textColor = [UIColor blackColor];
    }else{
        self.dayLabel.textColor = [UIColor blackColor];
        self.dayLabel.backgroundColor = [UIColor whiteColor];
        self.weekLabel.textColor = TableViewHeaderColor;
    }
}
#pragma mark - delegate

#pragma mark - selector

#pragma mark - getters and setters
-(UILabel *)weekLabel{
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc]init];
        _weekLabel.font = FontMediumName(15);
        _weekLabel.textColor = TableViewHeaderColor;
        _weekLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weekLabel;
}

-(UILabel *)dayLabel{
    if (!_dayLabel) {
        CGFloat w = kWidthScale(25.0);
        _dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, w, w)];
        _dayLabel.font = FontMediumName(15);
        _dayLabel.textColor = [UIColor blackColor];
        _dayLabel.layer.cornerRadius = (_dayLabel.frame.size.width / 2);
        _dayLabel.clipsToBounds = YES;
        _dayLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dayLabel;
}

@end

@interface MLLivesView_TimeSelect ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView * timeCollection;
@property(nonatomic, strong)NSMutableArray * itemArray;

@property (nonatomic, strong)NSArray * dateArray;
@property (nonatomic, strong)NSArray * weakArray;

@end

@implementation MLLivesView_TimeSelect

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dateArray = [NSArray arrayWithObjects:@"今日",@"五",@"六",@"日",@"一",@"二", nil];
        self.weakArray = [NSArray arrayWithObjects:@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
        [self addSubview:self.timeCollection];
    }
    return self;
}
#pragma mark - public methods
-(void)uploadWithArray:(NSArray *)mArray{
//    [self.itemArray addObjectsFromArray:mArray];
    self.itemArray = [mArray mutableCopy];
    [self.timeCollection reloadData];
}

#pragma mark - private methods

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idenfiter = @"MLLivesCollectionCell_Date";
    MLLivesCollectionCell_Date *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfiter forIndexPath:indexPath];
    [cell weakString:self.dateArray[indexPath.row] dayString:self.weakArray[indexPath.row]];
//    MLLivesModel_Items * item = [self.itemArray objectAtIndex:indexPath.row];
//    [cell weakString:item.weekString dayString:item.dayString];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate && [self.delegate respondsToSelector:@selector(livesSelectDate:)]) {
        MLLivesModel_Items * item = [self.itemArray objectAtIndex:indexPath.row];
        [self.delegate livesSelectDate:item];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (screen_width / 7.0);
    CGFloat h = kWidthScale(80);
    return CGSizeMake(w, h);
}

#pragma mark - selector

#pragma mark - getters and setters

-(UICollectionView *)timeCollection{
    if (!_timeCollection) {
        CGFloat w = (screen_width / 7.0);
        CGFloat h = kWidthScale(80.0);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(w,h);
        layout.minimumInteritemSpacing = 1;
        layout.minimumLineSpacing = 1;
        layout.sectionInset  = UIEdgeInsetsMake(0, 1, 1, 1);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        _timeCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width, kWidthScale(80.0)) collectionViewLayout:layout];
        _timeCollection.backgroundColor = [UIColor whiteColor];
        _timeCollection.delegate = self;
        _timeCollection.dataSource = self;
        [_timeCollection registerClass:[MLLivesCollectionCell_Date class] forCellWithReuseIdentifier:@"MLLivesCollectionCell_Date"];
    }
    return _timeCollection;
}


-(NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;;
}

@end
