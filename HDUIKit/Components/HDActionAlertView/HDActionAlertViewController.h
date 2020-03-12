//
//  HDActionAlertViewController.h
//  HDUIKit
//
//  Created by VanJay on 2019/8/1.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDActionAlertView.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** HDActionAlertViewController 声明一个controller来做actionview的容器，并加载到window上 */
@interface HDActionAlertViewController : UIViewController
@property (nonatomic, strong) HDActionAlertView *alertView;
@end

NS_ASSUME_NONNULL_END
