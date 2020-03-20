//
//  HDSkeletonDefines.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#ifndef HDSkeletonDefines_h
#define HDSkeletonDefines_h

#define UIColorFromRGBA(rgbValue, alphaValue)                            \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
                     blue:((float)(rgbValue & 0x0000FF)) / 255.0         \
                    alpha:alphaValue]

#define UIColorFromRGB(rgbValue) UIColorFromRGBA(rgbValue, 1.0)

#define HDSkeletonColorFromRGBA(R, G, B, A) \
    [UIColor colorWithRed:(R) / 255.0       \
                    green:(G) / 255.0       \
                     blue:(B) / 255.0       \
                    alpha:1.0]

#define HDSkeletonColorFromRGB(R, G, B) HDSkeletonColorFromRGBA(R, G, B, 1.0)
#define HDSkeletonColorFromRGBV(V) HDSkeletonColorFromRGBA(V, V, V, 1.0)

#endif /* HDSkeletonDefines_h */
