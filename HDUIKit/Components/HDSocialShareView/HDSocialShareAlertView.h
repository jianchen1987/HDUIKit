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

typedef void (^ClickedItemHandler)(HDSocialShareAlertView *alertView, HDSocialShareCellModel *model, NSInteger index);

@interface HDSocialShareAlertView : HDActionAlertView

/// 分享弹窗
/// @param title 标题
/// @param cancelTitle 取消按钮文字
/// @param shareData 分享渠道数组
/// @param functionData 功能按钮数组
/// @param config 配置
+ (instancetype)alertViewWithTitle:(NSString *__nullable)title
                       cancelTitle:(NSString *__nullable)cancelTitle
                         shareData:(NSArray<HDSocialShareCellModel *> *__nullable)shareData
                      functionData:(NSArray<HDSocialShareCellModel *> *__nullable)functionData
                            config:(HDSocialShareAlertViewConfig *__nullable)config;

/// 分享弹窗
/// @param title 标题
/// @param cancelTitle 取消按钮文字
/// @param shareData 分享渠道数组
/// @param functionData 功能按钮数组
/// @param config 配置
- (instancetype)initWithTitle:(NSString *__nullable)title
                  cancelTitle:(NSString *__nullable)cancelTitle
                    shareData:(NSArray<HDSocialShareCellModel *> *__nullable)shareData
                 functionData:(NSArray<HDSocialShareCellModel *> *__nullable)functionData
                       config:(HDSocialShareAlertViewConfig *__nullable)config;

@property (nonatomic, copy) ClickedItemHandler clickedShareItemHandler;  ///< 选择了分享渠道
@property (nonatomic, copy) ClickedItemHandler clickedFunctionItemHandler;  ///< 选择了功能按钮
@end

NS_ASSUME_NONNULL_END
