//
//  CGGeometry+HDImageCropper.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "CGGeometry+HDImageCropper.h"

#ifdef CGFLOAT_IS_DOUBLE
static const CGFloat kK = 9;
#else
static const CGFloat kK = 0;
#endif

const CGPoint HDPointNull = {INFINITY, INFINITY};

CGPoint HDRectCenterPoint(CGRect rect) {
    return CGPointMake(CGRectGetMinX(rect) + CGRectGetWidth(rect) / 2,
                       CGRectGetMinY(rect) + CGRectGetHeight(rect) / 2);
}

CGRect HDRectNormalize(CGRect rect) {
    CGPoint origin = rect.origin;

    CGFloat x = origin.x;
    CGFloat y = origin.y;
    CGFloat ceilX = ceil(x);
    CGFloat ceilY = ceil(y);

    if (fabs(ceilX - x) < pow(10, kK) * HD_EPSILON * fabs(ceilX + x) || fabs(ceilX - x) < HD_MIN ||
        fabs(ceilY - y) < pow(10, kK) * HD_EPSILON * fabs(ceilY + y) || fabs(ceilY - y) < HD_MIN) {

        origin.x = ceilX;
        origin.y = ceilY;
    } else {
        origin.x = floor(x);
        origin.y = floor(y);
    }

    CGSize size = rect.size;

    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat ceilWidth = ceil(width);
    CGFloat ceilHeight = ceil(height);

    if (fabs(ceilWidth - width) < pow(10, kK) * HD_EPSILON * fabs(ceilWidth + width) || fabs(ceilWidth - width) < HD_MIN ||
        fabs(ceilHeight - height) < pow(10, kK) * HD_EPSILON * fabs(ceilHeight + height) || fabs(ceilHeight - height) < HD_MIN) {

        size.width = ceilWidth;
        size.height = ceilHeight;
    } else {
        size.width = floor(width);
        size.height = floor(height);
    }

    return CGRectMake(origin.x, origin.y, size.width, size.height);
}

CGRect HDRectScaleAroundPoint(CGRect rect, CGPoint point, CGFloat sx, CGFloat sy) {
    CGAffineTransform translationTransform, scaleTransform;
    translationTransform = CGAffineTransformMakeTranslation(-point.x, -point.y);
    rect = CGRectApplyAffineTransform(rect, translationTransform);
    scaleTransform = CGAffineTransformMakeScale(sx, sy);
    rect = CGRectApplyAffineTransform(rect, scaleTransform);
    translationTransform = CGAffineTransformMakeTranslation(point.x, point.y);
    rect = CGRectApplyAffineTransform(rect, translationTransform);
    return rect;
}

bool HDPointIsNull(CGPoint point) {
    return CGPointEqualToPoint(point, HDPointNull);
}

CGPoint HDPointRotateAroundPoint(CGPoint point, CGPoint pivot, CGFloat angle) {
    CGAffineTransform translationTransform, rotationTransform;
    translationTransform = CGAffineTransformMakeTranslation(-pivot.x, -pivot.y);
    point = CGPointApplyAffineTransform(point, translationTransform);
    rotationTransform = CGAffineTransformMakeRotation(angle);
    point = CGPointApplyAffineTransform(point, rotationTransform);
    translationTransform = CGAffineTransformMakeTranslation(pivot.x, pivot.y);
    point = CGPointApplyAffineTransform(point, translationTransform);
    return point;
}

CGFloat HDPointDistance(CGPoint p1, CGPoint p2) {
    CGFloat dx = p1.x - p2.x;
    CGFloat dy = p1.y - p2.y;
    return sqrt(pow(dx, 2) + pow(dy, 2));
}

HDLineSegment HDLineSegmentMake(CGPoint start, CGPoint end) {
    return (HDLineSegment){start, end};
}

HDLineSegment HDLineSegmentRotateAroundPoint(HDLineSegment line, CGPoint pivot, CGFloat angle) {
    return HDLineSegmentMake(HDPointRotateAroundPoint(line.start, pivot, angle),
                             HDPointRotateAroundPoint(line.end, pivot, angle));
}

CGPoint HDLineSegmentIntersection(HDLineSegment ls1, HDLineSegment ls2) {
    CGFloat x1 = ls1.start.x;
    CGFloat y1 = ls1.start.y;
    CGFloat x2 = ls1.end.x;
    CGFloat y2 = ls1.end.y;
    CGFloat x3 = ls2.start.x;
    CGFloat y3 = ls2.start.y;
    CGFloat x4 = ls2.end.x;
    CGFloat y4 = ls2.end.y;

    CGFloat numeratorA = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3);
    CGFloat numeratorB = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3);
    CGFloat denominator = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1);

    if (fabs(numeratorA) < HD_EPSILON && fabs(numeratorB) < HD_EPSILON && fabs(denominator) < HD_EPSILON) {
        return CGPointMake((x1 + x2) * 0.5, (y1 + y2) * 0.5);
    }

    if (fabs(denominator) < HD_EPSILON) {
        return HDPointNull;
    }

    CGFloat uA = numeratorA / denominator;
    CGFloat uB = numeratorB / denominator;
    if (uA < 0 || uA > 1 || uB < 0 || uB > 1) {
        return HDPointNull;
    }

    return CGPointMake(x1 + uA * (x2 - x1), y1 + uA * (y2 - y1));
}
