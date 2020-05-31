//
//  HDCategoryCollectionView.h
//  HDUIKit
//
//  Created by VanJay on 2020/5/31.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDCategoryIndicatorProtocol.h"
#import <UIKit/UIKit.h>

@class HDCategoryCollectionView;

@protocol HDCategoryCollectionViewGestureDelegate <NSObject>
@optional
- (BOOL)categoryCollectionView:(HDCategoryCollectionView *)collectionView gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer;
- (BOOL)categoryCollectionView:(HDCategoryCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer;
@end

@interface HDCategoryCollectionView : UICollectionView

@property (nonatomic, copy) NSArray<UIView<HDCategoryIndicatorProtocol> *> *indicators;
@property (nonatomic, weak) id<HDCategoryCollectionViewGestureDelegate> gestureDelegate;

@end
