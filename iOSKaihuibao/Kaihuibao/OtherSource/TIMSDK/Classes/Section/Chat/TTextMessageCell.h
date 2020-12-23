//
//  TTextMessageCell.h
//  UIKit
//
//  Created by kennethmiao on 2018/9/17.
//  Copyright © 2018年 Tencent. All rights reserved.
//

#import "TMessageCell.h"

@interface TTextMessageCellData : TMessageCellData
@property (nonatomic, strong) NSString *content;
@end

@interface TTextMessageCell : TMessageCell<UITextViewDelegate>
@property (nonatomic, strong) UIImageView *bubble;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *urlArr;

@end