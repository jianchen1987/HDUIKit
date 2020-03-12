//
//  HDKeyboardViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/12.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDKeyboardViewController.h"

@interface HDKeyboardViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;                                ///< 容器
@property (nonatomic, strong) NSMutableArray<NSDictionary<NSString *, id> *> *config;  ///<  数据源
@end

@implementation HDKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [_scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedScrollView)]];
    [self.view addSubview:_scrollView];

    _scrollView.frame = CGRectMake(0, self.hd_navigationBar.bottom, self.view.width, self.view.height - self.hd_navigationBar.bottom);

    for (NSDictionary *dict in self.config) {
        NSString *desc = dict[@"desc"];
        HDKeyBoard *kb = dict[@"kb"];

        UILabel *lb = [[UILabel alloc] init];
        lb.textColor = HexColor(0x5d667f);
        lb.font = [UIFont systemFontOfSize:16];
        lb.text = desc;
        [self.scrollView addSubview:lb];

        UITextField *tf = [[UITextField alloc] init];
        kb.inputSource = tf;
        tf.inputView = kb;
        [self.scrollView addSubview:tf];
    }

    CGFloat margin = kRealWidth(50), width = kScreenWidth - margin;

    UIView *refView;
    for (UIView *view in _scrollView.subviews) {
        [view wj_makeFrameLayout:^(WJFrameLayoutMaker *_Nonnull make) {
            if (!refView) {
                make.top.equalToValue(20);
            } else {
                make.top.wj_equalTo(refView.bottom).wj_offset([refView isKindOfClass:UILabel.class] ? kRealWidth(6) : kRealWidth(20));
            }
            make.height.equalTo([view isKindOfClass:UILabel.class] ? @30 : @40);
            make.width.equalToValue(width);
            make.centerX.wj_equalTo(self.view.width * 0.5);
        }];

        if ([view isKindOfClass:UITextField.class]) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5 borderWidth:1 borderColor:UIColor.grayColor];
        }

        refView = view;
    }

    UIView *lastView = _scrollView.subviews.lastObject;
    _scrollView.contentSize = CGSizeMake(self.view.width, lastView.bottom + margin);
}

#pragma mark - event response
- (void)tappedScrollView {
    [self.view endEditing:YES];
}

#pragma mark - lazy load
- (NSMutableArray<NSDictionary<NSString *, id> *> *)config {
    if (!_config) {
        _config = [NSMutableArray array];

        HDKeyBoard *kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad];
        [_config addObject:@{@"desc": @"纯数字键盘",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPad isRandom:YES];
        [_config addObject:@{@"desc": @"数字键盘数字随机",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeDecimalPad];
        [_config addObject:@{@"desc": @"小数键盘",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeNumberPadCanSwitchToLetter];
        [_config addObject:@{@"desc": @"可以切换到字母键盘的数字键盘",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeASCII];
        [_config addObject:@{@"desc": @"特殊字符键盘",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapable];
        [_config addObject:@{@"desc": @"字母键盘",
                             @"kb": kb}];

        kb = [HDKeyBoard keyboardWithType:HDKeyBoardTypeLetterCapableCanSwitchToASCII];
        [_config addObject:@{@"desc": @"可以切换到特殊字符键盘的字母键盘",
                             @"kb": kb}];
    }
    return _config;
}

@end
