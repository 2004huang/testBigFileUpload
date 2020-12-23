//
//  MBProgressHUD+CategoryCluster.h
//  Pods
//
//  Created by Draveness on 5/19/16.
//
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (CategoryCluster)

/**
 *  Add MBProgressHUD to key window with mode MBProgressHUDModeText
 *
 *  @param text  displays on the labelText
 *  @param delay Disappear after
 *
 *  @return A MBProgressHUD instance
 */
+ (MBProgressHUD *)cc_showText:(NSString *)text delay:(CGFloat)delay;
+ (MBProgressHUD *)cc_showText:(NSString *)text delay:(CGFloat)delay view:(UIView *)nowView;

/**
 *  Add MBProgressHUD to key window with mode MBProgressHUDModeText and delay 1.0
 *
 *  @param text  displays on the labelText
 *
 *  @return A MBProgressHUD instance
 */
+ (MBProgressHUD *)cc_showText:(NSString *)text;
+ (MBProgressHUD *)cc_showText:(NSString *)text view:(UIView *)nowView;

/**
 *  Show error with MBProgressHUD and delay 1.0 second
 *
 *  @param error An error
 *
 *  @return A MBProgressHUD instance
 */
+ (MBProgressHUD *)cc_showError:(NSError *)error;
+ (MBProgressHUD *)cc_showError:(NSError *)error view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showLoading:(NSString*)text delay:(CGFloat)delay;
+ (MBProgressHUD*)cc_showLoading:(NSString*)text delay:(CGFloat)delay view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showSuccess:(NSString*)text;
+ (MBProgressHUD*)cc_showSuccess:(NSString*)text view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showFail:(NSString*)text;
+ (MBProgressHUD*)cc_showFail:(NSString*)text view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showLoading:(NSString*)text;
+ (MBProgressHUD*)cc_showLoading:(NSString*)text view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showSuccessWithDetailText:(NSString *)text;
+ (MBProgressHUD*)cc_showSuccessWithDetailText:(NSString *)text view:(UIView *)nowView;
+ (MBProgressHUD*)cc_showFailWithDetailText:(NSString *)text;
+ (MBProgressHUD*)cc_showFailWithDetailText:(NSString *)text view:(UIView *)nowView;
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;


@end
