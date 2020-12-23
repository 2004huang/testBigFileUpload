//
//  SIMConfIDQRCodeViewController.m
//  Kaihuibao
//
//  Created by mac126 on 2020/2/11.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import "SIMConfIDQRCodeViewController.h"

#import <CoreImage/CoreImage.h>
#import "UIImage+Interpolated.h"
#import <Photos/Photos.h>

@interface SIMConfIDQRCodeViewController ()
@property (nonatomic, strong) UIImageView *mag;
@property (nonatomic, strong) UIView *backView;

@end

@implementation SIMConfIDQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = SIMLocalizedString(@"ErweimaSendTitle", nil);
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.borderColor = ZJYColorHex(@"#eeeeee").CGColor;
    _backView.layer.borderWidth = 0.5;
    _backView.userInteractionEnabled = YES;
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kWidthScale(50));
        make.height.mas_equalTo(kWidthScale(260));
        make.width.mas_equalTo(kWidthScale(220));
    }];
    
    _mag = [[UIImageView alloc] init];
    _mag.backgroundColor = ZJYColorHex(@"#eeeeee");
    [_backView addSubview:_mag];
    [_mag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.width.mas_equalTo(kWidthScale(200));
        make.top.mas_equalTo(kWidthScale(10));
    }];
    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = SIMLocalizedString(@"ErweimaSendPicText", nil);
    lab.font = FontRegularName(kWidthScale(13));
    lab.textColor = GrayPromptTextColor;
    lab.textAlignment = NSTextAlignmentCenter;
    [_backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(kWidthScale(10));
        make.right.mas_equalTo(-kWidthScale(10));
        make.top.mas_equalTo(_mag.mas_bottom).offset(kWidthScale(15));
    }];
    
    
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [_backView addGestureRecognizer:ges];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = SIMLocalizedString(@"ErweimaSendText", nil);
    label.font = FontRegularName(kWidthScale(14));
    label.textColor = GrayPromptTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(_backView.mas_bottom).offset(kWidthScale(40));
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    [self creatCIQRCodeImage];
    
}
/**
 *  生成二维码
 */
- (void)creatCIQRCodeImage
{
    // 1.创建过滤器，这里的@"CIQRCodeGenerator"是固定的
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 2.恢复默认设置
    [filter setDefaults];
    
    // 3. 给过滤器添加数据
    NSString *dataString = self.confURL;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 注意，这里的value必须是NSData类型
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 4. 生成二维码
    CIImage *outputImage = [filter outputImage];
    
    // 5. 显示二维码
    _mag.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:kWidthScale(200)];
}

-(void)longPressAction:(UILongPressGestureRecognizer*)gesture {
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self saveToTheLibrary];
        }];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:SIMLocalizedString(@"AlertCCancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:action];
        [alertC addAction:action3];
        alertC.popoverPresentationController.sourceView = self.view;
        alertC.popoverPresentationController.sourceRect = _mag.frame;
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
}

- (void)saveToTheLibrary {
    UIImage *changeImage = [self convertViewToImage:_backView];
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        //写入图片到相册
        [PHAssetChangeRequest creationRequestForAssetFromImage:changeImage];
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        NSLog(@"success = %d, error = %@", success, error);
        if (success == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD cc_showText:SIMLocalizedString(@"ErweimaSendSuccessText", nil)];
                NSLog(@"保存成功");
            });
        }
    }];
}

//将backImageView子视图合成一张图片
-(UIImage *)convertViewToImage:(UIView*)v
{
    CGSize size = v.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [v.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    v.layer.contents = nil;
    return image;
}

@end
