//
//  HDFlowLayoutViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDFlowLayoutViewController.h"

@interface HDFlowLayoutViewController ()
/// floatLayoutView
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;
@end

@implementation HDFlowLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:({
                   HDFloatLayoutView *view = HDFloatLayoutView.new;
                   self.floatLayoutView = view;
                   view.padding = UIEdgeInsetsMake(10, 10, 10, 10);
                   view.itemMargins = UIEdgeInsetsMake(0, 0, 8, 8);
                   view;
               })];

    NSArray *titles = @[@"入金", @"入金2", @"入金w24", @"入34err金", @"入sdfdsdsf金", @"入sdfggsgg金", @"入金让人同仁堂短头发"];

    for (NSUInteger i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        HDUIGhostButton *view = HDUIGhostButton.new;
        view.spacingBetweenImageAndTitle = 20;
        // [view setImage:[UIImage imageNamed:@"b_merchant_detail_time"] forState:UIControlStateNormal];
        view.imagePosition = HDUIButtonImagePositionBottom;
        [view setTitle:title forState:UIControlStateNormal];
        view.backgroundColor = HDRandomColor;
        view.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [view sizeToFit];
        HDLog(@"size:%@", NSStringFromCGSize(view.size));
        [self.floatLayoutView addSubview:view];
    }

    [self.floatLayoutView wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
        make.size.wj_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)]);
        make.centerX.wj_equalTo(CGRectGetWidth(self.view.frame) * 0.5);
        make.top.wj_equalTo(100);
    }];
}

@end
