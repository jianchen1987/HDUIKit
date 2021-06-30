//
//  HDImageBrowserToolViewHandler.h
//  HDUIKit
//
//  Created by VanJay on 2019/12/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YBImageBrowser/YBImageBrowser.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDImageBrowserToolViewHandler : NSObject <YBIBToolViewHandler>
@property (nonatomic, weak) UIView *sourceView;  ///< 源容器
@property (nonatomic, copy) void (^willChangeToIndexBlock)(NSUInteger index);

/// 更新投影 View 回调
@property (nonatomic, copy) UIView * (^updateProjectiveViewBlock)(NSUInteger index);
/// 保存图片结果回调
@property (nonatomic, copy) void (^saveImageResultBlock)(UIImage *image, NSError *_Nullable error);
/// 图片下载成功回调
@property (nonatomic, copy) void (^downloadImageSuccessBlock)(UIImage *image, NSURL *url);
/// 显示底部工具栏
- (void)showBottomBarView;
/// 隐藏底部工具栏
- (void)hideBottomBarView;
@end

NS_ASSUME_NONNULL_END
