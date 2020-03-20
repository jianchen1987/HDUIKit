//
//  HDCityGroupsModel.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HDCityModel;

@interface HDCityGroupsModel : NSObject

/** 城市数组*/
@property (nonatomic, copy) NSArray<HDCityModel *> *cities;

/** 分类标题 */
@property (nonatomic, copy) NSString *title;

@end
