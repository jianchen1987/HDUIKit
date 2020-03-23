//
//  HDSkeletonLayer.m
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSkeletonLayer.h"
#import "HDCommonDefines.h"
#import "HDSkeletonDefines.h"
#import "UIBezierPath+HDKitCore.h"

#define kShadowWidth (self.bounds.size.width * 0.9)
#define kShadowHeight (self.bounds.size.height * 0.9)
static NSString *const kSkeletonAnimationKey = @"kSkeletonAnimationKey";

@interface HDSkeletonLayer ()
@property (nonatomic, strong) CAGradientLayer *skeletonLayer;
@end

@implementation HDSkeletonLayer
- (void)commonInit {
    _layerColor = HDSkeletonColorFromRGB(242.0, 244.0, 247.0);
    _animationStyle = HDSkeletonLayerAnimationStyleGradientLeftToRight;
    _animationDuration = 1.f;
    _gradientLayerColor = HDSkeletonColorFromRGB(255.0, 257.0, 255.0);
    _skeletonCornerRadius = 5;

    [self setup];
}

- (instancetype)initWithLayer:(id)layer {
    self = [super initWithLayer:layer];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = self.layerColor.CGColor;
    self.masksToBounds = YES;
    [self performAnimation];
}

- (void)setAnimationStyle:(HDSkeletonLayerAnimationStyle)animationStyle {
    if (_animationStyle == animationStyle) return;

    _animationStyle = animationStyle;
    [self.skeletonLayer removeFromSuperlayer];
    [self performAnimation];
}

- (void)setLayerColor:(UIColor *)layerColor {
    if (_layerColor == layerColor) return;

    _layerColor = layerColor;
    self.backgroundColor = self.layerColor.CGColor;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration {
    if (_animationDuration == animationDuration) return;

    _animationDuration = animationDuration;
    [self.skeletonLayer removeFromSuperlayer];
    [self performAnimation];
}

- (void)setGradientLayerColor:(UIColor *)gradientLayerColor {
    if (_gradientLayerColor == gradientLayerColor) return;

    _gradientLayerColor = gradientLayerColor;
    [self.skeletonLayer removeFromSuperlayer];
    self.skeletonLayer = nil;
    [self performAnimation];
}

- (void)setSkeletonCornerRadius:(CGFloat)skeletonCornerRadius {
    if (_skeletonCornerRadius == skeletonCornerRadius) return;

    _skeletonCornerRadius = skeletonCornerRadius;

    [self drawCornerRadius];
}

#pragma mark - public methods
- (void)performAnimation {
    switch (self.animationStyle) {
        case HDSkeletonLayerAnimationStyleSolid: {
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @1.;
            animation.toValue = @0.5;
            animation.duration = self.animationDuration;
            animation.repeatCount = INFINITY;
            animation.autoreverses = YES;
            animation.removedOnCompletion = NO;
            [self addAnimation:animation forKey:kSkeletonAnimationKey];
            break;
        }

        case HDSkeletonLayerAnimationStyleGradientLeftToRight:
        case HDSkeletonLayerAnimationStyleGradientRightToLeft:
        case HDSkeletonLayerAnimationStyleGradientTopToBottom:
        case HDSkeletonLayerAnimationStyleGradientBottomToTop: {
            CABasicAnimation *animation = [self animationForSlideAnimationStyle:self.animationStyle];
            [self.skeletonLayer addAnimation:animation forKey:kSkeletonAnimationKey];
            [self addSublayer:self.skeletonLayer];
        } break;

        default:
            break;
    }
}

#pragma mark - private methods
- (CABasicAnimation *)animationForSlideAnimationStyle:(HDSkeletonLayerAnimationStyle)style {
    CGSize size = self.bounds.size;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = self.animationDuration;
    animation.repeatCount = INFINITY;
    animation.removedOnCompletion = NO;
    switch (style) {
        case HDSkeletonLayerAnimationStyleGradientLeftToRight: {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(-kShadowWidth * 0.5, size.height * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(size.width + kShadowWidth * 0.5, size.height * 0.5)];
            self.skeletonLayer.frame = CGRectMake(0, 0, kShadowWidth, size.height);
            self.skeletonLayer.startPoint = CGPointMake(0, 0.5);
            self.skeletonLayer.endPoint = CGPointMake(1, 0.5);
        } break;
        case HDSkeletonLayerAnimationStyleGradientRightToLeft: {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(size.width + kShadowWidth * 0.5, size.height * 0.5)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(-kShadowWidth * 0.5, size.height * 0.5)];
            self.skeletonLayer.frame = CGRectMake(0, 0, kShadowWidth, size.height);
            self.skeletonLayer.startPoint = CGPointMake(1, 0.5);
            self.skeletonLayer.endPoint = CGPointMake(0, 0.5);
        } break;
        case HDSkeletonLayerAnimationStyleGradientTopToBottom: {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(size.width * 0.5, -kShadowHeight)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(size.width * 0.5, size.height + kShadowHeight)];
            self.skeletonLayer.frame = CGRectMake(0, 0, size.width, kShadowHeight);
            self.skeletonLayer.startPoint = CGPointMake(0.5, 0);
            self.skeletonLayer.endPoint = CGPointMake(0.5, 1);
        } break;
        case HDSkeletonLayerAnimationStyleGradientBottomToTop: {
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(size.width * 0.5, size.height + kShadowHeight)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(size.width * 0.5, -kShadowHeight)];
            self.skeletonLayer.frame = CGRectMake(0, 0, size.width, kShadowHeight);
            self.skeletonLayer.startPoint = CGPointMake(0.5, 1);
            self.skeletonLayer.endPoint = CGPointMake(0.5, 0);
        } break;

        default:
            break;
    }
    return animation;
}

