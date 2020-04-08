//
//  HDSocialShareAlertView.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import "HDSocialShareAlertViewConfig.h"
#import "HDSocialShareCellModel.h"

@class HDSocialShareAlertView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^ClickedShareItemHandler)(HDSocialShareAlertView *alertView, HDSocialShareCellModel *model, NSInteger index);

@interface HDSocialShareAlertView : HDActionAlertView
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle dataSource:(NSArray<HDSocialShareCellModel *> *)dataSource config:(HDSocialShareAlertViewConfig *__nullable)config;
- (instancetype)initWithTitle:(NSString *__nullable)title cancelTitle:(NSString *__nullable)cancelTitle dataSource:(NSArray<HDSocialShareCellModel *> *)dataSource config:(HDSocialShareAlertViewConfig *__nullable)config;

@property (nonatomic, copy) ClickedShareItemHandler clickedShareItemHandler;  ///< 选择了分享渠道
@end

NS_ASSUME_NONNULL_END
