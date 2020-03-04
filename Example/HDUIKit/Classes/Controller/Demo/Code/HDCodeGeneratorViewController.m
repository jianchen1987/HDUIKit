//
//  HDCodeGeneratorViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/4.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDCodeGeneratorViewController.h"

@interface HDCodeGeneratorViewController ()
/// 条形码
@property (nonatomic, strong) UIImageView *barCodeImageV;
/// 二维码
@property (nonatomic, strong) UIImageView *qrCodeImageV;
/// 二维码带 logo
@property (nonatomic, strong) UIImageView *qrCodeWithLogoImageV;
@end

@implementation HDCodeGeneratorViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];

    [self initializeData];
}

- (void)setupUI {
    self.hd_navigationItem.title = @"条形码/二维码生成";

    [self.view addSubview:self.barCodeImageV];
    [self.view addSubview:self.qrCodeImageV];
    [self.view addSubview:self.qrCodeWithLogoImageV];

    [self.view setNeedsUpdateConstraints];
}

- (void)initializeData {
    self.barCodeImageV.image = [HDCodeGenerator barCodeImageForStr:@"65457768678789789786" size:CGSizeMake(kScreenWidth * 0.8, 60)];
    self.qrCodeImageV.image = [HDCodeGenerator qrCodeImageForStr:@"https://www.baidu.com" size:CGSizeMake(100, 100)];
    self.qrCodeWithLogoImageV.image = [HDCodeGenerator qrCodeImageForStr:@"https://www.baidu.com" size:CGSizeMake(150, 150) logoImage:[UIImage imageNamed:@"logo"] logoSize:CGSizeMake(30, 30) logoMargin:1];
}

- (void)updateViewConstraints {
    HDLog(@"布局");

    [self.barCodeImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).multipliedBy(0.8);
        make.height.mas_equalTo(60);
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.hd_navigationBar.mas_bottom).offset(30);
    }];

    [self.qrCodeImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 100));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.barCodeImageV.mas_bottom).offset(30);
    }];

    [self.qrCodeWithLogoImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(150, 150));
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.qrCodeImageV.mas_bottom).offset(30);
    }];

    [super updateViewConstraints];
}
#pragma mark - lazy load
- (UIImageView *)barCodeImageV {
    return _barCodeImageV ?: ({ _barCodeImageV = UIImageView.new; });
}

- (UIImageView *)qrCodeImageV {
    return _qrCodeImageV ?: ({ _qrCodeImageV = UIImageView.new; });
}

- (UIImageView *)qrCodeWithLogoImageV {
    return _qrCodeWithLogoImageV ?: ({ _qrCodeWithLogoImageV = UIImageView.new; });
}
@end
