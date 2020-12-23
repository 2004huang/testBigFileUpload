//
//  MLLivesView_TimeSelect.h
//  MeeLike
//
//  Created by mac126 on 2020/9/17.
//  Copyright © 2020 Ferris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLLivesModel_main.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MLLivesView_TimeSelectDelegate <NSObject>

-(void)livesSelectDate:(id)date;

@end

@interface MLLivesView_TimeSelect : UIView

@property(nonatomic, strong)id<MLLivesView_TimeSelectDelegate>delegate;
//@property(nonatomic, strong)MLLivesModel_Items * model;

-(void)uploadWithArray:(NSArray *)mArray;

@end

NS_ASSUME_NONNULL_END
