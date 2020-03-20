//
//  HDCitySelectViewController.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCityModel.h"
#import "HDCommonViewController.h"
@class HDCitySelectViewController;

@protocol HDCitySelectViewControllerDelegate <NSObject>

- (void)citySelectViewController:(HDCitySelectViewController *)controller didSelectedCicy:(HDCityModel *)cityModel;

/// 最近搜索的城市
/// @param controller 城市选择器
- (NSArray<HDCityModel *> *)citySelectViewControllerRecentlyCitys:(HDCitySelectViewController *)controller;

/// 保存最近搜索的城市
/// @param controller 城市选择器
/// @param citys 城市
- (void)citySelectViewController:(HDCitySelectViewController *)controller saveRecentlyCitys:(NSArray<HDCityModel *> *)citys;

@required
/// 暂时定位未授权的提示，记得在 info.plist 中配置 NSLocationWhenInUseUsageDescription
/// @param controller 城市选择器
- (void)citySelectViewControllerShowUnAuthedTip:(HDCitySelectViewController *)controller;
@end

@interface HDCitySelectViewController : HDCommonViewController

- (instancetype)initWithDelegate:(id)delegate;

@property (nonatomic, weak) id<HDCitySelectViewControllerDelegate> delegate;

@property (nonatomic, strong) HDCityModel *currentCityModel;  ///< 当前城市

@end
