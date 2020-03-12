
//
//  HDGridViewViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDGridViewViewController.h"

@interface HDGridViewViewController ()
/// gridView
@property (nonatomic, strong) HDGridView *gridView;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider1;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider2;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider3;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider4;
/// 拖动条
@property (nonatomic, strong) HDUISlider *slider5;
@end

@implementation HDGridViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.slider = [[HDUISlider alloc] init];
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];

    self.slider1 = [[HDUISlider alloc] init];
    [self.slider1 addTarget:self action:@selector(sliderValueChanged1:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider1];

    self.slider2 = [[HDUISlider alloc] init];
    [self.slider2 addTarget:self action:@selector(sliderValueChanged2:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider2];

    self.slider3 = [[HDUISlider alloc] init];
    [self.slider3 addTarget:self action:@selector(sliderValueChanged3:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider3];

    self.slider4 = [[HDUISlider alloc] init];
    [self.slider4 addTarget:self action:@selector(sliderValueChanged4:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider4];

    self.slider5 = [[HDUISlider alloc] init];
    [self.slider5 addTarget:self action:@selector(sliderValueChanged5:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider5];

    HDGridView *gridView = ({
        HDGridView *view = HDGridView.new;
        view.rowHeight = 60;
        view.columnCount = 3;
        view.edgeInsets = UIEdgeInsetsMake(5, 10, 2, 15);
        view.shouldShowSeparator = true;
        view.separatorColor = UIColor.redColor;
        view.separatorWidth = 2;
        view.separatorEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
        view.separatorDashed = true;
        self.gridView = view;
        view;
    });
    [self.view addSubview:gridView];

    for (NSUInteger i = 0; i < 8; i++) {
        UIView *view = UIView.new;
        view.backgroundColor = HDRandomColor;
        [gridView addSubview:view];
    }

    [self updateViewConstraint];
}

- (void)updateViewConstraint {
    [self.gridView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self.gridView sizeThatFits:CGSizeMake(300, 0)]);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(30);
    }];

    [self.slider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view).multipliedBy(0.8);
        make.top.equalTo(self.gridView.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
    }];

    [self.slider1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(self.slider);
        make.top.equalTo(self.slider.mas_bottom).offset(30);
    }];

    [self.slider2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(self.slider);
        make.top.equalTo(self.slider1.mas_bottom).offset(30);
    }];

    [self.slider3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(self.slider);
        make.top.equalTo(self.slider2.mas_bottom).offset(30);
    }];

    [self.slider4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(self.slider);
        make.top.equalTo(self.slider3.mas_bottom).offset(30);
    }];

    [self.slider5 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.centerX.equalTo(self.slider);
        make.top.equalTo(self.slider4.mas_bottom).offset(30);
    }];
}

#pragma mark - event response
- (void)sliderValueChanged:(HDUISlider *)slider {
    self.gridView.subViewHMargin = 10 * slider.value;
    [self updateViewConstraint];
}

- (void)sliderValueChanged1:(HDUISlider *)slider {
    self.gridView.subViewVMargin = 15 * slider.value;
    [self updateViewConstraint];
}

- (void)sliderValueChanged2:(HDUISlider *)slider {
    self.gridView.rowHeight = 60 + 60 * slider.value;
    [self updateViewConstraint];
}

- (void)sliderValueChanged3:(HDUISlider *)slider {
    CGFloat value = slider.value;
    self.gridView.edgeInsets = UIEdgeInsetsMake(5 * value, 20 * value, 30 * value, 50 * value);
    [self updateViewConstraint];
}

- (void)sliderValueChanged4:(HDUISlider *)slider {
    CGFloat value = slider.value;
    self.gridView.separatorEdgeInsets = UIEdgeInsetsMake(10 * value, 5 * value, 10 * value, 5 * value);
    [self updateViewConstraint];
}

- (void)sliderValueChanged5:(HDUISlider *)slider {
    self.gridView.separatorWidth = 6 * slider.value;
    [self updateViewConstraint];
}

@end
