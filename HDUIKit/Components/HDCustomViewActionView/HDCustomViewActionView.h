//
//  HDCustomViewActionView.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDCustomViewActionViewConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDCustomViewActionView : HDActionAlertView

+ (instancetype)actionViewWithContentView:(UIView *)contentView config:(HDCustomViewActionViewConfig *__nullable)config;
- (instancetype)initWithContentView:(UIView *)contentView config:(HDCustomViewActionViewConfig *__nullable)config;
@end

NS_ASSUME_NONNULL_END
