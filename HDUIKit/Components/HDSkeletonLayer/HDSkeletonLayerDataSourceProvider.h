//
//  HDSkeletonLayerDataSourceProvider.h
//  HDUIKit
//
//  Created by VanJay on 2019/5/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@protocol HDSkeletonLayerLayoutProtocol;

typedef UITableViewCell<HDSkeletonLayerLayoutProtocol> * (^HDSkeletonTableViewCellBlock)(UITableView *tableview, NSIndexPath *indexPath);
typedef CGFloat (^HDSkeletonTableViewCellHeightBlock)(UITableView *tableView, NSIndexPath *indexPath);

@interface HDSkeletonLayerDataSourceProvider : NSObject <UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

/** 默认20行 */
@property (nonatomic, assign) NSInteger numberOfRowsInSection;

/** 只有一种 cell 样式使用 */
- (instancetype)initWithCellReuseIdentifier:(NSString *)reuseIdentifier;
+ (instancetype)dataSourceProviderWithCellReuseIdentifier:(NSString *)reuseIdentifier;

/** 有多种 cell 样式使用 */
- (instancetype)initWithTableViewCellBlock:(HDSkeletonTableViewCellBlock)block
                               heightBlock:(HDSkeletonTableViewCellHeightBlock)heightBlock;

@end
