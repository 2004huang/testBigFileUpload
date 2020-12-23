//
//  MBProgressHUD+CategoryCluster.m
//  Pods
//
//  Created by Draveness on 5/19/16.
//
//

#import "MBProgressHUD+CategoryCluster.h"

@implementation MBProgressHUD (CategoryCluster)

+ (MBProgressHUD *)cc_showText:(NSString *)text delay:(CGFloat)delay {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.minShowTime = 1;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}
+ (MBProgressHUD *)cc_showText:(NSString *)text delay:(CGFloat)delay view:(UIView *)nowView {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.mode = MBProgressHUDModeText;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}

+ (MBProgressHUD *)cc_showText:(NSString *)text{
    return [self cc_showText:text delay:2];
}
+ (MBProgressHUD *)cc_showText:(NSString *)text view:(UIView *)nowView{
    return [self cc_showText:text delay:2.0 view:nowView];
}

+ (MBProgressHUD *)cc_showError:(NSError *)error {
    return [self cc_showText:error.description];
}
+ (MBProgressHUD *)cc_showError:(NSError *)error view:(UIView *)nowView{
    return [self cc_showText:error.description view:nowView];
}
+(MBProgressHUD *)cc_showLoading:(NSString *)text delay:(CGFloat)delay
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.numberOfLines = 0;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
      [hud hideAnimated:YES afterDelay:delay];
    return hud;
}
+(MBProgressHUD *)cc_showLoading:(NSString *)text delay:(CGFloat)delay  view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = text;
    hud.label.numberOfLines = 0;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:delay];
    return hud;
}
+(MBProgressHUD *)cc_showLoading:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.label.text = text;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.numberOfLines = 0;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    return hud;
}
+(MBProgressHUD *)cc_showLoading:(NSString *)text view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:nowView animated:YES];
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    hud.label.text = text;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.numberOfLines = 0;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    return hud;
}
+(MBProgressHUD *)cc_showFail:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.mode =MBProgressHUDModeCustomView;
    hud.label.numberOfLines = 0;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    hud.customView = imageView;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}
+(MBProgressHUD *)cc_showFail:(NSString *)text  view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.label.numberOfLines = 0;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    hud.customView = imageView;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}

+(MBProgressHUD *)cc_showSuccess:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.label.numberOfLines = 0;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    hud.customView = imageView;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
      [hud hideAnimated:YES afterDelay:1.5];
    return hud;
}
+(MBProgressHUD *)cc_showSuccess:(NSString *)text view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.label.numberOfLines = 0;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    hud.customView = imageView;
    if(text)
    {
        hud.label.text = text;
        hud.label.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:1];
    return hud;
}
+(MBProgressHUD *)cc_showFailWithDetailText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    hud.customView = imageView;
    if(text)
    {
        hud.detailsLabel.text = text;
        hud.detailsLabel.numberOfLines = 0;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
    hud.label.numberOfLines = 0;
      [hud hideAnimated:YES afterDelay:1];
    return hud;

}
+(MBProgressHUD *)cc_showFailWithDetailText:(NSString *)text view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.numberOfLines = 0;
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fail"]];
    hud.customView = imageView;
    if(text)
    {
        hud.detailsLabel.text = text;
        hud.detailsLabel.numberOfLines = 0;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:1];
    return hud;
    
}
+(MBProgressHUD *)cc_showSuccessWithDetailText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[NSObject cc_keyWindow]];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:[NSObject cc_keyWindow] animated:YES];
    }
    hud.label.numberOfLines = 0;
    hud.label.font = FontRegularName(kWidthS(13));
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    hud.customView = imageView;
    if(text)
    {
        hud.detailsLabel.text = text;
        hud.detailsLabel.numberOfLines = 0;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
      [hud hideAnimated:YES afterDelay:0.5];
    return hud;
}
+(MBProgressHUD *)cc_showSuccessWithDetailText:(NSString *)text  view:(UIView *)nowView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:nowView];
    if(!hud)
    {
        hud =[MBProgressHUD showHUDAddedTo:nowView animated:YES];
    }
    hud.label.font = FontRegularName(kWidthS(13));
    hud.label.numberOfLines = 0;
    hud.mode =MBProgressHUDModeCustomView;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
    hud.customView = imageView;
    if(text)
    {
        hud.detailsLabel.text = text;
        hud.detailsLabel.numberOfLines = 0;
        hud.detailsLabel.textColor = [UIColor whiteColor];
    }
    [hud hideAnimated:YES afterDelay:0.5];
    return hud;
}
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

@end
