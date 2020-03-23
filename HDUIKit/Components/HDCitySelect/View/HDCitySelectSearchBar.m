//
//  HDCitySelectSearchBar.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCitySelectSearchBar.h"
#import "UIView+HDFrameLayout.h"

@implementation HDCitySelectSearchBar
#pragma mark - life cycle
- (void)commonInit {
    self.barTintColor = UIColor.whiteColor;
    self.backgroundImage = UIImage.new;
    self.backgroundColor = UIColor.whiteColor;
    UIView *searchField = [self valueForKey:@"searchField"];
    if ([searchField isKindOfClass:UITextField.class]) {
        searchField.backgroundColor = [UIColor colorWithRed:234 / 255.0 green:234 / 255.0 blue:234 / 255.0 alpha:1.0];
        searchField.layer.cornerRadius = 14;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView *view in self.subviews) {
        for (UIView *tempView in view.subviews) {
            if ([tempView isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                tempView.centerY = CGRectGetHeight(self.frame) * 0.5;
            } else if ([tempView isKindOfClass:NSClassFromString(@"UINavigationButton")]) {
                UIButton *btn = (UIButton *)tempView;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                tempView.centerY = CGRectGetHeight(self.frame) * 0.5;
            }
        }
    }
}

@end
