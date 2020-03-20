//
//  HDSelectCityTableViewCell.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDSelectCityTableViewCell.h"
#import "HDAppTheme.h"
#import "HDCityModel.h"
#import "HDCommonDefines.h"
#import "HDFloatLayoutView.h"
#import "HDUIGhostButton.h"
#import "Masonry.h"
#import "NSBundle+HDUIKit.h"
#import "NSObject+HDUIKit.h"

NSString *const kNotificationCitySelectLocationInfoChanged = @"kNotificationCitySelectLocationInfoChanged";

@interface HDSelectCityTableViewCell ()
@property (nonatomic, strong) HDFloatLayoutView *floatLayoutView;  ///< 所有标签
@end

@implementation HDSelectCityTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    // 新建标识
    static NSString *ID = @"HDSelectCityTableViewCell";

    // 创建cell
    HDSelectCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.floatLayoutView];

        // 监听位置改变
        [[NSNotificationCenter defaultCenter] addObserverForName:kNotificationCitySelectLocationInfoChanged
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification *_Nonnull note) {
                                                          if (self.cities.count > 0 && self.cities.firstObject.isLocationCell) {
                                                              [self reloadDataWithDataSource:self.cities];
                                                          }
                                                      }];
    }
    return self;
}

- (void)updateConstraints {
    [self.floatLayoutView mas_remakeConstraints:^(MASConstraintMaker *make) {
        CGFloat floatLayoutViewWidth = kScreenWidth - 2 * 10;
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView);
        CGSize size = [self.floatLayoutView sizeThatFits:CGSizeMake(floatLayoutViewWidth, CGFLOAT_MAX)];
        make.size.mas_equalTo(size);
    }];

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return true;
}

- (void)setCities:(NSArray<HDCityModel *> *)cities {
    _cities = cities;

    [self reloadDataWithDataSource:cities];
}

#pragma mark - private methods
- (void)reloadDataWithDataSource:(NSArray<HDCityModel *> *)dataSource {
    [self.floatLayoutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (HDCityModel *model in dataSource) {
        HDUIGhostButton *button = HDUIGhostButton.new;
        UIColor *textColor = [HDAppTheme HDColorG2];
        UIFont *textFont = [HDAppTheme HDFontStandard3];
        NSString *imageName = nil;
        if (model.isLocationCell) {
            if (model.locationState == HDCitySelectLocationStateSuccees) {
                textColor = [HDAppTheme HDColorG1];
                textFont = [HDAppTheme HDFontStandard2Bold];
                imageName = @"ic_found_localtion";
                button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
            } else {
                textColor = [HDAppTheme HDColorG2];
                textFont = [HDAppTheme HDFontStandard3];
                button.imageEdgeInsets = UIEdgeInsetsZero;
            }
        }
        [button setTitleColor:textColor forState:UIControlStateNormal];
        [button setTitle:model.name forState:UIControlStateNormal];
        if (imageName) {
            [button setImage:[UIImage imageNamed:imageName inBundle:[NSBundle hd_UIKITCitySelectResources] compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        }
        button.titleLabel.font = textFont;
        button.backgroundColor = HexColor(0xF5F7FA);
        button.contentEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        [button sizeToFit];
        button.hd_associatedObject = model;
        [button addTarget:self action:@selector(clickedButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
        [self.floatLayoutView addSubview:button];
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - event response
- (void)clickedButtonHandler:(HDUIGhostButton *)button {
    HDCityModel *cityModel = button.hd_associatedObject;

    if ([self.cellDelegate respondsToSelector:@selector(selectCityTableViewCell:didSelectedCity:)]) {
        [self.cellDelegate selectCityTableViewCell:self didSelectedCity:cityModel];
    }
}

#pragma mark - lazy load
- (HDFloatLayoutView *)floatLayoutView {
    if (!_floatLayoutView) {
        _floatLayoutView = HDFloatLayoutView.new;
        _floatLayoutView.itemMargins = UIEdgeInsetsMake(0, 0, 8, 15);
        _floatLayoutView.padding = UIEdgeInsetsMake(12, 13, 12, 13);
    }
    return _floatLayoutView;
}
@end
