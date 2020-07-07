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
                   view.maxRowCount = 2;
                   view;
               })];

    HDUIGhostButton *button = HDUIGhostButton.new;

    button.titleLabel.hd_lineSpace = 15;
    [button setTitle:@"好几个号健身计划风口浪尖黑白短裤丽枫酒店返回的好几个号健身计划风口浪尖黑白短裤丽枫酒店返回的好几个号健身计划风口浪尖黑白短裤丽枫酒店返回的" forState:UIControlStateNormal];
    // 设置在
    [button setTitleColor:UIColor.greenColor forState:UIControlStateNormal];
    button.titleLabel.numberOfLines = 2;
    [self.view addSubview:button];

    [button hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo([button sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)]);
        make.centerX.hd_equalTo(CGRectGetWidth(self.view.frame) * 0.5);
        make.top.hd_equalTo(400);
    }];

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

    [self.floatLayoutView hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
        make.size.hd_equalTo([self.floatLayoutView sizeThatFits:CGSizeMake(300, CGFLOAT_MAX)]);
        make.centerX.hd_equalTo(CGRectGetWidth(self.view.frame) * 0.5);
        make.top.hd_equalTo(100);
    }];
    NSUInteger rowCount = [self.floatLayoutView fowardingTotalRowCountWithMaxSize:CGSizeMake(300, CGFLOAT_MAX)];
    HDLog(@"目标行数：%zd", rowCount);
}

@end
