//
//  HDUniversalButtonViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/4/1.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDUniversalButtonViewController.h"

@interface HDUniversalButtonViewController ()

@end

@implementation HDUniversalButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.numberOfLines = 0;
    [button setTitle:@"刚好v好家伙局用于ui办公椅u吧刚好v好家伙局用于ui办公椅u吧" forState:UIControlStateNormal];
    [button setTitleColor:UIColor.redColor forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"ic-home-selected"] forState:UIControlStateNormal];
    button.imagePosition = HDUIButtonImagePositionRight;
    button.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    button.titleEdgeInsets = UIEdgeInsetsMake(50, 20, 50, 10);
    button.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20);
    button.backgroundColor = UIColor.grayColor;
    [self.view addSubview:button];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(100);
        make.size.mas_equalTo([button sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)]);
    }];
}
@end
