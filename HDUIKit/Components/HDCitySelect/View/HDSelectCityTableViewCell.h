//
//  HDSelectCityTableViewCell.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDCityModel, HDSelectCityTableViewCell;

FOUNDATION_EXPORT NSString *const kNotificationCitySelectLocationInfoChanged;

@protocol HDSelectCityTableViewCellDelegate <NSObject>

- (void)selectCityTableViewCell:(HDSelectCityTableViewCell *)tableViewCell didSelectedCity:(HDCityModel *)cityModel;

@end

@interface HDSelectCityTableViewCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) NSArray<HDCityModel *> *cities;
@property (nonatomic, weak) id<HDSelectCityTableViewCellDelegate> cellDelegate;

@end