- (void)drawCornerRadius {
    if (CGSizeIsEmpty(self.bounds.size)) return;

    UIBezierPath *maskPath = [UIBezierPath hd_bezierPathWithRoundedRect:self.bounds cornerRadiusArray:@[@(self.skeletonCornerRadius), @(self.skeletonCornerRadius), @(self.skeletonCornerRadius), @(self.skeletonCornerRadius)] lineWidth:0];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];

    [self drawCornerRadius];
}

#pragma mark - lazy load
- (CAGradientLayer *)skeletonLayer {
    if (!_skeletonLayer) {
        _skeletonLayer = [CAGradientLayer layer];
        UIColor *color = self.gradientLayerColor;
        _skeletonLayer.colors = @[
            (id)[color colorWithAlphaComponent:0.01].CGColor,
            (id)[color colorWithAlphaComponent:0.02].CGColor,
            (id)[color colorWithAlphaComponent:0.03].CGColor,
            (id)[color colorWithAlphaComponent:0.09].CGColor,
            (id)[color colorWithAlphaComponent:0.15].CGColor,
            (id)[color colorWithAlphaComponent:0.21].CGColor,
            (id)[color colorWithAlphaComponent:0.27].CGColor,
            (id)[color colorWithAlphaComponent:0.30].CGColor,
            (id)[color colorWithAlphaComponent:0.33].CGColor,
            (id)[color colorWithAlphaComponent:0.36].CGColor,
            (id)[color colorWithAlphaComponent:0.33].CGColor,
            (id)[color colorWithAlphaComponent:0.30].CGColor,
            (id)[color colorWithAlphaComponent:0.27].CGColor,
            (id)[color colorWithAlphaComponent:0.21].CGColor,
            (id)[color colorWithAlphaComponent:0.15].CGColor,
            (id)[color colorWithAlphaComponent:0.09].CGColor,
            (id)[color colorWithAlphaComponent:0.03].CGColor,
            (id)[color colorWithAlphaComponent:0.02].CGColor,
            (id)[color colorWithAlphaComponent:0.01].CGColor
        ];
    }
    return _skeletonLayer;
}

@end
