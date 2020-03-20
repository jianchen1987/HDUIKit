//
//  HDCityModel.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCityModel.h"
#import "HDCommonDefines.h"
#import <YYModel/YYModel.h>

@implementation HDCityModelCenterCoordinateModel

- (CLLocationCoordinate2D)coordiate2D {
    return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

- (void)setCoordiate2D:(CLLocationCoordinate2D)coordiate {
    self.latitude = coordiate.latitude;
    self.longitude = coordiate.longitude;
}

@end

@implementation HDCityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.centerCoordinate = HDCityModelCenterCoordinateModel.new;
    }
    return self;
}

- (NSString *)name {
    // TODO: 修改此处判断
    BOOL isCn = YES;
    NSString *name = isCn ? self.cnName : self.enName;
    if (!name || name.length <= 0) return _name;
    return name;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}

- (NSUInteger)hash {
    return [self yy_modelHash];
}

- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
@end
