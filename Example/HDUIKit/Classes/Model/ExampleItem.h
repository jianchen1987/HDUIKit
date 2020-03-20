//
//  ExampleItem.h
//  HDUIKitComponents
//
//  Created by VanJay on 2020/2/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExampleItem : NSObject
@property (nonatomic, copy) NSString *desc;        ///< 描述
@property (nonatomic, copy) NSString *destVcName;  ///< 目标控制器名称

+ (instancetype)itemWithDesc:(NSString *)desc destVcName:(NSString *)destVcName;
@end

NS_ASSUME_NONNULL_END
