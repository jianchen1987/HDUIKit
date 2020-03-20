//
//  HDCityModel.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, HDCitySelectLocationState) {
    HDCitySelectLocationStateDefault = 0,    ///< 未定位过
    HDCitySelectLocationStateProcessing,     ///< 处理中
    HDCitySelectLocationStateSuccees,        ///< 成功
    HDCitySelectLocationStateFailed,         ///< 失败
    HDCitySelectLocationStateKnownLocation,  ///< 未知位置
    HDCitySelectLocationStateUserDenyed,     ///< 用户拒绝授权
};

@interface HDCityModelCenterCoordinateModel : NSObject
@property (nonatomic, assign) double latitude;   ///< 经度
@property (nonatomic, assign) double longitude;  ///< 纬度

- (CLLocationCoordinate2D)coordiate2D;
- (void)setCoordiate2D:(CLLocationCoordinate2D)coordiate;

@end

@interface HDCityModel : NSObject
@property (nonatomic, copy) NSString *name;      ///< 内部自动处理名称，不做只读是可能会外部赋值
@property (nonatomic, copy) NSString *cnName;    ///< 中文名
@property (nonatomic, copy) NSString *enName;    ///< 英文名
@property (nonatomic, copy) NSString *cityCode;  ///< 城市编码
@property (nonatomic, copy) NSString *pinYin;
@property (nonatomic, copy) NSString *pinYinHead;
@property (nonatomic, strong) HDCityModelCenterCoordinateModel *centerCoordinate;  ///< 城市中心坐标
@property (nonatomic, copy) NSArray *districts;
@property (nonatomic, assign) BOOL isLocationCell;                      ///< 是否定位 cell
@property (nonatomic, assign) HDCitySelectLocationState locationState;  ///< 是否定位 cell
@property (nonatomic, assign) BOOL hidden;                              ///< 是否隐藏

@end
