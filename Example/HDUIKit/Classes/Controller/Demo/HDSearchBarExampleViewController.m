//
//  HDSearchBarExampleViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/9/2.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDSearchBarExampleViewController.h"

@interface HDSearchBarExampleViewController () <HDSearchBarDelegate>
/// 搜索栏
@property (nonatomic, strong) HDSearchBar *searchBar;

@end

@implementation HDSearchBarExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.searchBar];
}

- (void)updateViewConstraints {

    [self.searchBar mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [super updateViewConstraints];
}

#pragma mark - HDSearchBarDelegate
- (BOOL)searchBarShouldClear:(HDSearchBar *)searchBar {

    return true;
}

- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:true animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBarTextDidEndEditing:(HDSearchBar *)searchBar reason:(UITextFieldDidEndEditingReason)reason API_AVAILABLE(ios(10.0)) {
    [searchBar setShowRightButton:false animated:true];
}

- (void)searchBar:(HDSearchBar *)searchBar textDidChange:(NSString *)searchText {

    // 去除两端空格
    NSString *keyWord = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // 去除连续空格
    while ([keyWord rangeOfString:@"  "].location != NSNotFound) {
        keyWord = [keyWord stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
}

- (BOOL)searchBarShouldReturn:(HDSearchBar *)searchBar textField:(UITextField *)textField {
    [searchBar resignFirstResponder];
    [searchBar setShowRightButton:false animated:true];
    return true;
}

#pragma mark - lazy load

- (HDSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = HDSearchBar.new;
        _searchBar.delegate = self;
        _searchBar.textFieldHeight = 35;
        _searchBar.showBottomShadow = true;
        _searchBar.placeholderColor = HDAppTheme.color.G3;
        _searchBar.placeHolder = @"输点东西吧";
    }
    return _searchBar;
}
@end
