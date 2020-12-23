//
//  SIMBaseCommonTableViewCell.m
//  Kaihuibao
//
//  Created by Ferris on 2017/4/3.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseCommonTableViewCell.h"


@implementation SIMBaseCommonTableViewCell
{
    UIImageView* _leftImageView;
    UILabel* _label;
    UILabel* _promptLable;
    UITextField *_putin;
    UIImageView* _avatarImageView;
    UILabel *_iconLabel;
    UIImageView *_selectImg;
    UITextView *_textView;
    UILabel *_numLab;
    JJOptionView *_optionView;
}


-(instancetype)initWithTitle:(NSString *)title leftViewImage:(UIImage *)image
{
    if(self = [self init])
    {
        CGFloat imageHei = 35;
        _leftImageView.image = image;
        [self.contentView addSubview:_leftImageView];
        self.accessoryType = UITableViewCellAccessoryNone;
        _label.text = title;
        _label.textColor = BlueButtonColor;
        _label.font = FontRegularName(17);
        [self.contentView addSubview:_label];
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(imageHei);
            make.width.mas_equalTo(_leftImageView.mas_height);
        }];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_leftImageView.mas_right).offset(20);
        }];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title
{
    if(self = [self init]){
//        self.textLabel.text = title;
        _label.text = title;
        _label.font = FontRegularName(16);
        _label.textColor = BlackTextColor;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

-(instancetype)initWithTitleWithAccessory:(NSString *)title
{
    if(self = [self init]){
        self.accessoryType = UITableViewCellAccessoryNone;
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.font = FontRegularName(17);
        titleLab.textColor = BlueButtonColor;
        titleLab.text = title;
        titleLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLab];
        
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-40);
        }];
        
        UIButton *arrow= [UIButton buttonWithType:UIButtonTypeCustom];
        arrow.frame=CGRectMake(screen_width-40, 10, 30, 30);
        [arrow setImage:[UIImage imageNamed:@"gd_left"] forState:UIControlStateNormal];
        [self addSubview:arrow];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title prompt:(NSString *)prompt
{
    if(self = [self initWithTitle:title])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _promptLable.text = prompt;
        _promptLable.font = FontRegularName(15);
        _promptLable.textColor = GrayPromptTextColor;
        [self.contentView addSubview:_promptLable];
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(screen_width/3);
            make.height.mas_equalTo(30);
        }];
        
    }
    return self;
}
-(instancetype)initWithJSBTitle:(NSString *)title prompt:(NSString *)prompt
{
    if(self = [self initWithTitle:title])
    {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _promptLable.text = prompt;
        _promptLable.font = FontRegularName(15);
        _promptLable.textColor = GrayPromptTextColor;
        [self.contentView addSubview:_promptLable];
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(screen_width/3);
            make.height.mas_equalTo(30);
        }];
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ZJYColorHex(@"#eeeeee");
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).offset(-1);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(screen_width);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    
    return self;
}
-(instancetype)initWithLeftImage:(NSString *)imageIcon Title:(NSString *)title prompt:(NSString *)prompt
{
    if(self = [self init])
    {
        CGFloat imageHei = 23;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _leftImageView.image = [UIImage imageNamed:imageIcon];
        [self.contentView addSubview:_leftImageView];
        _leftImageView.contentMode = UIViewContentModeCenter;
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(imageHei);
            make.width.mas_equalTo(_leftImageView.mas_height);
        }];
        
        _label.text = title;
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(17);
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_leftImageView.mas_right).offset(20);
        }];
        
        _promptLable.text = prompt;
        _promptLable.font = FontRegularName(15);
        _promptLable.textColor = GrayPromptTextColor;
        [self.contentView addSubview:_promptLable];
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(screen_width/3);
            make.height.mas_equalTo(30);
        }];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title expalinPrompt:(NSString *)prompt
{
    if(self = [self init])
    {
        UILabel *explainLab = [[UILabel alloc] init];
        explainLab.text = title;
        explainLab.font = FontRegularName(16);
        explainLab.textColor = BlackTextColor;
        [self.contentView addSubview:explainLab];
        [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
            make.width.mas_equalTo((screen_width-kWidthScale(20)));
        }];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        _promptLable.text = prompt;
        _promptLable.numberOfLines = 0;
        _promptLable.textAlignment = NSTextAlignmentLeft;
        _promptLable.font = FontRegularName(15);
        _promptLable.textColor = GrayPromptTextColor;
        [self.contentView addSubview:_promptLable];
        
        [_promptLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(explainLab.mas_bottom).offset(5);
            make.left.mas_equalTo(kWidthScale(15));
            make.right.mas_equalTo(-kWidthScale(15));
            make.bottom.mas_equalTo(-12);
        }];
        
