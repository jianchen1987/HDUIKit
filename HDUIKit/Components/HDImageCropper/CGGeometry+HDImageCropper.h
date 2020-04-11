//
//  CGGeometry+HDImageCropper.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <tgmath.h>

#ifdef CGFLOAT_IS_DOUBLE
#define HD_EPSILON DBL_EPSILON
#define HD_MIN DBL_MIN
#else
#define HD_EPSILON FLT_EPSILON
#define HD_MIN FLT_MIN
#endif

struct HDLineSegment {
    CGPoint start;
    CGPoint end;
};
typedef struct HDLineSegment HDLineSegment;

CG_EXTERN const CGPoint HDPointNull;

CGPoint HDRectCenterPoint(CGRect rect);

CGRect HDRectNormalize(CGRect rect);

CGRect HDRectScaleAroundPoint(CGRect rect, CGPoint point, CGFloat sx, CGFloat sy);

bool HDPointIsNull(CGPoint point);

CGPoint HDPointRotateAroundPoint(CGPoint point, CGPoint pivot, CGFloat angle);

CGFloat HDPointDistance(CGPoint p1, CGPoint p2);

HDLineSegment HDLineSegmentMake(CGPoint start, CGPoint end);

HDLineSegment HDLineSegmentRotateAroundPoint(HDLineSegment lineSegment, CGPoint pivot, CGFloat angle);

CGPoint HDLineSegmentIntersection(HDLineSegment ls1, HDLineSegment ls2);
