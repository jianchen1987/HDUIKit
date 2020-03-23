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
            [self.hud removeFromSuperview];
            self.hud = nil;
        }
        self.hud = [HDTips showLoadingInView:self.view];
    });
}

- (void)dismissLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.hud) {
            [self.hud hideAnimated:YES afterDelay:0];
        }
    });
}
@end
