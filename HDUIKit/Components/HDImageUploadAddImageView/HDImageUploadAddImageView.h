//
//  HDImageUploadAddImageView.h
//  HDUIKit
//
//  Created by VanJay on 2020/2/19.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDImageUploadAddImageView : UIView
///< 图片
@property (nonatomic, strong, readonly, nonnull) UIImageView *cameraImageView;
///< 描述，默认：上传图片，国际化在此设置
@property (nonatomic, strong, readonly) UILabel *descLabel;
@end

NS_ASSUME_NONNULL_END
