//
//  HDCategoryViewAnimator.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HDCategoryViewAnimator : NSObject
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, copy) void (^progressCallback)(CGFloat percent);
@property (nonatomic, copy) void (^completeCallback)(void);
@property (readonly, getter=isExecuting) BOOL executing;

- (void)start;
- (void)stop;
- (void)invalid;
@end
