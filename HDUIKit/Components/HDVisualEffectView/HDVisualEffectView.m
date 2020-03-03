//
//  HDVisualEffectView.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDVisualEffectView.h"
#import "CALayer+HDUIKit.h"

@interface HDVisualEffectView ()
@property (nonatomic, strong) CALayer *foregroundLayer;
@end

@implementation HDVisualEffectView

- (instancetype)initWithEffect:(nullable UIVisualEffect *)effect {
    if (self = [super initWithEffect:effect]) {
        [self didInitialize];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self didInitialize];
    }
    return self;
}

- (void)didInitialize {
    self.foregroundLayer = [CALayer layer];
    [self.foregroundLayer hd_removeDefaultAnimations];
    [self.contentView.layer addSublayer:self.foregroundLayer];
}

- (void)setForegroundColor:(UIColor *)foregroundColor {
    _foregroundColor = foregroundColor;
    self.foregroundLayer.backgroundColor = foregroundColor.CGColor;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.foregroundLayer.frame = self.contentView.bounds;
}
@end
