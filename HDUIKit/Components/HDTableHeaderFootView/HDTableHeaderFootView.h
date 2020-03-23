//
//  HDTableHeaderFootView.h
//  ViPay
//
//  Created by VanJay on 2019/9/30.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDTableHeaderFootViewModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDTableHeaderFootView : UITableViewHeaderFooterView

+ (instancetype)headerWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) HDTableHeaderFootViewModel *model;  ///< 数据模型
@property (nonatomic, copy) void (^rightButtonClickedHandler)(void);
@end
NS_ASSUME_NONNULL_END
