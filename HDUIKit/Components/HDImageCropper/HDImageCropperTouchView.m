//
//  HDImageCropperTouchView.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDImageCropperTouchView.h"

@implementation HDImageCropperTouchView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.receiver;
    }
    return nil;
}

@end
