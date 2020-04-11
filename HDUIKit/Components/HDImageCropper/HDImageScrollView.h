//
//  HDImageScrollView.h
//  HDUIKit
//
//  Created by VanJay on 2020/4/11.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDImageScrollView : UIScrollView

@property (nonatomic, nullable, strong) UIImageView *zoomView;
@property (nonatomic, assign) BOOL aspectFill;

- (void)displayImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
