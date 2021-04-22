//
//  HDAnnouncementView.h
//  HDUIKit
//
//  Created by Chaos on 2021/4/22.
//

#import <UIKit/UIKit.h>
#import "HDMarqueeLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDAnnouncementViewConfig : NSObject

/// 公告内容
@property (nonatomic, copy) NSString *text;
/// 公告字体大小
@property (nonatomic, strong) UIFont *textFont;
/// 公告字体颜色
@property (nonatomic, strong) UIColor *textColor;
/// 背景色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 喇叭本地图片
@property (nonatomic, strong) UIImage *trumpetImage;
/// 内容间距
@property (nonatomic, assign) UIEdgeInsets contentInsets;
/// 公告与喇叭间距
@property (nonatomic, assign) NSUInteger trumpetToTextMargin;
/// 播放速率
@property (nonatomic, assign) CGFloat rate;
/// 滚动方式
@property (nonatomic, assign) HDMarqueeType marqueeType;
/// 公告尾部增加间隙
@property (nonatomic, assign) CGFloat leadingBuffer;
/// 公告首部增加间隙
@property (nonatomic, assign) CGFloat trailingBuffer;

@end

@interface HDAnnouncementView : UIView
/// 配置
@property (nonatomic, strong) HDAnnouncementViewConfig *config;
/// 点击回调
@property (nonatomic, copy) void (^tappedHandler)(void);
@end

NS_ASSUME_NONNULL_END
