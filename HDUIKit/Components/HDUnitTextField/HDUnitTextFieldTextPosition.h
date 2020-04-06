//
//  HDUnitTextFieldTextPosition.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDUnitTextFieldTextPosition : UITextPosition <NSCopying>

@property (nonatomic, readonly) NSInteger offset;

+ (instancetype)positionWithOffset:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
