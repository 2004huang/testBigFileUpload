//
//  SIMAvatarTableViewCell.m
//  Kaihuibao
//
//  Created by Ferris on 2017/4/11.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAvatarTableViewCell.h"
@interface SIMAvatarTableViewCell()
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *vipLabel;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UILabel *mailLabel;
@property (nonatomic, strong) UILabel *longLine;
@property (nonatomic, strong) UILabel *stortLine;
@property (nonatomic, strong) UILabel *phoneLine;
@property (nonatomic, strong) UIButton *nowPlan;
@end
@implementation SIMAvatarTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.contentView.backgroundColor = [UIColor whiteColor];
        _avatarImageView = [[UIImageView alloc] init];
        // 这里是 self.currentUser.avatar
//        NSString *path = [NSString stringWithFormat:@"http://video.kaihuibao.net/customer/img/%@", self.currentUser.avatar];
        
        [_avatarImageView sd_setImageWithURL:[NSURL URLWithString: self.currentUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
       
//        if (self.currentUser.isVip) {
//            CGFloat avatarH = 20;
//            _vipLabel = [[UIImageView alloc] init];
//            _vipLabel.layer.cornerRadius = avatarH/2.0;
//            _vipLabel.layer.masksToBounds = YES;
//            _vipLabel.backgroundColor = [UIColor redColor];
//            [self.contentView addSubview:_vipLabel];
//            [_vipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(avatarH);
//                make.left.mas_equalTo(_avatarImageView.mas_right).offset(-20);
//                make.top.mas_equalTo(_avatarImageView.mas_bottom).offset(-20);
//            }];
//        }
        
        
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.font = FontRegularName(18);
        _nickNameLabel.textColor = BlackTextColor;
        _nickNameLabel.text = self.currentUser.nickname;// 姓名
        [self.contentView addSubview:_nickNameLabel];
        
        _phoneLine = [[UILabel alloc] init];
        _phoneLine.font = FontRegularName(15);
        _phoneLine.textAlignment = NSTextAlignmentCenter;
        _phoneLine.textColor = TableViewHeaderColor;
        _phoneLine.text = self.currentUser.mobile;// 电话
        [self.contentView addSubview:_phoneLine];
       
        _mailLabel = [[UILabel alloc] init];
        _mailLabel.font = FontRegularName(13);
        _mailLabel.textAlignment = NSTextAlignmentLeft;
        _mailLabel.text = self.currentUser.email;// 邮箱
        _mailLabel.textColor = TableViewHeaderColor;
        [self.contentView addSubview:_mailLabel];
        
        _longLine = [[UILabel alloc] init];
        _longLine.backgroundColor = ZJYColorHex(@"#e5e5e5");
        [self.contentView addSubview:_longLine];
        
        _nowPlan =[[UIButton alloc] init];
        [_nowPlan setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nowPlan.titleLabel.font = FontRegularName(10);
        _nowPlan.backgroundColor = ZJYColorHex(@"#f73f43");
        [self.contentView addSubview:_nowPlan];//一定要先添加到视图上
    }
    return  self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat avatarHeight = 60;
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(avatarHeight);
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(kWidthScale(15));
    }];
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.layer.cornerRadius = avatarHeight/2.0f;
    
    [_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_avatarImageView.mas_centerY).offset(-7);
        make.left.mas_equalTo(_avatarImageView.mas_right).offset(kWidthScale(15));
        make.right.mas_lessThanOrEqualTo(-kWidthScale(70));
    }];
    
    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_avatarImageView.mas_right).offset(kWidthScale(15));
        make.top.mas_equalTo(_avatarImageView.mas_centerY).offset(7);
    }];
    
    [_mailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_phoneLine.mas_right).offset(kWidthScale(11));
        make.centerY.mas_equalTo(_phoneLine.mas_centerY);
        make.bottom.mas_equalTo(_avatarImageView.mas_bottom).offset(-3);
    }];
    
    // 后设置这个短线和长线 根据内容判断 暂时不要短线 因为没有邮箱
    if (self.currentUser.email.length > 0) {
        _stortLine = [[UILabel alloc] init];
        _stortLine.backgroundColor = ZJYColorHex(@"#e5e5e5");
        [self.contentView addSubview:_stortLine];
        [_stortLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_mailLabel.mas_left).offset(-kWidthScale(5));
            make.width.mas_equalTo(1);
            make.top.mas_equalTo(_mailLabel.mas_top);
            make.bottom.mas_equalTo(_mailLabel.mas_bottom);
        }];
        [_longLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
            make.left.mas_equalTo(_phoneLine.mas_left);
            make.right.mas_equalTo(_mailLabel.mas_right);
            make.height.mas_equalTo(1);
            
        }];
    }else {
        [_longLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_avatarImageView.mas_centerY);
            make.left.mas_equalTo(_phoneLine.mas_left);
            make.right.mas_equalTo(-kWidthScale(40));
            make.height.mas_equalTo(1);
            
        }];
    }
    
    NSString *planStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentPlanName"];
#if TypeClassBao || TypeXviewPrivate
    if (planStr != nil && [[NSUserDefaults standardUserDefaults] boolForKey:@"showTheWechat"] && [self.cloudVersion.plan boolValue]) {
        [_nowPlan setTitle:planStr forState:UIControlStateNormal];
        CGSize size = [planStr sizeWithAttributes:@{NSFontAttributeName:FontRegularName(10)}];
        CGFloat width = size.width + 15;
        CGFloat height = 15;
        _nowPlan.layer.cornerRadius = height/2;
        _nowPlan.layer.masksToBounds = YES;
        _nowPlan.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        //    _nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width-10 - width/2) , page  * (Button_Height + Height_Space)+Start_Y - 10, width, 18);
        [_nowPlan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.mas_equalTo(_nickNameLabel.mas_top);
            make.left.mas_equalTo(_nickNameLabel.mas_right);
        }];
    }
#else
    if (planStr != nil && [self.cloudVersion.plan boolValue]) {
        [_nowPlan setTitle:planStr forState:UIControlStateNormal];
        CGSize size = [planStr sizeWithAttributes:@{NSFontAttributeName:FontRegularName(10)}];
        CGFloat width = size.width + 15;
        CGFloat height = 15;
        _nowPlan.layer.cornerRadius = height/2;
        _nowPlan.layer.masksToBounds = YES;
        _nowPlan.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        //    _nowPlan.frame = CGRectMake(index * (Button_Width + Width_Space) + Start_X + (Button_Width-10 - width/2) , page  * (Button_Height + Height_Space)+Start_Y - 10, width, 18);
        [_nowPlan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.mas_equalTo(_nickNameLabel.mas_top);
            make.left.mas_equalTo(_nickNameLabel.mas_right);
        }];
    }
#endif
    
}

@end
