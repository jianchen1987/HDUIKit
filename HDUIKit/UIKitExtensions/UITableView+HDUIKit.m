//
//  UITableView+HD.m
//  HDUIKit
//
//  Created by VanJay on 2019/12/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDLog.h"
#import "HDRunTime.h"
#import "NSObject+HDUIKit.h"
#import "UITableView+HDUIKit.h"

@implementation UITableView (HDUIKit)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        OverrideImplementation([UITableView class], @selector(scrollToRowAtIndexPath:atScrollPosition:animated:), ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
            return ^(UITableView *selfObject, NSIndexPath *indexPath, UITableViewScrollPosition scrollPosition, BOOL animated) {
                if (!indexPath) {
                    return;
                }

                BOOL isIndexPathLegal = YES;
                NSInteger numberOfSections = [selfObject numberOfSections];
                if (indexPath.section >= numberOfSections) {
                    isIndexPathLegal = NO;
                } else if (indexPath.row != NSNotFound) {
                    NSInteger rows = [selfObject numberOfRowsInSection:indexPath.section];
                    isIndexPathLegal = indexPath.row < rows;
                }
                if (!isIndexPathLegal) {
                    HDLogWarn(@"UITableView (HDUIKit)", @"%@ - target indexPath : %@ ，不合法的indexPath。\n%@", selfObject, indexPath, [NSThread callStackSymbols]);
                    NSAssert(NO, @"出现不合法的indexPath");
                    return;
                }

                // call super
                void (*originSelectorIMP)(id, SEL, NSIndexPath *, UITableViewScrollPosition, BOOL);
                originSelectorIMP = (void (*)(id, SEL, NSIndexPath *, UITableViewScrollPosition, BOOL))originalIMPProvider();
                originSelectorIMP(selfObject, originCMD, indexPath, scrollPosition, animated);
            };
        });
    });
}

// 防止 release 版本滚动到不合法的 indexPath 会 crash
- (void)hd_scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    if (!indexPath) {
        return;
    }

    BOOL isIndexPathLegal = YES;
    NSInteger numberOfSections = [self numberOfSections];
    if (indexPath.section >= numberOfSections) {
        isIndexPathLegal = NO;
    } else if (indexPath.row != NSNotFound) {
        NSInteger rows = [self numberOfRowsInSection:indexPath.section];
        isIndexPathLegal = indexPath.row < rows;
    }
    if (!isIndexPathLegal) {
        HDLogWarn(@"UITableView (HDUIKit)", @"%@ - target indexPath : %@ ，不合法的indexPath。\n%@", self, indexPath, [NSThread callStackSymbols]);
        NSAssert(NO, @"出现不合法的indexPath");
    } else {
        [self hd_scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
    }
}

- (void)hd_performBatchUpdates:(void(NS_NOESCAPE ^ _Nullable)(void))updates completion:(void (^_Nullable)(BOOL finished))completion {
    if (@available(iOS 11.0, *)) {
        [self performBatchUpdates:updates completion:completion];
    } else {
        if (!updates && completion) {
            completion(YES);  // 私有方法对 updates 为空的情况，不会调用 completion，但 iOS 11 新增的方法是可以的，所以这里对齐新版本的行为
        } else {
            [self hd_performSelector:NSSelectorFromString([NSString stringWithFormat:@"_%@BatchUpdates:%@:", @"perform", @"completion"]) withArguments:&updates, &completion, nil];
        }
    }
}
@end
