//
//  HDUnitTextFieldTextRange.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDUnitTextFieldTextPosition.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDUnitTextFieldTextRange : UITextRange <NSCopying>

@property (nonatomic, readonly) HDUnitTextFieldTextPosition *start;
@property (nonatomic, readonly) HDUnitTextFieldTextPosition *end;

@property (nonatomic, readonly) NSRange range;

+ (nullable instancetype)rangeWithStart:(HDUnitTextFieldTextPosition *)start end:(HDUnitTextFieldTextPosition *)end;

+ (nullable instancetype)rangeWithRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
