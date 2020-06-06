//
//  HDCommonViewController+NAT.m
//  HDUIKit
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDAssociatedObjectHelper.h"
#import "HDCommonViewController+NAT.h"
#import "HDTips.h"

@interface HDCommonViewController ()
@property (nonatomic, strong) HDTips *hud;  ///< 提示 HUD
@end

@implementation HDCommonViewController (NAT)
HDSynthesizeIdStrongProperty(hud, setHud);

#pragma mark - HUD
- (void)showloading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true];
        }
        self.hud = [HDTips showLoadingInView:self.view];
        @HDWeakify(self);
        self.hud.didHideBlock = ^(UIView *_Nonnull hideInView, BOOL animated) {
            @HDStrongify(self);
            [self.hud removeFromSuperview];
            self.hud = nil;
        };
    });
}

- (void)showloadingText:(id)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true];
        }
        self.hud = [HDTips showLoading:text inView:self.view];
        @HDWeakify(self);
        self.hud.didHideBlock = ^(UIView *_Nonnull hideInView, BOOL animated) {
            @HDStrongify(self);
            [self.hud removeFromSuperview];
            self.hud = nil;
        };
    });
}

- (void)dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:true afterDelay:0];
        }
    });
}
@end
