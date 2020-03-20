//
//  HDCitySearchViewController.h
//  HDUIKit
//
//  Created by VanJay on 2019/9/26.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDCityModel;

@interface HDCitySearchViewController : UITableViewController
/** 搜索文字 */
@property (nonatomic, copy) NSString *searchText;
@property (nonatomic, copy) void (^choosedCityModelHandler)(HDCityModel *cityModel);
@end