//        UIView *botmV = [[UIView alloc] init];
//        [self.contentView addSubview:botmV];
//
//        [botmV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_promptLable.mas_bottom);
//            make.left.mas_equalTo(kWidthScale(15));
//            make.right.mas_equalTo(-kWidthScale(15));
//            make.height.mas_equalTo(-12);
//            make.bottom.mas_equalTo(0);
//        }];
        
//        [self setupAutoHeightWithBottomView:_promptLable bottomMargin:12];
    }
    return self;
}
-(instancetype)initWithJSBTitleWithTextView:(NSString *)title withNumber:(NSString *)numCount {
    if(self = [self init])
    {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *explainLab = [[UILabel alloc] init];
        explainLab.text = title;
        explainLab.font = FontRegularName(16);
        explainLab.textColor = BlackTextColor;
        [self.contentView addSubview:explainLab];
        [explainLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(12);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
            make.width.mas_equalTo((screen_width-kWidthScale(20)));
        }];
        
        _textView = [[UITextView alloc] init];
        _textView.textColor = BlackTextColor;
        _textView.font = FontRegularName(15);
        [self.contentView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(explainLab.mas_bottom).offset(5);
            make.left.mas_equalTo(kWidthScale(15));
            make.right.mas_equalTo(-kWidthScale(15));
            make.height.mas_equalTo(100);
        }];
        
        _numLab = [[UILabel alloc] init];
        _numLab.textColor = GrayPromptTextColor;
        _numLab.font = FontRegularName(14);
        _numLab.textAlignment = NSTextAlignmentRight;
        _numLab.text = numCount;
        [self.contentView addSubview:_numLab];
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.right.mas_equalTo(-15);
        }];
    }
    return self;
}
-(instancetype)initWithJSBTitle:(NSString *)title rightViewImage:(NSURL *)imageurl
{
    if(self = [self init]){
//        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
        CGRect frame = CGRectMake(0, 0, screen_width, 90);
        UIImageView *imgview = [[UIImageView alloc]initWithFrame:frame];
        UIGraphicsBeginImageContext(imgview.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGContextScaleCTM(context, frame.size.width, frame.size.height);
        CGFloat colors[] = {
            181.0/255.0, 74.0/255.0, 198.0/255.0, 1.0,
            126.0/255.0, 88.0/255.0, 184.0/255.0, 1.0,
        };
        CGGradientRef backGradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));
        CGColorSpaceRelease(rgb);
        CGContextDrawLinearGradient(context, backGradient, CGPointMake(0, 0), CGPointMake(1.0, 0), kCGGradientDrawsBeforeStartLocation);
        
        UIImageView *backImage = [[UIImageView alloc] initWithFrame:frame];
        backImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.contentView addSubview:backImage];
        
        _label.text = title;
        _label.font = FontRegularName(16);
        _label.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
        }];
        
        CGFloat avaterHei = 60;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 这里是 self.currentUser.avatar
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        _avatarImageView.layer.cornerRadius = avaterHei/2.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(avaterHei);
        }];
    }
    return self;
}


-(instancetype)initWithTitle:(NSString *)title rightViewImage:(NSURL *)imageurl
{
    if(self = [self initWithTitle:title])
    {
        CGFloat avaterHei = 60;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 这里是 self.currentUser.avatar
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        _avatarImageView.layer.cornerRadius = avaterHei/2.0;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(avaterHei);
        }];
    }
    return self;
}

-(instancetype)initWithLeftIcon:(NSString *)iconStr Title:(NSString *)title rightViewImage:(NSURL *)imageurl
{
    if(self = [self init])
    {
        CGFloat imageHei = 23;
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        _leftImageView.image = [UIImage imageNamed:iconStr];
        [self.contentView addSubview:_leftImageView];
        _leftImageView.contentMode = UIViewContentModeCenter;
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.height.mas_equalTo(imageHei);
            make.width.mas_equalTo(_leftImageView.mas_height);
        }];
        
        _label.text = title;
        _label.textColor = BlackTextColor;
        _label.font = FontRegularName(17);
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(_leftImageView.mas_right).offset(20);
        }];
        
        CGFloat avaterHei = 40;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        // 这里是 self.currentUser.avatar
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView sd_setImageWithURL:imageurl placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        _avatarImageView.layer.cornerRadius = 17;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarImageView];
        [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(avaterHei);
        }];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title putin:(NSString *)putin
{
    if(self = [self initWithTitle:title])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _putin = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, kWidthScale(200), 40)];
        self.accessoryType = UITableViewCellAccessoryNone;
        _putin.textAlignment = NSTextAlignmentRight;
