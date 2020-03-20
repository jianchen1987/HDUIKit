//
//  HDScrollTitleBarViewButton.h
//  HDUIKit
//
//  Created by VanJay on 2019/10/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDScrollTitleBarViewCellModel : NSObject
@property (nonatomic, copy) NSString *title;       ///< 按钮标题
@property (nonatomic, copy) NSString *bubbleText;  ///< 气泡文字
@property (nonatomic, copy) UIImage *bubbleImage;  ///< 气泡图片，优先级高于文字
@end

@interface HDScrollTitleBarViewButton : UIButton
@property (nonatomic, assign) NSUInteger index;                      ///< 索引
@property (nonatomic, strong) UIButton *maskButton;                  ///< mask
@property (nonatomic, strong) CALayer *maskLayer;                    ///< mask layer
@property (nonatomic, strong) HDScrollTitleBarViewCellModel *model;  ///< model
@end

NS_ASSUME_NONNULL_END
