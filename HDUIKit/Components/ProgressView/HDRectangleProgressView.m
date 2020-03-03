//
//  HDRectangleProgressView.m
//  HDUIKit
//
//  Created by VanJay on 2020/1/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDRectangleProgressView.h"
#import "HDAppTheme.h"
#import "HDCommonDefines.h"

@interface HDRectangleProgressViewLayer : CALayer
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) float progress;
@property (nonatomic, assign) CFTimeInterval progressAnimationDuration;
@property (nonatomic, assign) BOOL shouldChangeProgressWithAnimation;  // default is YES
@property (nonatomic, assign) CGFloat borderInset;
@property (nonatomic, assign) CGFloat lineWidth;
@end

@implementation HDRectangleProgressViewLayer
// 加dynamic才能让自定义的属性支持动画
@dynamic fillColor;
@dynamic strokeColor;
@dynamic progress;
@dynamic lineWidth;
@dynamic borderInset;

- (instancetype)init {
    if (self = [super init]) {
        self.shouldChangeProgressWithAnimation = YES;
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    return [key isEqualToString:@"progress"] || [super needsDisplayForKey:key];
}

- (id<CAAction>)actionForKey:(NSString *)event {
    if ([event isEqualToString:@"progress"] && self.shouldChangeProgressWithAnimation) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:event];
        id fromValue = [self.presentationLayer valueForKey:event];
        if (!fromValue) {
            fromValue = @(0.0);
        }
        animation.fromValue = fromValue;
        animation.duration = self.progressAnimationDuration;
        return animation;
    }
    return [super actionForKey:event];
}

- (void)drawInContext:(CGContextRef)context {
    if (CGRectIsEmpty(self.bounds)) {
        return;
    }

    CGRect rect = CGRectMake(0, 0, self.progress * CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));

    CGPoint startPoint = CGPointMake(0, 0);
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddRect(context, rect);

    CGContextClosePath(context);
    CGContextFillPath(context);

    [super drawInContext:context];
}
@end

@implementation HDRectangleProgressView

+ (Class)layerClass {
    return [HDRectangleProgressViewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.tintColor = [HDAppTheme HDColorC1];
        self.borderWidth = 1;
        self.borderInset = 0;
        self.lineWidth = 5;

        [self didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
        // 从 xib 初始化的话，在 IB 里设置了 tintColor 也不会触发 tintColorDidChange，所以这里手动调用一下
        [self tintColorDidChange];
    }
    return self;
}

- (void)didInitialize {
    self.progress = 0.0;
    self.progressAnimationDuration = 0.5;

    self.layer.contentsScale = kScreenScale;  // 要显示指定一个倍数
    [self.layer setNeedsDisplay];
}

- (void)setProgress:(float)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    _progress = fmax(0.0, fmin(1.0, progress));
    self.progressLayer.shouldChangeProgressWithAnimation = animated;
    self.progressLayer.progress = _progress;

    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setProgressAnimationDuration:(CFTimeInterval)progressAnimationDuration {
    _progressAnimationDuration = progressAnimationDuration;
    self.progressLayer.progressAnimationDuration = progressAnimationDuration;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.progressLayer.borderWidth = borderWidth;
}

- (void)setBorderInset:(CGFloat)borderInset {
    _borderInset = borderInset;
    self.progressLayer.borderInset = borderInset;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    self.progressLayer.lineWidth = lineWidth;
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    self.progressLayer.fillColor = self.tintColor;
    self.progressLayer.strokeColor = self.tintColor;
    self.progressLayer.borderColor = self.tintColor.CGColor;
}

- (HDRectangleProgressViewLayer *)progressLayer {
    return (HDRectangleProgressViewLayer *)self.layer;
}
@end
