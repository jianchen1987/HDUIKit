//
//  HDUnitTextFieldViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDUnitTextFieldViewController.h"

@interface HDUnitTextFieldViewController () <HDUnitTextFieldDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;  ///< 容器
@end

@implementation HDUnitTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];

    _scrollView.frame = CGRectMake(0, self.hd_navigationBar.bottom, self.view.width, self.view.height - self.hd_navigationBar.bottom);

    HDUnitTextField *textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:4];
    textField.delegate = self;
    textField.cursorColor = UIColor.blueColor;
    textField.trackTintColor = UIColor.redColor;
    [textField addTarget:self action:@selector(unitTextFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(unitTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(unitTextFieldEditingDidEnd:) forControlEvents:UIControlEventEditingDidEnd];
    textField.autoResignFirstResponderWhenInputFinished = true;
    [_scrollView addSubview:textField];

    textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleUnderline inputUnitCount:6];
    textField.delegate = self;
    textField.secureTextEntry = true;
    textField.keyboardType = UIKeyboardTypeDefault;
    [_scrollView addSubview:textField];

    textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:5];
    textField.delegate = self;
    textField.unitSpace = 0;
    textField.textContentType = UITextContentTypeOneTimeCode;
    textField.keyboardType = UIKeyboardTypeDefault;
    [_scrollView addSubview:textField];

    textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:5];
    textField.delegate = self;
    textField.unitSpace = 0;
    textField.borderRadius = 5;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.unitSpace = 10;
    textField.cursorColor = UIColor.greenColor;
    [_scrollView addSubview:textField];

    textField = [[HDUnitTextField alloc] initWithStyle:HDUnitTextFieldStyleBorder inputUnitCount:5];
    textField.delegate = self;
    textField.unitSpace = 0;
    textField.secureTextEntry = true;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.borderRadius = 10;
    textField.borderWidth = 3;
    [_scrollView addSubview:textField];

    CGFloat margin = kRealWidth(50), width = kScreenWidth - margin;

    UIView *refView;
    for (UIView *view in _scrollView.subviews) {
        [view hd_makeFrameLayout:^(HDFrameLayoutMaker *_Nonnull make) {
            if (!refView) {
                make.top.equalToValue(20);
            } else {
                make.top.hd_equalTo(refView.bottom).offset(30);
            }
            make.height.equalTo(@50);
            make.width.equalToValue(width);
            make.centerX.hd_equalTo(self.view.width * 0.5);
        }];
        refView = view;
    }

    UIView *lastView = _scrollView.subviews.lastObject;
    _scrollView.contentSize = CGSizeMake(self.view.width, lastView.bottom + margin);
}

- (BOOL)unitTextField:(HDUnitTextField *)unitTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *text = nil;
    if (range.location >= unitTextField.text.length) {
        text = [unitTextField.text stringByAppendingString:string];
    } else {
        text = [unitTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    HDLog(@"******>%@", text);

    return YES;
}

- (void)unitTextFieldEditingChanged:(HDUnitTextField *)sender {
    HDLog(@"%s %@", __FUNCTION__, sender.text);
}

- (void)unitTextFieldEditingDidBegin:(id)sender {
    HDLog(@"%s", __FUNCTION__);
}

- (void)unitTextFieldEditingDidEnd:(id)sender {
    HDLog(@"%s", __FUNCTION__);
}
@end
