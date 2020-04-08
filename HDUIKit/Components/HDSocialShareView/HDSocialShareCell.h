//
//  HDSocialShareCell.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDSocialShareCellModel;

NS_ASSUME_NONNULL_BEGIN

@interface HDSocialShareCell : UICollectionViewCell
+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath;
@property (nonatomic, strong) HDSocialShareCellModel *model;  ///< 配置
@end

NS_ASSUME_NONNULL_END
