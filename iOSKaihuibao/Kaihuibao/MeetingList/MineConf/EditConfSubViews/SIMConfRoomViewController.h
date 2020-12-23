//
//  SIMConfRoomViewController.h
//  Kaihuibao
//
//  Created by 王小琪 on 17/6/1.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "SIMBaseViewController.h"
#import "ArrangeConfModel.h"
@protocol SIMConfRoomViewdelegate <NSObject>
- (void)contentString:(NSString *)content;
@end
@interface SIMConfRoomViewController : SIMBaseViewController
@property (nonatomic, assign) id <SIMConfRoomViewdelegate>delegate;
@property (nonatomic, strong) ArrangeConfModel *myConf;
@end
