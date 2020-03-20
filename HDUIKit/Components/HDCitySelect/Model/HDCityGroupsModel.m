//
//  HDCityGroupsModel.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCityGroupsModel.h"
#import "HDCityModel.h"
#import <YYModel/YYModel.h>

@implementation HDCityGroupsModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"cities": HDCityModel.class,
    };
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    NSArray<NSDictionary *> *cities = dic[@"cities"];
    NSArray<HDCityModel *> *citiesModel = [NSArray yy_modelArrayWithClass:HDCityModel.class json:cities];
    // 移除隐藏的
    _cities = [citiesModel filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(HDCityModel *model, NSDictionary *bindings) {
                               return !model.hidden;
                           }]];
    return YES;
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
