//
//  HDSocialShareCellModel.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/23.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HDSocialShareCellModel;

typedef void (^ClickedHandler)(HDSocialShareCellModel *model, NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface HDSocialShareCellModel : NSObject
@property (nonatomic, copy) NSString *title;        ///< 标题
@property (nonatomic, strong) UIImage *image;       ///< 图片
@property (nonatomic, strong) id associatedObject;  ///< 关联对象
@property (nonatomic, copy) ClickedHandler clickedHandler;

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image;

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image associatedObject:(id __nullable)associatedObject;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image associatedObject:(id __nullable)associatedObject;

+ (instancetype)modelWithTitle:(NSString *)title image:(UIImage *)image clickedHandler:(ClickedHandler __nullable)clickedHandler;
- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image clickedHandler:(ClickedHandler __nullable)clickedHandler;
@end

NS_ASSUME_NONNULL_END
