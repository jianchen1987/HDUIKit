//
//  HDTableViewSectionModel.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HDTableHeaderFootViewModel;

NS_ASSUME_NONNULL_BEGIN

@interface HDTableViewSectionModel : NSObject
@property (nonatomic, strong) HDTableHeaderFootViewModel *headerModel;  ///< 表头数据模型
@property (nonatomic, copy) NSArray *__nullable list;                   ///< 列表数据
@property (nonatomic, strong) id commonHeaderModel;                     ///< 通用表头数据模型
@end

NS_ASSUME_NONNULL_END
