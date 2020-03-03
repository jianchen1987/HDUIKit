//
//  NSNumber+Extension.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "NSNumber+HDUIKit.h"

@implementation NSNumber (HDUIKit)
- (CGFloat)hd_CGFloatValue {
#if CGFLOAT_IS_DOUBLE
    return self.doubleValue;
#else
    return self.floatValue;
#endif
}
@end
