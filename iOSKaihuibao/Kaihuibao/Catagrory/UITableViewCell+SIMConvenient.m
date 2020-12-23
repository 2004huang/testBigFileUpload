//
//  UITableViewCell+SIMConvenient.m
//  OralSystem
//
//  Created by Ferris on 2017/2/26.
//  Copyright © 2017年 Ferris. All rights reserved.
//

#import "UITableViewCell+SIMConvenient.h"

@implementation UITableViewCell (SIMConvenient)
+ (NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}
@end
