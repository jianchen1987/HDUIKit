//
//  HDSearchBarViewController.m
//  HDUIKit_Example
//
//  Created by VanJay on 2020/3/20.
//  Copyright © 2020 wangwanjie. All rights reserved.
//

#import "HDSearchBarViewController.h"

@interface HDSearchBarViewController () <HDSearchBarDelegate>
/// 搜索框
@property (nonatomic, strong) HDSearchBar *searchBar;
@end

@implementation HDSearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hd_statusBarStyle = UIStatusBarStyleDefault;
    [self.view addSubview:({
                   HDSearchBar *view = [HDSearchBar new];
                   view.frame = CGRectMake(0, kStatusBarH, CGRectGetWidth(self.view.frame), 44);
                   view.delegate = self;
                   view.backgroundColor = UIColor.clearColor;
                   [view setShowLeftButton:true animated:false];
                   view.textFieldHeight = 35;
                   view.buttonTitleColor = UIColor.redColor;
                   view.textColor = UIColor.whiteColor;
                   view.placeholderColor = UIColor.whiteColor;
                   view.inputFieldBackgrounColor = HexColor(0xEF1862);
                   view.searchImage = [UIImage imageNamed:@"icon_search_white"];
                   view;
               })];
}

#pragma mark - HDSearchBarDelegate
- (void)searchBarTextDidBeginEditing:(HDSearchBar *)searchBar {
    HDLog(@"开始编辑");
    [searchBar setShowRightButton:true animated:true];
}

- (void)searchBarLeftButtonClicked:(HDSearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)searchBarRightButtonClicked:(HDSearchBar *)searchBar {
    [searchBar endEditing:true];

    [searchBar setShowRightButton:false animated:true];
}

- (HDViewControllerNavigationBarStyle)hd_preferredNavigationBarStyle {
    return HDViewControllerNavigationBarStyleHidden;
}
@end