//        _putin.placeholder = @"可选";
        _putin.clearButtonMode = UITextFieldViewModeWhileEditing;
        _putin.textColor = BlackTextColor;
//        [_putin setValue:GrayPromptTextColor forKeyPath:@"attributedPlaceholder"];
//        [_putin setValue:FontRegularName(15) forKeyPath:@"_placeholderLabel.font"];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:SIMLocalizedString(@"ConfModesOptionsTitle", nil) attributes:
        @{NSForegroundColorAttributeName:GrayPromptTextColor,
                     NSFontAttributeName:FontRegularName(15)
             }];
        _putin.attributedPlaceholder = attrString;
//        [self.contentView addSubview:_putin];
        self.accessoryView = _putin;
//        [_putin mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(0);
//            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(20);
//            make.left.mas_equalTo(screen_width/2);
//
//        }];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title isChooseMore:(BOOL)isChooseMore optionViewArr:(NSArray *)arr viewController:(UIViewController<JJOptionViewDelegate> *)viewController {
    if (self = [self init]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _label.text = title;
        _label.font = FontRegularName(16);
        _label.textColor = BlackTextColor;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
        }];
        
        _optionView = [[JJOptionView alloc] init];
        _optionView.borderWidth = 0.0;
        _optionView.title = @"";
        _optionView.isMoreChoose = isChooseMore;
        _optionView.backgroundColor = self.backgroundColor;
        _optionView.titleFontSize = kWidthScale(14);
        _optionView.dataSource = arr;
        _optionView.delegate = viewController;
        [self.contentView addSubview:_optionView];
        [_optionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(kWidthScale(15) + 60);
        }];
    }
    return self;
}
-(instancetype)initWithTitle:(NSString *)title leftputin:(NSString *)putin
{
    if(self = [self initWithTitle:title])
    {
        _label.text = title;
        _label.font = FontRegularName(16);
        _label.textColor = BlackTextColor;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(kWidthScale(15));
            make.height.mas_equalTo(30);
        }];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _putin = [[UITextField alloc] init];
        self.accessoryType = UITableViewCellAccessoryNone;
        _putin.textAlignment = NSTextAlignmentLeft;
//        _putin.placeholder = @"";
        _putin.clearButtonMode = UITextFieldViewModeWhileEditing;
        _putin.textColor = TableViewHeaderColor;
        _putin.text = putin;
        _putin.placeholder = SIMLocalizedString(@"CCMemberAddPage_Request", nil);
        _putin.font = FontRegularName(16);
        _putin.textColor = BlackTextColor;
        [self.contentView addSubview:_putin];
        [_putin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(45);
            make.left.mas_equalTo(_label.mas_right).offset(25);
        }];
    }
    return self;
}
-(instancetype)init
{
    if(self = [super init])
    {
        self.preservesSuperviewLayoutMargins = NO;
        self.separatorInset = UIEdgeInsetsZero;
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        _leftImageView = [[UIImageView alloc] init];
        
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = FontRegularName(15);
        _label.textColor = RGB(46, 46, 46);
        
        _promptLable = [[UILabel alloc] init];
        _promptLable.textAlignment  = NSTextAlignmentRight;
        _promptLable.font = FontRegularName(12);
        _promptLable.textColor = RGB(123, 124, 130);
    }
    return self;
}
-(instancetype)initWithActionTitle:(NSString *)title
{
    if(self = [self init])
    {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FontRegularName(17);
        _label.textColor = [UIColor redColor];
        _label.text = title;
        [self.contentView addSubview:_label];
        [_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
        }];
    }
    return self;
}
-(UIImageView *)leftImageView
{
    return _leftImageView;
}
-(UILabel *)label
{
    return _label;
}
-(UILabel *)promptLabel
{
    return _promptLable;
}
-(UITextField *)putin {
    return _putin;
}
-(UIImageView *)avatarImageView
{
    return _avatarImageView;
}

- (UILabel *)iconLabel {
    return _iconLabel;
}

- (UITextView *)textView {
    return _textView;
}
- (UILabel *)numLab {
    return _numLab;
}
- (JJOptionView *)optionView {
    return _optionView;
}



@end
