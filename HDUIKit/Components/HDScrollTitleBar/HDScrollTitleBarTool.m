//
//  HDScrollTitleBarTool.m
//  HDUIKit
//
//  Created by VanJay on 2020/1/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDScrollTitleBarTool.h"
#import "UIColor+HDUIKit.h"

@implementation HDScrollTitleBarTool
+ (CGFloat)interpolationFrom:(CGFloat)from to:(CGFloat)to percent:(CGFloat)percent {
    percent = MAX(0, MIN(1, percent));
    return from + (to - from) * percent;
}

+ (UIColor *)interpolationColorFrom:(UIColor *)fromColor to:(UIColor *)toColor percent:(CGFloat)percent {
    CGFloat red = [self interpolationFrom:fromColor.hd_red to:toColor.hd_red percent:percent];
    CGFloat green = [self interpolationFrom:fromColor.hd_green to:toColor.hd_green percent:percent];
    CGFloat blue = [self interpolationFrom:fromColor.hd_blue to:toColor.hd_blue percent:percent];
    CGFloat alpha = [self interpolationFrom:fromColor.hd_alpha to:toColor.hd_alpha percent:percent];
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
@end
