//
//  SIMAnnotationView.m
//  Kaihuibao
//
//  Created by 王小琪 on 17/7/6.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMAnnotationView.h"
@implementation SIMAnnotationView

#define Arror_height        10

- (instancetype)initWithFrame:(CGRect)frame {
    if (self= [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
        self.alpha = 0.9;
        
        _name = [[UILabel alloc] init];
        _name.text = self.currentUser.nickname;
        _name.font = FontRegularName(kWidthScale(16));
        _name.textColor = BlackTextColor;
        [self addSubview:self.name];
        
        _content = [[UILabel alloc] init];
        _content.font = FontRegularName(kWidthScale(10));
        _content.text = SIMLocalizedString(@"CCMapTitleDetail", nil);
        _content.textColor = GrayPromptTextColor;
        [self addSubview:self.content];
        
        _confId = [[UILabel alloc] init];
        _confId.font = FontRegularName(kWidthScale(16));
        _confId.text = self.currentUser.self_conf;
        _confId.textColor = BlueButtonColor;
        [self addSubview:self.confId];
        
        CGFloat avatarHeight = kWidthScale(60);
        _iconView = [[UIImageView alloc] init];
        [_iconView sd_setImageWithURL:[NSURL URLWithString: self.currentUser.avatar] placeholderImage:[UIImage imageNamed:@"avatar"] options:SDWebImageAllowInvalidSSLCertificates];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = avatarHeight/2.0f;
        [self addSubview:_iconView];
        
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:_line];
        
        
        _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inviteBtn setTitle:SIMLocalizedString(@"CGVideoClick", nil) forState:UIControlStateNormal];
        [_inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _inviteBtn.layer.cornerRadius = kWidthScale(30)/4;
        _inviteBtn.layer.masksToBounds = YES;
        [_inviteBtn setBackgroundColor:BlueButtonColor];
        _inviteBtn.titleLabel.font = FontRegularName(18);
        [_inviteBtn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.inviteBtn];
        
        _iconView.sd_layout.topSpaceToView(self,kWidthScale(10)).heightIs(kWidthScale(60)).widthEqualToHeight().rightSpaceToView(self,kWidthScale(10));
        _name.sd_layout.leftSpaceToView(self,kWidthScale(15)).topSpaceToView(self,kWidthScale(10)).heightIs(kWidthScale(20)).rightSpaceToView(_iconView, -kWidthScale(5));
        _content.sd_layout.leftEqualToView(_name).topSpaceToView(_name,kWidthScale(8)).heightIs(kWidthScale(10)).widthIs(kWidthScale(100));
        _confId.sd_layout.leftEqualToView(_name).topSpaceToView(_content,kWidthScale(5)).heightIs(kWidthScale(20)).widthIs(kWidthScale(150));
        _line.sd_layout.leftSpaceToView(self,kWidthScale(15)).topSpaceToView(_confId,kWidthScale(10)).heightIs(1).rightSpaceToView(self,kWidthScale(15));
        _inviteBtn.sd_layout.leftSpaceToView(self,kWidthScale(15)).topSpaceToView(_line,kWidthScale(8)).heightIs(kWidthScale(30)).rightSpaceToView(self,kWidthScale(15));
        
        
    }return self;
}
- (void)saveBtn {
    if (self.inviteClick) {
        self.inviteClick();
    }
}

#pragma mark - draw rect

-(void)drawRect:(CGRect)rect{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    self.layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    
    self.layer.shadowOpacity = 1.0;
    self.layer.masksToBounds = NO;
    self.layer.shadowRadius=10.0;
    self.layer.shadowOffset = CGSizeMake(5.0f, 5.0f);
    
}

-(void)drawInContext:(CGContextRef)context

{
    CGContextSetLineWidth(context, 2.0);
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context

{
    
    CGRect rrect = self.bounds;
    
    CGFloat radius = 10.0;
    
    CGFloat minx = CGRectGetMinX(rrect),
    
    midx = CGRectGetMidX(rrect),
    
    maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect),
    
    // midy = CGRectGetMidY(rrect),
    
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    
    CGContextClosePath(context);
    
}


@end
